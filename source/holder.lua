-- Luametry entry: build the holder model from a measurements YAML.

script_dir = string.match(debug.getinfo(1).source, "@(.*[/\\])") or "./"
bootstrap = dofile(script_dir .. "bootstrap.lua")
bootstrap.configure_imports(script_dir)

const utils = require("lib.utils")
const cad = require("cad")
const flask_geom = require("flask_geom")

-- Helper: Horizontal Projection
function hpro(length, angle)
    return length * math.cos(math.rad(angle))
end

-- Helper: Vertical Projection
function vpro(length, angle)
    return length * math.sin(math.rad(angle))
end

function right_angle_triangle(a, b, thickness)
    if type(a) != "number" or type(b) != "number" or type(thickness) != "number" then
        error("right_angle_triangle(a, b, thickness) requires numeric inputs.")
    end
    if a <= 0 or b <= 0 or thickness <= 0 then
        error("Triangle side lengths and thickness must be positive.")
    end

    polygon_points = {
        {0, 0},
        {a, 0},
        {0, b},
        {0, 0}
    }

    return cad.extrude(polygon_points, thickness)
end

--------------------------------------------------------------------------------
-- SKELETON CALCULATOR
-- Single Source of Truth for all geometric positions
--------------------------------------------------------------------------------
function calculate_skeleton(dims, angle, thickness, tolerance)
    s = {}

    -- Inputs
    s.angle = angle
    s.diagonal = 90 - angle
    s.thickness = thickness
    s.tolerance = tolerance
    s.dims = dims
    s.neck_radius = dims.neck_diameter / 2
    s.base_radius = dims.base_diameter / 2

    -- 1. Flask Axis Geometry (Projected in Y-Z plane)
    rad_angle = math.rad(s.angle)
    s.axis_y_comp = -math.cos(rad_angle) -- Negative Y direction
    s.axis_z_comp = math.sin(rad_angle)  -- Positive Z direction
    s.axis_slope  = s.axis_z_comp / s.axis_y_comp

    -- 2. Vertical Clearance (Z-Offset)
    s.vertical_radius_base = s.base_radius * math.cos(rad_angle)
    s.vertical_radius_neck = s.neck_radius * math.cos(rad_angle)
    s.z_offset = utils.round(thickness + tolerance + s.vertical_radius_base, 4)

    -- 3. Horizontal Positioning (Y-Offset)
    s.y_offset = utils.round(hpro(dims.body_height, angle) + hpro(s.neck_radius, s.diagonal) + hpro(thickness, angle), 4)

    -- 4. Key Point: BASE CENTER
    s.base_center = {x=0, y=s.y_offset, z=s.z_offset}

    -- 5. Key Point: SHOULDER (Start of Neck)
    s.shoulder = {
        x = 0,
        y = s.base_center.y + dims.body_height * s.axis_y_comp,
        z = s.base_center.z + dims.body_height * s.axis_z_comp
    }

    -- 6. Key Point: NECK END (Rim)
    s.neck_end = {
        x = 0,
        y = s.shoulder.y + dims.neck_height * s.axis_y_comp,
        z = s.shoulder.z + dims.neck_height * s.axis_z_comp
    }

    return s
end

