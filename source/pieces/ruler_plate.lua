-- Piece 4: Ruler Plate / Diagonal Brace for modular CVS flask holder

cad = require("cad")
dovetail = require("pieces.dovetail")
utils = require("lib.utils")


function right_angle_triangle(a, b, thickness)
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

function build_ruler_plate(dims, thickness, tolerance, angle, skel, dt, neck_rest_base_length)
    neck_bottom_z_at_target = skel.neck_rest_target.z - skel.vertical_radius_neck
    neck_rest_body_height = utils.round(neck_bottom_z_at_target - tolerance - thickness, 4)

    -- Ruler Plate math
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

    ruler = right_angle_triangle(r_h, r_l, dt.w_base)
    ruler = cad.modify.rotate(ruler, {0, 270, 0})
    ruler = cad.modify.translate(ruler, {skel.base_radius + dt.w_base / 2, thickness, thickness})

    -- Cutout for Neck Rest Tower's foot block (so it sits on top of the foot at the front)
    cut_x = thickness * 2
    cut_y = neck_rest_base_length - thickness
    cut_z = thickness
    foot_cutout = anchored_cube({x = cut_x, y = cut_y, z = cut_z})
    foot_cutout = cad.modify.translate(foot_cutout, {skel.base_radius - thickness, thickness, thickness})

    ruler = cad.difference({ruler, foot_cutout})

    -- Bottom rail along Y (starts at Y = neck_rest_base_length, ends at Y = thickness + r_l)
    bottom_rail_len = (thickness + r_l) - neck_rest_base_length
    bottom_rail = dovetail.build_rail_y(bottom_rail_len, dt.w_base, dt.w_neck, dt.h)
    bottom_rail = cad.modify.translate(bottom_rail, {skel.base_radius, neck_rest_base_length, thickness})

    -- Front rail along Z (starts at Z = 2 * thickness, height goes up by r_h - thickness)
    front_rail_h = r_h - thickness
    front_rail = dovetail.build_rail_z(front_rail_h, dt.w_base, dt.w_neck, dt.h)
    front_rail = cad.modify.translate(front_rail, {skel.base_radius, thickness, 2 * thickness})

    -- Combine ruler body with its rails
    return cad.union({ruler, bottom_rail, front_rail})
end

return {
    build_ruler_plate = build_ruler_plate
}
