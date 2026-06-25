-- Piece 3: Base Rest Supports (Left & Right) for modular CVS flask holder

cad = require("cad")
dovetail = require("pieces.dovetail")

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

function build_base_rest_left(dims, thickness, total_length, neck_rest_base_length, base_width, skel, dt)
    a = vpro(skel.base_radius, skel.diagonal)
    b = hpro(skel.base_radius, skel.diagonal)
    
    tri = right_angle_triangle(a, b, thickness)
    tri = cad.modify.rotate(tri, {180, 270, 0})
    tri = cad.modify.translate(tri, {base_width, total_length, 0})

    foot_w = thickness * 2
    foot_l = b
    foot = anchored_cube({x = foot_w, y = foot_l, z = thickness})
    foot = cad.modify.translate(foot, {base_width + thickness / 2 - foot_w / 2, total_length - foot_l, 0})

    rail = dovetail.build_rail_y(foot_l, dt.w_base, dt.w_neck, dt.h)
    rail = cad.modify.translate(rail, {base_width + thickness / 2, total_length - foot_l, 0})

    return cad.union({tri, foot, rail})
end

function build_base_rest_right(dims, thickness, total_length, neck_rest_base_length, base_width, skel, dt)
    a = vpro(skel.base_radius, skel.diagonal)
    b = hpro(skel.base_radius, skel.diagonal)
    
    tri = right_angle_triangle(a, b, thickness)
    tri = cad.modify.rotate(tri, {180, 270, 0})
    tri = cad.modify.translate(tri, {base_width * 2 - thickness, total_length, 0})

    foot_w = thickness * 2
    foot_l = b
    foot = anchored_cube({x = foot_w, y = foot_l, z = thickness})
    foot = cad.modify.translate(foot, {base_width * 2 - thickness / 2 - foot_w / 2, total_length - foot_l, 0})

    rail = dovetail.build_rail_y(foot_l, dt.w_base, dt.w_neck, dt.h)
    rail = cad.modify.translate(rail, {base_width * 2 - thickness / 2, total_length - foot_l, 0})

    return cad.union({tri, foot, rail})
end

return {
    build_left = build_base_rest_left,
    build_right = build_base_rest_right
}
