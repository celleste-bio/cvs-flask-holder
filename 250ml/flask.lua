-- modeling 250ml erlenmeyer flask

require("utils").using("utils")

local cad = require("openscad")

function create_torus(r1, r2)
    local torus = cad.create("circle", {r=r1})
    torus = cad.transform("translate", torus, {r2, 0, 0})
    torus = cad.transform("rotate_extrude", torus, {convexity=10})
    return torus
end

function flask(dims)
    local neck_radius = dims.neck_diameter / 2
    local base_radius = dims.base_diameter / 2
    local bottom_curve = dims.base_diameter * 2
    local rim_radius = neck_radius / 5
    local base_edge = round(dims.neck_diameter / dims.base_diameter * 2, 2)

    local body_height = dims.body_height - base_edge
    local body = cad.create("cylinder", {h=body_height, r1=base_radius, r2=neck_radius})
    
    local neck = cad.create("cylinder", {h=dims.neck_height, r1=neck_radius, r2=neck_radius})
    neck = cad.transform("translate", neck, {0, 0, body_height})

    local rim = create_torus(rim_radius, neck_radius)
    rim = cad.transform("translate", rim, {0, 0, dims.total_height - rim_radius*3})

    local base_rim = create_torus(base_edge, base_radius-base_edge)
    local base_bottom = cad.create("cylinder", {h=base_edge, r1=base_radius-base_edge, r2=base_radius-base_edge})
    base_bottom = cad.transform("translate", base_bottom, {0, 0, -base_edge})
    local base = cad.boolean("union", {base_rim, base_bottom})

    local flask = cad.boolean("union", {body, neck, rim, base})
    flask = cad.transform("translate", flask, {0, 0, base_edge})

    local bottom_cutout = cad.create("sphere", {r=bottom_curve})
    bottom_cutout = cad.transform("translate", bottom_cutout, {0, 0, -(bottom_curve-(base_edge/2))})

    flask = cad.boolean("difference", {flask, bottom_cutout})
    
    return flask
end

function main()
    local dims = read_yaml("erlenmeyer-250ml_measurements.yaml")

    local results = flask(dims)
    local openscad_results = cad.encode(results)
    cad.write("erlenmeyer-250ml_generated.scad", openscad_results, 50)
end

main()