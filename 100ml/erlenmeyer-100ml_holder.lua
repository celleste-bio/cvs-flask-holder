-- modeling erlenmeyer 250 ml holder for cell volume measurment

require("utils").using("utils")
require("lib_cad")

local cad_file = "erlenmeyer-250ml_holder.stl"

local erlenmeyer = cad()
erlenmeyer:import("erlenmeyer-250ml_solid.stl")
erlenmeyer:rotate(0,0,0,30,0,0)
erlenmeyer:translate(0,-4,4)

local base = cad.cylinder(0,0,0,1,7)
local body = cad.cube(-2,-6,0,4,10,7)

local holder = base + body - erlenmeyer
show(holder)
-- holder:export(cad_file)
