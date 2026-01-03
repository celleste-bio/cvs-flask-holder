-- Setup paths for dependencies
local script_dir = arg[0]:match("(.*[/\\])") or "./"
package.path = script_dir .. "../deps/lua-utils/src/?.lua;" .. script_dir .. "../deps/lua-openscad/src/?.lua;" .. package.path

local utils = require("utils")
local paths = require("paths")

local cad = require("openscad")

function create_torus(r1, r2)
    local torus = cad.create("circle", {r=r1})
    torus = cad.transform("translate", torus, {r2, 0, 0})
    torus = cad.transform("rotate_extrude", torus, {convexity=10})
    return torus
end

function flask(dims)
    local total_height = dims.total_height
    local neck_height = dims.neck_height
    local neck_radius = dims.neck_diameter / 2
    local base_radius = dims.base_diameter / 2

    local neck = cad.create("cylinder", {h=neck_height, r1=neck_radius, r2=neck_radius})
    local rim_radius = neck_radius / 5
    local rim = create_torus(rim_radius, neck_radius)
    rim = cad.transform("translate", rim, {0, 0, neck_height- rim_radius})
    local head = cad.boolean("union", {neck, rim})
    head = cad.transform("translate", head, {0, 0, total_height - neck_height})

    local base_rim_scale = 3
    local base_rim_radius = base_radius / base_rim_scale
    local base = create_torus(base_rim_radius, base_radius - base_rim_radius/(base_rim_scale/3))
    local chest_height = total_height - neck_height - (base_rim_radius*2)
    local chest = cad.create("cylinder", {h=chest_height, r1=base_radius-base_rim_radius, r2=neck_radius})
    chest = cad.transform("translate", chest, {0, 0, base_rim_radius})

    local body = cad.boolean("hull", {chest, base})
    body = cad.transform("translate", body, {0, 0, base_rim_radius})
    local flask = cad.boolean("union", {body, head})

    return flask, chest_height, base_rim_radius
end

function main()
	local measurements_path = arg[1] -- yaml file
	local output_path = arg[2] -- scad file

    local dims = utils.read_yaml(measurements_path)
    local results = flask(dims)
    local openscad_results = cad.encode(results)

    cad.write(output_path, openscad_results, 50)
end

main()
