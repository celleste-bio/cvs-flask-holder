-- modeling 250ml erlenmeyer flask

require("utils").using("utils")

local cad = require("openscad")

dofile("erlenmeyer-250ml.lua") -- import the flask function

function erlenmeyer_holder(dims, angle, thickness)    
    -- Base block --
    local total_length = round(dims.body_height * math.cos(math.rad(angle)) + dims.base_diameter/2 * math.cos(math.rad(90-angle)) + (dims.neck_diameter/2 * math.cos(math.rad(90-angle))), 2) -- + thickness
    local base = cad.create("cube", {dims.base_diameter, total_length, thickness})

    -- Neck rest block --
    local neck_rest_body_height = round((dims.body_height * math.sin(math.rad(angle))) + (dims.base_diameter/2 * math.sin(math.rad(90-angle))) - (dims.neck_diameter/2 * math.sin(math.rad(90-angle))) + thickness/2, 2)  -- + thickness
    local neck_rest_body = cad.create("cube", {dims.base_diameter, thickness, neck_rest_body_height})
    
    local neck_rest_head_height = round(dims.neck_diameter/2 * math.sin(math.rad(90-angle)), 2)
    local neck_rest_head = cad.create("cube", {dims.base_diameter, thickness, neck_rest_head_height*1.5})
    neck_rest_head = cad.transform("rotate", neck_rest_head, {-angle,0,0})
    neck_rest_head = cad.transform("translate", neck_rest_head, {0,0,neck_rest_body_height})

    local neck_rest_height = neck_rest_body_height + neck_rest_head_height
    local neck_rest_head_cutout_size = dims.neck_diameter/2*1.05
    local neck_rest_head_cutout_height = round(neck_rest_height - ((dims.neck_diameter/2+0.1)/4 * math.sin(math.rad(90-angle))), 2)
    local neck_rest_head_cutout_offset = round(dims.neck_height - dims.neck_diameter/2 * math.cos(math.rad(90-angle)), 2)
    
    local neck_rest_head_cutout = cad.create("cylinder", {h=dims.neck_height, r1=neck_rest_head_cutout_size, r2=neck_rest_head_cutout_size})
    neck_rest_head_cutout = cad.transform("rotate", neck_rest_head_cutout, {90-angle,0,0})
    neck_rest_head_cutout = cad.transform("translate", neck_rest_head_cutout, {dims.base_diameter/2, neck_rest_head_cutout_offset ,neck_rest_head_cutout_height})
    
    local neck_rest_head_cutout_top = cad.create("cylinder", {h=dims.neck_height, r1=neck_rest_head_cutout_size*1.4, r2=neck_rest_head_cutout_size*1.4})
    neck_rest_head_cutout_top = cad.transform("rotate", neck_rest_head_cutout_top, {90-angle,0,0})
    neck_rest_head_cutout_top = cad.transform("translate", neck_rest_head_cutout_top, {dims.base_diameter/2, neck_rest_head_cutout_offset+dims.neck_diameter/4 ,neck_rest_head_cutout_height+dims.neck_diameter/2})

    neck_rest_head_cutout = cad.boolean("hull", {neck_rest_head_cutout, neck_rest_head_cutout_top})

    local neck_rest = cad.boolean("union", {neck_rest_body, neck_rest_head})
    neck_rest = cad.boolean("difference", {neck_rest, neck_rest_head_cutout})

    -- Base rest block --
    local base_rest_length = round(dims.base_diameter * math.cos(math.rad(90-angle)), 2)
    local base_rest_height = round(dims.base_diameter * 0.8, 2)
    local base_rest = cad.create("cube", {dims.base_diameter, base_rest_length, base_rest_height})
    base_rest = cad.transform("translate", base_rest, {0, total_length-base_rest_length, thickness})
    
    local z_offset = round(base_rest_length * math.cos(math.rad(90-angle)), 2)
    local y_offset = round(total_length - (base_rest_length*2) + (base_rest_length/2 * math.cos(math.rad(90-angle))), 2)
    local base_rest_cutout = cad.create("cube", {dims.base_diameter+thickness, base_rest_length, base_rest_height*1.5})
    base_rest_cutout = cad.transform("rotate", base_rest_cutout, {-angle,0,0})
    base_rest_cutout = cad.transform("translate", base_rest_cutout, {-thickness/2, y_offset, z_offset})

    base_rest = cad.boolean("difference", {base_rest, base_rest_cutout})

    -- Ruller plate --
    local v1 = {thickness, thickness}
    local v2 = {neck_rest_body_height-thickness, thickness}
    local v3 = {thickness, total_length - base_rest_length - thickness}

    local ruller_plate = cad.create("polygon", {v1, v2, v3})
    ruller_plate = cad.transform("linear_extrude", ruller_plate, {height=thickness})
    ruller_plate = cad.transform("rotate", ruller_plate, {0,-90,0})
    ruller_plate = cad.transform("translate", ruller_plate, {dims.base_diameter/2+thickness/2,0,0})

    local result = cad.boolean("union", {base, neck_rest, base_rest, ruller_plate})
    return result
end

function main()
    local dims = read_yaml("erlenmeyer-250ml_measurements.yaml")

    local angle = 30
    local thickness = 0.5

    local holder = erlenmeyer_holder(dims, angle, thickness)
    local openscad_holder = cad.encode(holder)
    cad.write("erlenmeyer-250ml_holder_generated.scad", openscad_holder, 50)
    
    local x_offset = round(dims.base_diameter/2, 2)
    local y_offset = round(dims.body_height * math.cos(math.rad(angle)) + dims.neck_diameter/2 * math.cos(math.rad(90-angle)) + thickness, 2)
    local z_offset = round(dims.base_diameter/2 * math.sin(math.rad(90-angle)), 2) -- + thickness

    local erlenmeyer = flask(dims)
    erlenmeyer = cad.transform("rotate", erlenmeyer, {60,0,0})
    erlenmeyer = cad.transform("translate", erlenmeyer, {x_offset, y_offset, z_offset})
    local openscad_erlenmeyer = cad.encode(erlenmeyer)
    -- cad.append("erlenmeyer-250ml_holder_generated.scad", openscad_erlenmeyer)
end

main()
