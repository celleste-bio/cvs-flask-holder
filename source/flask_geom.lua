-- Shared flask geometry for Luametry-based models.

cad = require("cad")

function anchored_cylinder(params)
    params.fn = params.fn or 64
    return cad.cylinder(params)
end

function create_torus(minor_r, major_r)
    return cad.torus({major_r=major_r, minor_r=minor_r, major_segs=64, minor_segs=32})
end

function build_flask(dims)
    total_height = dims.total_height
    neck_height = dims.neck_height
    neck_radius = dims.neck_diameter / 2
    base_radius = dims.base_diameter / 2

    neck = anchored_cylinder({h=neck_height, r=neck_radius})
    rim_radius = neck_radius / 5
    rim = create_torus(rim_radius, neck_radius)
    rim = cad.modify.translate(rim, {0, 0, neck_height - rim_radius})
    head = cad.union({neck, rim})
    head = cad.modify.translate(head, {0, 0, total_height - neck_height})

    base_rim_scale = 3
    base_rim_radius = base_radius / base_rim_scale
    base = create_torus(base_rim_radius, base_radius - base_rim_radius/(base_rim_scale/3))
    chest_height = total_height - neck_height - (base_rim_radius * 2)
    chest = anchored_cylinder({h=chest_height, r1=base_radius - base_rim_radius, r2=neck_radius})
    chest = cad.modify.translate(chest, {0, 0, base_rim_radius})

    body = cad.hull({chest, base})
    body = cad.modify.translate(body, {0, 0, base_rim_radius})
    flask_shape = cad.union({body, head})

    return flask_shape, chest_height, base_rim_radius
end

return {
    build_flask = build_flask,
    create_torus = create_torus
}
