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
    params.fn = params.fn or 64
    return cad.cylinder(params)
end

function rounded_cube(x, y, z, radius)
    rc_r = math.min(radius, x / 2, y / 2)

    rc_c1 = 0
    rc_c2 = 0
    rc_c3 = 0
    rc_c4 = 0

    rc_c1 = anchored_cylinder({h = z, r = rc_r})
    rc_c1 = cad.modify.translate(rc_c1, {rc_r, rc_r, 0})

    rc_c2 = anchored_cylinder({h = z, r = rc_r})
    rc_c2 = cad.modify.translate(rc_c2, {x - rc_r, rc_r, 0})

    rc_c3 = anchored_cylinder({h = z, r = rc_r})
    rc_c3 = cad.modify.translate(rc_c3, {rc_r, y - rc_r, 0})

    rc_c4 = anchored_cylinder({h = z, r = rc_r})
    rc_c4 = cad.modify.translate(rc_c4, {x - rc_r, y - rc_r, 0})

    return cad.hull({rc_c1, rc_c2, rc_c3, rc_c4})
end

function rounded_triangle(a, b, thickness, radius)
    rt_r = math.min(radius, a / 4, b / 4)
    rt_L = math.sqrt(a * a + b * b)

    rt_c1 = 0
    rt_c2 = 0
    rt_c3 = 0

    rt_c1 = anchored_cylinder({h = thickness, r = rt_r})
    rt_c1 = cad.modify.translate(rt_c1, {rt_r, rt_r, 0})

    rt_c2 = anchored_cylinder({h = thickness, r = rt_r})
    rt_c2 = cad.modify.translate(rt_c2, {a - rt_r * (rt_L + a) / b, rt_r, 0})

    rt_c3 = anchored_cylinder({h = thickness, r = rt_r})
    rt_c3 = cad.modify.translate(rt_c3, {rt_r, b - rt_r * (rt_L + b) / a, 0})

    return cad.hull({rt_c1, rt_c2, rt_c3})
end

