-- Luametry entry: build the holder model from a measurements YAML.

script_dir = string.match(debug.getinfo(1).source, "@(.*[/\\])") or "./"
bootstrap = dofile(script_dir .. "bootstrap.lua")
bootstrap.configure_imports(script_dir)

utils = require("lib.utils")
cad = require("cad")
flask_geom = require("flask_geom")

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

    return cad.extrude({
        {0, 0},
        {a, 0},
        {0, b},
        {0, 0}
    }, thickness)
end

function anchored_cube(params)
    return cad.cube(params)
end

function anchored_cylinder(params)
    return cad.cylinder(params)
end

function get_commit_id()
    commit_id = os.getenv("CVS_COMMIT_ID")
    if commit_id == nil or commit_id == "" then
        return "manual"
    end
    return tostring(commit_id)
end

function get_engraving_id(dims)
    engraving_id = dims.engraving_id or dims.flask_id
    if engraving_id == nil or engraving_id == "" then
        error("measurements.yaml must define engraving_id or flask_id for holder engraving")
    end

    return tostring(engraving_id)
end

function create_engraving_mark(label, text_size, depth)
    mark = cad.text(label, {
        h = text_size,
        t = 1.5,
        z = depth,
        rounded = true
    })
    mark = cad.modify.translate(mark, {0, -text_size / 2, depth / 2})
    mark = cad.modify.rotate(mark, {0, 0, 180})
    return mark
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
    s.axis_slope = s.axis_z_comp / s.axis_y_comp

    -- 2. Vertical Clearance (Z-Offset)
    s.vertical_radius_base = s.base_radius * math.cos(rad_angle)
    s.vertical_radius_neck = s.neck_radius * math.cos(rad_angle)
    s.z_offset = utils.round(thickness + tolerance + s.vertical_radius_base, 4)

    -- 3. Horizontal Positioning (Y-Offset)
    s.y_offset = utils.round(
        hpro(dims.body_height, angle) + hpro(s.neck_radius, s.diagonal) + hpro(thickness, angle),
        4
    )

    -- 4. Key Point: BASE CENTER
    s.base_center = {x = 0, y = s.y_offset, z = s.z_offset}

    -- 5. Key Point: SHOULDER (Start of Neck)
    s.shoulder = {
        x = 0,
        y = s.base_center.y + dims.body_height * s.axis_y_comp,
        z = s.base_center.z + dims.body_height * s.axis_z_comp
    }

    -- Extend the holder slightly past the exact neck start toward the conical body.
    s.neck_rest_target = {
        x = s.shoulder.x,
        y = s.shoulder.y - tolerance * s.axis_y_comp,
        z = s.shoulder.z - tolerance * s.axis_z_comp
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

    -- 2. Dovetail parameters
    dt = {
        h = utils.round(thickness * 0.5, 4),
        w_base = utils.round(thickness * 1.5, 4),
        w_neck = utils.round(thickness * 0.9, 4),
        tol = 0.015 -- 0.15 mm slide tolerance
    }

    -- 3. Calculate key lengths and positions
    length_shift = tolerance / math.sin(math.rad(skel.diagonal))
    total_length = utils.round(skel.y_offset + length_shift, 4)
    base_width = utils.round(dims.base_diameter / 3, 4)
    neck_rest_base_length = utils.round(total_length / 8, 4)

    -- 4. Load modular pieces
    base_plate_mod = require("pieces.base_plate")
    neck_rest_mod = require("pieces.neck_rest")
    base_rest_mod = require("pieces.base_rest")
    ruler_plate_mod = require("pieces.ruler_plate")

    -- 5. Create engravings
    commit_mark = create_engraving_mark(
        get_commit_id(),
        utils.round(base_width * 0.18, 4),
        utils.round(thickness + 0.2, 4)
    )
    commit_mark = cad.modify.translate(commit_mark, {
        utils.round(base_width, 4),
        utils.round(neck_rest_base_length / 2, 4),
        -0.1
    })

    flask_mark = create_engraving_mark(
        get_engraving_id(dims),
        utils.round(base_width * 0.18, 4),
        utils.round(thickness + 0.2, 4)
    )
    flask_mark = cad.modify.translate(flask_mark, {
        utils.round(dims.base_diameter - thickness, 4),
        utils.round(neck_rest_base_length / 2, 4),
        -0.1
    })

    -- 6. Build pieces in assembled coordinates
    base_plate = base_plate_mod.build_base_plate(dims, thickness, total_length, neck_rest_base_length, base_width, skel, dt, commit_mark, flask_mark)
    neck_tower = neck_rest_mod.build_neck_rest(dims, angle, thickness, tolerance, skel, dt, total_length, neck_rest_base_length)
    base_rest_left = base_rest_mod.build_left(dims, thickness, total_length, neck_rest_base_length, base_width, skel, dt)
    base_rest_right = base_rest_mod.build_right(dims, thickness, total_length, neck_rest_base_length, base_width, skel, dt)
    ruler = ruler_plate_mod.build_ruler_plate(dims, thickness, tolerance, angle, skel, dt, neck_rest_base_length)

    with_flask = env_truthy(os.getenv("CVS_WITH_FLASK"))
    assembled_only = env_truthy(os.getenv("CVS_ASSEMBLED"))

    if with_flask or assembled_only then
        -- Return assembled model
        neck_tower_assembled = cad.modify.translate(neck_tower, {0, 0, thickness})
        base_rest_left_assembled = cad.modify.translate(base_rest_left, {0, 0, thickness})
        base_rest_right_assembled = cad.modify.translate(base_rest_right, {0, 0, thickness})
        return cad.union({base_plate, neck_tower_assembled, base_rest_left_assembled, base_rest_right_assembled, ruler})
    else
        -- Return print layout (laying all parts flat on Z=0 plane)
        
        -- A. Base Plate: already at Z=0 to thickness
        base_plate_print = base_plate

        -- B. Neck Rest: rotate 90 around X to lie flat
        neck_bottom_z_at_target = skel.neck_rest_target.z - skel.vertical_radius_neck
        neck_rest_body_height = utils.round(neck_bottom_z_at_target - tolerance - thickness, 4)
        neck_rest_head_height = utils.round(vpro(skel.neck_radius, skel.diagonal), 4)
        neck_total_height = neck_rest_body_height + neck_rest_head_height * math.cos(math.rad(angle)) + thickness * math.sin(math.rad(angle))
        neck_flat = cad.modify.rotate(neck_tower, {90, 0, 0})
        neck_flat = cad.modify.translate(neck_flat, {
            -skel.base_radius / 2,
            neck_total_height,
            0
        })

        -- C. Left Support: rotate 90 around Y to lie flat
        a = vpro(skel.base_radius, skel.diagonal)
        b = hpro(skel.base_radius, skel.diagonal)
        foot_w = thickness * 2
        left_flat = cad.modify.rotate(base_rest_left, {0, 90, 0})
        left_flat = cad.modify.translate(left_flat, {
            dt.h,
            -(total_length - b),
            base_width + thickness/2 + foot_w/2
        })

        -- D. Right Support: rotate 90 around Y to lie flat
        right_flat = cad.modify.rotate(base_rest_right, {0, 90, 0})
        right_flat = cad.modify.translate(right_flat, {
            dt.h,
            -(total_length - b),
            base_width * 2 - thickness/2 + foot_w/2
        })

        -- E. Ruler Plate: rotate 90 around Y to lie flat
        ruler_width_adjustment = tolerance / math.sin(math.rad(skel.diagonal))
        ruler_plate_height = neck_rest_body_height - thickness
        ruler_plate_length = dims.chest_height - thickness - hpro(thickness, -angle) - ruler_width_adjustment
        ruler_plate_clearance = thickness + tolerance
        ruler_plate_scale = math.max(
            (ruler_plate_height - ruler_plate_clearance) / ruler_plate_height,
            thickness / ruler_plate_height
        )
        r_h = ruler_plate_height * ruler_plate_scale
        r_l = ruler_plate_length * ruler_plate_scale

        ruler_flat = cad.modify.rotate(ruler, {0, 90, 0})
        ruler_flat = cad.modify.translate(ruler_flat, {
            -(thickness - dt.h),
            -(thickness - dt.h),
            skel.base_radius + dt.w_base/2
        })

        -- Arrange in positive quadrant with a constant gap (0.3cm = 3mm)
        gap = 0.3
        
        -- Neck Rest next to Base Plate
        neck_print = cad.modify.translate(neck_flat, {dims.base_diameter + gap, 2 * b + 2 * gap, 0})

        -- Left Support next to Base Plate (below Neck Rest)
        left_print = cad.modify.translate(left_flat, {dims.base_diameter + gap, 0, 0})

        -- Right Support next to Base Plate (between Left Support and Neck Rest)
        right_print = cad.modify.translate(right_flat, {dims.base_diameter + gap, b + gap, 0})

        -- Ruler Plate to the right of Neck Rest and Supports
        max_width = math.max(a + dt.h, skel.base_radius)
        ruler_print = cad.modify.translate(ruler_flat, {dims.base_diameter + gap + max_width + gap, 0, 0})
        return cad.union({base_plate_print, neck_print, left_print, right_print, ruler_print})
    end
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
    y_offset = utils.round(
        hpro(dims.body_height, angle) + hpro(dims.neck_diameter / 2, 90 - angle) + hpro(thickness, angle),
        4
    )
    z_offset = utils.round(thickness + tolerance + vpro(dims.base_diameter / 2, 90 - angle), 4)

    erlenmeyer = cad.modify.rotate(erlenmeyer, {90 - angle, 0, 0})
    erlenmeyer = cad.modify.translate(erlenmeyer, {x_offset, y_offset, z_offset})
    return cad.union({holder, erlenmeyer})
end

return holder
