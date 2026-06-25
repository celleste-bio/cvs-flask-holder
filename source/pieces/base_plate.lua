-- Piece 1: H-Shaped Base Plate for modular CVS flask holder

cad = require("cad")
dovetail = require("pieces.dovetail")

function hpro(length, angle)
    return length * math.cos(math.rad(angle))
end

function anchored_cube(params)
    return cad.cube(params)
end

function build_base_plate(dims, thickness, total_length, neck_rest_base_length, base_width, skel, dt, commit_mark, flask_mark)
    -- 1. Main spine
    spine = anchored_cube({x = base_width, y = total_length, z = thickness})
    spine = cad.modify.translate(spine, {base_width, 0, 0})

    -- 2. Front tab (neck rest base)
    front_tab = anchored_cube({x = dims.base_diameter, y = neck_rest_base_length, z = thickness})
    front_tab = cad.modify.translate(front_tab, {0, 0, 0})

    -- 3. Rear tab (base rest base)
    rear_tab = anchored_cube({x = dims.base_diameter, y = neck_rest_base_length, z = thickness})
    rear_tab = cad.modify.translate(rear_tab, {0, total_length - neck_rest_base_length, 0})

    -- Combine into H-shaped plate
    base_plate = cad.union({spine, front_tab, rear_tab})

    -- Slot dimensions with sliding tolerances
    slot_w_base = dt.w_base + 2 * dt.tol
    slot_w_neck = dt.w_neck + 2 * dt.tol
    slot_h = dt.h + dt.tol

    -- 4. Front slot for Neck Rest Tower
    front_slot = dovetail.build_rail_y(neck_rest_base_length, slot_w_base, slot_w_neck, slot_h)
    front_slot = cad.modify.translate(front_slot, {skel.base_radius, 0, thickness})

    -- 5. Center slot for Ruler Plate (Diagonal Brace)
    center_slot_len = total_length - 2 * neck_rest_base_length
    center_slot = dovetail.build_rail_y(center_slot_len, slot_w_base, slot_w_neck, slot_h)
    center_slot = cad.modify.translate(center_slot, {skel.base_radius, neck_rest_base_length, thickness})

    -- 6. Rear slots for Base Rest Supports (Left & Right)
    b = hpro(skel.base_radius, skel.diagonal)

    left_slot = dovetail.build_rail_y(b, slot_w_base, slot_w_neck, slot_h)
    left_slot = cad.modify.translate(left_slot, {base_width + thickness / 2, total_length - b, thickness})

    right_slot = dovetail.build_rail_y(b, slot_w_base, slot_w_neck, slot_h)
    right_slot = cad.modify.translate(right_slot, {base_width * 2 - thickness / 2, total_length - b, thickness})

    -- Cut all slots and engravings
    base_plate = cad.difference({base_plate, front_slot, center_slot, left_slot, right_slot, commit_mark, flask_mark})

    return base_plate
end

return {
    build_base_plate = build_base_plate
}