function rounded_tab(width, length, thickness, radius, is_rear)
    r = math.min(radius, length, width / 2)

    main_rect = 0
    side_rect = 0
    cyl1 = 0
    cyl2 = 0

    if not is_rear then
        main_rect = anchored_cube({x = width - 2 * r, y = length, z = thickness})
        main_rect = cad.modify.translate(main_rect, {r, 0, 0})

        side_rect = anchored_cube({x = width, y = length - r, z = thickness})
        side_rect = cad.modify.translate(side_rect, {0, r, 0})

        cyl1 = anchored_cylinder({h = thickness, r = r})
        cyl1 = cad.modify.translate(cyl1, {r, r, 0})

        cyl2 = anchored_cylinder({h = thickness, r = r})
        cyl2 = cad.modify.translate(cyl2, {width - r, r, 0})
    else
        main_rect = anchored_cube({x = width - 2 * r, y = length, z = thickness})
        main_rect = cad.modify.translate(main_rect, {r, 0, 0})

        side_rect = anchored_cube({x = width, y = length - r, z = thickness})

        cyl1 = anchored_cylinder({h = thickness, r = r})
        cyl1 = cad.modify.translate(cyl1, {r, length - r, 0})

        cyl2 = anchored_cylinder({h = thickness, r = r})
        cyl2 = cad.modify.translate(cyl2, {width - r, length - r, 0})
    end

    return cad.union({main_rect, side_rect, cyl1, cyl2})
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
    mark = cad.modify.scale(mark, {-1, 1, 1})
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

    -- 2. Base Plate Parameters
    length_shift = tolerance / math.sin(math.rad(skel.diagonal))
    total_length = utils.round(skel.y_offset + length_shift, 4)
    base_width = utils.round(dims.base_diameter / 3, 4)
    neck_rest_base_length = utils.round(total_length / 8, 4)

    tab_radius = utils.round(thickness, 4)

    -- 3. Base Plate Construction
    spine = rounded_cube(base_width, total_length, thickness, tab_radius)
    spine = cad.modify.translate(spine, {base_width, 0, 0})

    front_tab = rounded_tab(dims.base_diameter, neck_rest_base_length, thickness, tab_radius, false)

    rear_tab = rounded_tab(dims.base_diameter, neck_rest_base_length, thickness, tab_radius, true)
    rear_tab = cad.modify.translate(rear_tab, {0, total_length - neck_rest_base_length, 0})

    base_plate = cad.union({spine, front_tab, rear_tab})

    -- 4. Neck Rest Tower Construction
    neck_bottom_z_at_target = skel.neck_rest_target.z - skel.vertical_radius_neck
    neck_rest_body_height = utils.round(neck_bottom_z_at_target - tolerance - thickness, 4)
    neck_rest_head_height = utils.round(vpro(skel.neck_radius, skel.diagonal), 4)

    -- Neck Rest Body
    neck_rest_body = rounded_cube(skel.base_radius, thickness, neck_rest_body_height, tab_radius)
    neck_rest_body = cad.modify.translate(neck_rest_body, {skel.base_radius / 2, 0, thickness})

    -- Neck Rest Head
    neck_rest_head = rounded_cube(skel.base_radius, thickness, neck_rest_head_height, tab_radius)
    neck_rest_head = cad.modify.rotate(neck_rest_head, {-angle, 0, 0})
    neck_rest_head = cad.modify.translate(neck_rest_head, {skel.base_radius / 2, 0, thickness + neck_rest_body_height})

    -- Neck Cutout
    cutout_radius = skel.neck_radius + tolerance
    cutout_height_len = dims.neck_height * 2
    cutout = anchored_cylinder({h = cutout_height_len, r1 = cutout_radius, r2 = cutout_radius})
    cutout = cad.modify.rotate(cutout, {skel.diagonal, 0, 0})

    start_shift = dims.neck_height * 0.5
    start_y = skel.neck_rest_target.y - start_shift * skel.axis_y_comp
    start_z = skel.neck_rest_target.z - start_shift * skel.axis_z_comp
    cutout = cad.modify.translate(cutout, {skel.base_radius, start_y, start_z})

    cutout_top = anchored_cylinder({h = cutout_height_len, r1 = cutout_radius * 1.2, r2 = cutout_radius * 1.2})
    cutout_top = cad.modify.rotate(cutout_top, {skel.diagonal, 0, 0})
    cutout_top = cad.modify.translate(cutout_top, {skel.base_radius, start_y, start_z + skel.neck_radius})

    full_cutout = cad.hull({cutout, cutout_top})

    neck_rest = cad.union({neck_rest_body, neck_rest_head})
    neck_rest = cad.difference({neck_rest, full_cutout})

    -- 5. Base Rest Supports (Left & Right)
    a = vpro(skel.base_radius, skel.diagonal)
    b = hpro(skel.base_radius, skel.diagonal)

    base_rest_left = rounded_triangle(a, b, thickness, tab_radius)
    base_rest_left = cad.modify.rotate(base_rest_left, {180, 270, 0})
    base_rest_left = cad.modify.translate(base_rest_left, {base_width, total_length, thickness})

    base_rest_right = rounded_triangle(a, b, thickness, tab_radius)
    base_rest_right = cad.modify.rotate(base_rest_right, {180, 270, 0})
    base_rest_right = cad.modify.translate(base_rest_right, {base_width * 2 - thickness, total_length, thickness})

    -- 6. Ruler Plate Construction
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

    ruler = rounded_triangle(r_h, r_l, thickness, tab_radius)
    ruler = cad.modify.rotate(ruler, {0, 270, 0})
    ruler = cad.modify.translate(ruler, {skel.base_radius + thickness / 2, thickness, thickness})

    -- 7. Engravings
    engrave_depth = utils.round(thickness * 0.4, 4)
    commit_id = get_commit_id()
    flask_id = get_engraving_id(dims)

    max_len = math.max(#commit_id, #flask_id)
    text_size = (base_width - 2 * thickness) / (max_len * 1.2 - 0.2)
    text_size = utils.round(math.min(text_size, base_width * 0.12), 4)

    commit_width = utils.round((#commit_id * 1.2 - 0.2) * text_size, 4)
    flask_width = utils.round((#flask_id * 1.2 - 0.2) * text_size, 4)

    commit_x = utils.round(base_width / 2 - commit_width / 2, 4)
    flask_x = utils.round(2.5 * base_width - flask_width / 2, 4)

    commit_mark = create_engraving_mark(commit_id, text_size, engrave_depth)
    commit_mark = cad.modify.translate(commit_mark, {
        commit_x,
        utils.round(neck_rest_base_length / 2, 4),
        -0.01
    })

    flask_mark = create_engraving_mark(flask_id, text_size, engrave_depth)
    flask_mark = cad.modify.translate(flask_mark, {
        flask_x,
        utils.round(neck_rest_base_length / 2, 4),
        -0.01
    })

    -- 8. Combine and Engrave
    holder = cad.union({
        base_plate,
        neck_rest,
        base_rest_left,
        base_rest_right,
        ruler
    })
    holder = cad.difference({
        holder,
        commit_mark,
        flask_mark
    })

    return holder
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
