-- Piece 1: Base Plate for modular CVS flask holder

cad = require("cad")
dovetail = require("pieces.dovetail")

function anchored_cube(params)
    cube = cad.cube(params)
    return cad.modify.translate(cube, {params.x / 2, params.y / 2, params.z / 2})
end

function build_base_plate(dims, thickness, total_length, neck_rest_base_length, base_width, skel, dt, commit_mark, flask_mark)
    -- Base Spine
    base = anchored_cube({x = base_width, y = total_length, z = thickness})
    base = cad.modify.translate(base, {base_width, 0, 0})

    -- Front Rest Base
    neck_rest_base = anchored_cube({x = dims.base_diameter, y = neck_rest_base_length, z = thickness})

    -- Back Rest Base
    base_rest_base = anchored_cube({x = dims.base_diameter, y = neck_rest_base_length, z = thickness})
    base_rest_base = cad.modify.translate(base_rest_base, {0, total_length - neck_rest_base_length, 0})

    -- Combine into unified base plate
    base_plate = cad.union({base, neck_rest_base, base_rest_base})

    -- Apply provenance engravings
    base_plate = cad.difference({base_plate, commit_mark, flask_mark})

    -- Dovetail Slot parameters (adding tolerance to make slot larger)
    slot_w_base = dt.w_base + 2 * dt.tol
    slot_w_neck = dt.w_neck + 2 * dt.tol
    slot_h = dt.h + dt.tol

    -- 1. Front slot for Neck Rest Tower
    front_slot = dovetail.build_rail_y(neck_rest_base_length, slot_w_base, slot_w_neck, slot_h)
    front_slot = cad.modify.translate(front_slot, {skel.base_radius, 0, thickness})

    -- 2. Center slot for Ruler Plate (Diagonal Brace)
    center_slot_len = total_length - 2 * neck_rest_base_length
    center_slot = dovetail.build_rail_y(center_slot_len, slot_w_base, slot_w_neck, slot_h)
    center_slot = cad.modify.translate(center_slot, {skel.base_radius, neck_rest_base_length, thickness})

    -- 3. Rear slots for Base Rest Supports (Left & Right)
    rear_slot_left = dovetail.build_rail_y(neck_rest_base_length, slot_w_base, slot_w_neck, slot_h)
    rear_slot_left = cad.modify.translate(rear_slot_left, {base_width, total_length - neck_rest_base_length, thickness})

    rear_slot_right = dovetail.build_rail_y(neck_rest_base_length, slot_w_base, slot_w_neck, slot_h)
    rear_slot_right = cad.modify.translate(rear_slot_right, {base_width * 2 - thickness, total_length - neck_rest_base_length, thickness})

    -- Cut all slots out of the base plate
    base_plate = cad.difference({base_plate, front_slot, center_slot, rear_slot_left, rear_slot_right})

    return base_plate
end

return {
    build_base_plate = build_base_plate
}
