-- Dovetail joint helper functions for CVS flask holder modular pieces.

cad = require("cad")

-- Build a male dovetail rail along the Y axis, protruding downwards in Z (from Z = 0 to Z = -h)
function build_rail_y(length, w_base, w_neck, h)
    points = {
        {-w_neck / 2, 0},
        {w_neck / 2, 0},
        {w_base / 2, h},
        {-w_base / 2, h},
        {-w_neck / 2, 0}
    }
    rail = cad.extrude(points, length)
    -- Rotate -90 degrees around X:
    -- Y (0 to h) -> Z (-h to 0)
    -- Z (0 to length) -> Y (0 to length)
    rail = cad.modify.rotate(rail, {-90, 0, 0})
    return rail
end

-- Build a male dovetail rail along the Z axis, protruding in the -Y direction (from Y = 0 to Y = -h)
function build_rail_z(length, w_base, w_neck, h)
    points = {
        {-w_neck / 2, 0},
        {w_neck / 2, 0},
        {w_base / 2, -h},
        {-w_base / 2, -h},
        {-w_neck / 2, 0}
    }
    return cad.extrude(points, length)
end

return {
    build_rail_y = build_rail_y,
    build_rail_z = build_rail_z
}