function erlenmeyer_holder(dims, angle, thickness, tolerance)
    -- 1. Compute Geometry Skeleton
    skel = calculate_skeleton(dims, angle, thickness, tolerance)

    -- 2. Base Block Construction
    length_shift = tolerance / math.sin(math.rad(skel.diagonal))
    total_length = utils.round(skel.y_offset + length_shift, 4)
    base_width = utils.round(dims.base_diameter / 3, 4)
    base = cad.cube({x=base_width, y=total_length, z=thickness})
    base = cad.modify.translate(base, {base_width, 0, 0})

    -- 3. Neck Rest Construction
    neck_rest_base_length = utils.round(total_length / 8, 4)
    neck_rest_base = cad.cube({x=dims.base_diameter, y=neck_rest_base_length, z=thickness})

    neck_bottom_z_at_shoulder = skel.shoulder.z - skel.vertical_radius_neck
    neck_rest_body_height = utils.round(neck_bottom_z_at_shoulder - tolerance - thickness, 4)
    neck_rest_head_height = utils.round(vpro(skel.neck_radius, skel.diagonal), 4)

    neck_rest_body = cad.cube({x=skel.base_radius, y=thickness, z=neck_rest_body_height})
    neck_rest_body = cad.modify.translate(neck_rest_body, {skel.base_radius / 2, 0, 0})

    neck_rest_head = cad.cube({x=skel.base_radius, y=thickness, z=neck_rest_head_height})
    neck_rest_head = cad.modify.rotate(neck_rest_head, {-angle, 0, 0})
    neck_rest_head = cad.modify.translate(neck_rest_head, {skel.base_radius / 2, 0, neck_rest_body_height})

    -- NECK CUTOUT
    cutout_radius = skel.neck_radius + tolerance
    cutout_height_len = dims.neck_height * 2
    cutout = cad.cylinder({h=cutout_height_len, r=cutout_radius})

    cutout = cad.modify.rotate(cutout, {skel.diagonal, 0, 0})

    start_shift = dims.neck_height * 0.5
    start_y = skel.shoulder.y - start_shift * skel.axis_y_comp
    start_z = skel.shoulder.z - start_shift * skel.axis_z_comp
    start_z = start_z - thickness

    cutout = cad.modify.translate(cutout, {skel.base_radius, start_y, start_z})

    cutout_top = cad.cylinder({h=cutout_height_len, r=cutout_radius * 1.4})
    cutout_top = cad.modify.rotate(cutout_top, {skel.diagonal, 0, 0})
    lift = skel.neck_radius
    cutout_top = cad.modify.translate(cutout_top, {skel.base_radius, start_y, start_z + lift})

    full_cutout = cad.hull({cutout, cutout_top})

    neck_rest = cad.union({neck_rest_base, neck_rest_body, neck_rest_head})
    neck_rest = cad.difference({neck_rest, full_cutout})

    -- 4. Base Rest Block
    base_rest_base = cad.cube({x=dims.base_diameter, y=neck_rest_base_length, z=thickness})
    base_rest_base = cad.modify.translate(base_rest_base, {0, total_length - neck_rest_base_length, 0})

    base_rest_left = right_angle_triangle(vpro(skel.base_radius, skel.diagonal), hpro(skel.base_radius, skel.diagonal), thickness)
    base_rest_left = cad.modify.rotate(base_rest_left, {180, 270, 0})
    base_rest_left = cad.modify.translate(base_rest_left, {base_width, total_length, 0})

    base_rest_right = right_angle_triangle(vpro(skel.base_radius, skel.diagonal), hpro(skel.base_radius, skel.diagonal), thickness)
    base_rest_right = cad.modify.rotate(base_rest_right, {180, 270, 0})
    base_rest_right = cad.modify.translate(base_rest_right, {base_width * 2 - thickness, total_length, 0})

    base_rest = cad.union({base_rest_base, base_rest_left, base_rest_right})

    -- 5. Ruler Plate (Connector)
    ruller_width_adjustment = tolerance / math.sin(math.rad(skel.diagonal))
    ruller_plate_clearance = thickness + tolerance
    ruller_plate_height = math.max(neck_rest_body_height - thickness - ruller_plate_clearance, thickness)
    ruller_plate = right_angle_triangle(ruller_plate_height, dims.chest_height - thickness - hpro(thickness, -angle) - ruller_width_adjustment, thickness)
    ruller_plate = cad.modify.rotate(ruller_plate, {0, 270, 0})
    ruller_plate = cad.modify.translate(ruller_plate, {skel.base_radius, thickness, thickness})

    result = cad.union({base, base_rest, neck_rest, ruller_plate})
    return result
end

function resolve_measurements_path()
    path = os.getenv("CVS_MEASUREMENTS")
    if (path == nil or path == "") and type(arg) == "table" then
        path = arg[1]
    end
    if path == nil or path == "" then
        error("CVS_MEASUREMENTS is not set and no measurements path was provided.")
    end
    return path
end

function env_truthy(value)
    if value == nil then return false end
    v = string.lower(tostring(value))
    return v == "1" or v == "true" or v == "yes" or v == "y"
end

measurements_path = resolve_measurements_path()
dims = utils.read_yaml(measurements_path)
dims.body_height = dims.total_height - dims.neck_height

erlenmeyer, chest_height = flask_geom.build_flask(dims)
dims.chest_height = chest_height

angle = 30
tolerance = 0.005
thickness = utils.round(dims.total_height / 50, 2)

holder = erlenmeyer_holder(dims, angle, thickness, tolerance)

with_flask = env_truthy(os.getenv("CVS_WITH_FLASK"))
if with_flask then
    x_offset = utils.round(dims.base_diameter / 2, 4)
    y_offset = utils.round(hpro(dims.body_height, angle) + hpro(dims.neck_diameter / 2, 90 - angle) + hpro(thickness, angle), 4)
    z_offset = utils.round(thickness + tolerance + vpro(dims.base_diameter / 2, 90 - angle), 4)

    erlenmeyer = cad.modify.rotate(erlenmeyer, {90 - angle, 0, 0})
    erlenmeyer = cad.modify.translate(erlenmeyer, {x_offset, y_offset, z_offset})
    return cad.union({holder, erlenmeyer})
end

return holder
