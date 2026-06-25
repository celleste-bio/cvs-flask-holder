-- Piece 2: Neck Rest Tower for modular CVS flask holder

cad = require("cad")
dovetail = require("pieces.dovetail")
utils = require("lib.utils")

function anchored_cube(params)
    cube = cad.cube(params)
    return cad.modify.translate(cube, {params.x / 2, params.y / 2, params.z / 2})
end

function anchored_cylinder(params)
    height = params.h or params.height
    cylinder = cad.cylinder(params)
    return cad.modify.translate(cylinder, {0, 0, height / 2})
end

function build_neck_rest(dims, angle, thickness, tolerance, skel, dt, total_length, neck_rest_base_length)
    neck_bottom_z_at_target = skel.neck_rest_target.z - skel.vertical_radius_neck
    neck_rest_body_height = utils.round(neck_bottom_z_at_target - tolerance - thickness, 4)
    neck_rest_head_height = utils.round(vpro(skel.neck_radius, skel.diagonal), 4)

    -- Foot block
    neck_foot = anchored_cube({x = skel.base_radius, y = neck_rest_base_length, z = thickness})
    neck_foot = cad.modify.translate(neck_foot, {skel.base_radius / 2, 0, 0})

    -- Male Dovetail Rail at bottom of foot
    foot_rail = dovetail.build_rail_y(neck_rest_base_length, dt.w_base, dt.w_neck, dt.h)
    foot_rail = cad.modify.translate(foot_rail, {skel.base_radius, 0, 0})

    -- Neck Rest Body
    neck_rest_body = anchored_cube({x = skel.base_radius, y = thickness, z = neck_rest_body_height})
    neck_rest_body = cad.modify.translate(neck_rest_body, {skel.base_radius / 2, 0, 0})

    -- Neck Rest Head
    neck_rest_head = anchored_cube({x = skel.base_radius, y = thickness, z = neck_rest_head_height})
    neck_rest_head = cad.modify.rotate(neck_rest_head, {-angle, 0, 0})
    neck_rest_head = cad.modify.translate(neck_rest_head, {skel.base_radius / 2, 0, neck_rest_body_height})

    -- Neck Cutout
    cutout_radius = skel.neck_radius + tolerance
    cutout_height_len = dims.neck_height * 2
    cutout = anchored_cylinder({h = cutout_height_len, r1 = cutout_radius, r2 = cutout_radius})
    cutout = cad.modify.rotate(cutout, {skel.diagonal, 0, 0})

    start_shift = dims.neck_height * 0.5
    start_y = skel.neck_rest_target.y - start_shift * skel.axis_y_comp
    start_z = skel.neck_rest_target.z - start_shift * skel.axis_z_comp
    start_z = start_z - thickness
    cutout = cad.modify.translate(cutout, {skel.base_radius, start_y, start_z})

    cutout_top = anchored_cylinder({h = cutout_height_len, r1 = cutout_radius * 1.2, r2 = cutout_radius * 1.2})
    cutout_top = cad.modify.rotate(cutout_top, {skel.diagonal, 0, 0})
    cutout_top = cad.modify.translate(cutout_top, {skel.base_radius, start_y, start_z + skel.neck_radius})

    full_cutout = cad.hull({cutout, cutout_top})

    -- Combine tower parts
    neck_tower = cad.union({neck_foot, foot_rail, neck_rest_body, neck_rest_head})

    -- Cut slot on back for Ruler Plate (centered in X, at Y = thickness, running along Z)
    slot_w_base = dt.w_base + 2 * dt.tol
    slot_w_neck = dt.w_neck + 2 * dt.tol
    slot_h = dt.h + dt.tol
    back_slot = dovetail.build_rail_z(neck_rest_body_height, slot_w_base, slot_w_neck, slot_h)
    back_slot = cad.modify.translate(back_slot, {skel.base_radius, thickness, 0})

    -- Subtract slot and neck cutout
    neck_tower = cad.difference({neck_tower, back_slot, full_cutout})

    return neck_tower
end

return {
    build_neck_rest = build_neck_rest
}
