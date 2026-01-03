-- Setup paths for dependencies
local script_dir = arg[0]:match("(.*[/\\])") or "./"
package.path = script_dir .. "../deps/lua-utils/src/?.lua;" .. script_dir .. "../deps/lua-openscad/src/?.lua;" .. package.path

require("utils").using("utils")
using("dataframes")

-- local readdlm = require("delimited_files").readdlm
-- local measurements = readdlm("erlenmeyer-measurements.tsv", ",", true)

local measurements = {
    [1] = {capacity=100, total_height=108, neck_height=35, base_diameter=66, neck_diameter=30},
    [2] = {capacity=250, total_height=143, neck_height=35, base_diameter=82, neck_diameter=36},
    [3] = {capacity=500, total_height=180, neck_height=45, base_diameter=100, neck_diameter=36},
    [4] = {capacity=1000, total_height=220, neck_height=45, base_diameter=130, neck_diameter=44},
    [5] = {capacity=2000, total_height=285, neck_height=55, base_diameter=164, neck_diameter=51}
}

view(measurements)

local relative_measurements = {}
for _, row in pairs(measurements) do
    local capacity = row.capacity
    table.insert(relative_measurements,
        {
            capacity = capacity,
            total_height = row.total_height / capacity,
            neck_height = row.neck_height / capacity,
            base_diameter = row.base_diameter / capacity,
            neck_diameter = row.neck_diameter / capacity
        }
    )
end

view(relative_measurements)