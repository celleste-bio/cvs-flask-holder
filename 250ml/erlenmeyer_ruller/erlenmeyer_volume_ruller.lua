-- calculate a volumetric ruller for the erlenmeyer at 30 digrees on the holder

require("utils").using("utils")
using("paths")
require("lib_cad")

local volumes_dir = "erlenmeyer_volumes"

local solid = cad()
solid:import("erlenmeyer-250ml_solid.stl")
solid:rotate(0,0,0,30,0,0)
solid:translate(0,0,2.4)

local hollow = cad()
hollow:import("erlenmeyer-250ml.stl")
hollow:rotate(0,0,0,30,0,0)
hollow:translate(0,0,2.4)
hollow:scale(0.01,0.01,0.01)

local cutoff_heights = {0, 0.5, 1, 1.5, 2, 2.5}
for _, height in pairs(cutoff_heights) do
    local cutoff = cad.cube(-5,-5,height,10,20,20)
    local volume = solid - hollow - cutoff
    -- show(volume)
    local cad_file = joinpath(volumes_dir, "volume_at_" .. height .. "cm.stl")
    volume:export(cad_file)    
end

