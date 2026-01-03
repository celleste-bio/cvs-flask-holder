-- modeling parametric erlenmeyer flask holder

-- Setup paths for dependencies
local script_dir = arg[0]:match("(.*[/\\])") or "./"
package.path = script_dir .. "../deps/lua-utils/src/?.lua;" .. script_dir .. "../deps/lua-openscad/src/?.lua;" .. package.path

require("utils").using("utils")
using("paths")

local cad = require("openscad")

local script_dir = get_script_dir()
dofile(joinpath(script_dir, "flask.lua")) -- import flask function

-- Helper: Horizontal Projection
local function hpro(length, angle)
    return length * math.cos(math.rad(angle))
end

-- Helper: Vertical Projection
local function vpro(length, angle)
    return length * math.sin(math.rad(angle))
end

--------------------------------------------------------------------------------
-- SKELETON CALCULATOR
-- Single Source of Truth for all geometric positions
--------------------------------------------------------------------------------
local function calculate_skeleton(dims, angle, thickness, tolerance)
    local s = {}
    
    -- Inputs
    s.angle = angle
    s.diagonal = 90 - angle
    s.thickness = thickness
    s.tolerance = tolerance
    s.dims = dims
    s.neck_radius = dims.neck_diameter / 2
    s.base_radius = dims.base_diameter / 2
    
    -- 1. Flask Axis Geometry (Projected in Y-Z plane)
    -- Angle is tilt from Horizontal (0 = lying down, 90 = standing up).
    -- User's "angle" (e.g. 30) is typically from Horizontal based on legacy hpro(cos)/vpro(sin).
    
    -- 1. Flask Axis Geometry (Projected in Y-Z plane)
    -- Angle is tilt from Horizontal.
    -- Flask is rotated by `diagonal` (90-angle) around X.
    -- Orientation: Starts at +Y (y_offset), points towards -Y (0).
    -- Z component is Positive (Slope Up).
    
    local rad_angle = math.rad(s.angle)
    s.axis_y_comp = -math.cos(rad_angle) -- Negative Y direction
    s.axis_z_comp = math.sin(rad_angle)  -- Positive Z direction
    s.axis_slope  = s.axis_z_comp / s.axis_y_comp
    
    -- 2. Vertical Clearance (Z-Offset)
    -- Lowest point of rim circle relative to center.
    -- Vertical Drop = Radius * cos(angle).
    s.vertical_radius_base = s.base_radius * math.cos(rad_angle)
    s.vertical_radius_neck = s.neck_radius * math.cos(rad_angle)
    
    -- Lowest point of the BASE Rim relative to its center:
    -- Z_lowest = CenterZ - s.vertical_radius_base
    -- We want Z_lowest = thickness + tolerance.
    -- So CenterZ = thickness + tolerance + s.vertical_radius_base
    s.z_offset = round(thickness + tolerance + s.vertical_radius_base, 4)
    
    -- 3. Horizontal Positioning (Y-Offset)
    -- Base starts here (Positive Y). Neck is towards 0.
    s.y_offset = round(hpro(dims.body_height, angle) + hpro(s.neck_radius, s.diagonal) + hpro(thickness, angle), 4)
    -- Note: This legacy part might need tuning but let's trust "angle" is correct for hpro now.
    
    -- 4. Key Point: BASE CENTER (The origin of the flask)
    s.base_center = {x=0, y=s.y_offset, z=s.z_offset}
    
    -- 5. Key Point: SHOULDER (Start of Neck)
    -- Distance along axis = body_height
    s.shoulder = {
        x = 0,
        y = s.base_center.y + dims.body_height * s.axis_y_comp,
        z = s.base_center.z + dims.body_height * s.axis_z_comp
    }
    
    -- 6. Key Point: NECK END (Rim)
    -- Distance along axis = body_height + neck_height
    s.neck_end = {
        x = 0,
        y = s.shoulder.y + dims.neck_height * s.axis_y_comp,
        z = s.shoulder.z + dims.neck_height * s.axis_z_comp
    }
    
    return s
end

function erlenmeyer_holder(dims, angle, thickness, tolerance)
    -- 1. Compute Geometry Skeleton
    local skel = calculate_skeleton(dims, angle, thickness, tolerance)
    
    -- 2. Base Block Construction
    -- The Base Rest needs to barely touch the bottom of the flask base.
    -- We'll calculate the horizontal position where the base "ends".
    -- The lowest point of the flask base is also the furthest "back" in Y if we look at the circle?
    -- No, strictly:
    -- Gap required = tolerance.
    -- Shift amount along Y to create that gap perpendicular to the surface?
    -- For a flat block against a curved/tilted base, it's simpler.
    -- Original logic: length_shift = tolerance / sin(diagonal)
    
    local length_shift = tolerance / math.sin(math.rad(skel.diagonal))
    local total_length = round(skel.y_offset + length_shift, 4)
    local base_width = round(dims.base_diameter / 3, 4)
    local base = cad.create("cube", {base_width, total_length, thickness})
    base = cad.transform("translate", base, {base_width, 0, 0})

    -- 3. Neck Rest Construction
    -- We derive the position of the Neck Rest from the SHOULDER point in the skeleton.
    
    -- A. Neck Rest Base
    local neck_rest_base_length = round(total_length / 8, 4)
    local neck_rest_base = cad.create("cube", {dims.base_diameter, neck_rest_base_length, thickness})
    -- (Positioning handled at end relative to origin)

    -- B. Neck Rest Body (The vertical tower)
    -- Height: Calculated to support the neck exactly at the correct Z level.
    
    -- Let's simply fix the Body Height to be "The Z height of the bottom of the tilted neck".
    -- Lowest point of neck at shoulder = skel.shoulder.z - skel.vertical_radius_neck
    local neck_bottom_z_at_shoulder = skel.shoulder.z - skel.vertical_radius_neck
    
    -- Set Body Height to support this, minus tolerance.
    local neck_rest_body_height = round(neck_bottom_z_at_shoulder - tolerance - thickness, 4)
    
    -- Head Height (Thickness of the clamp):
    -- Keep original design: proportional to radius.
    local neck_rest_head_height = round(vpro(skel.neck_radius, skel.diagonal), 4)

    -- Create Body
    local neck_rest_body = cad.create("cube", {skel.base_radius, thickness, neck_rest_body_height})
    neck_rest_body = cad.transform("translate", neck_rest_body, {skel.base_radius / 2, 0, 0})

    -- Create Head
    -- Note: This is an angled block.
    local neck_rest_head = cad.create("cube", {skel.base_radius, thickness, neck_rest_head_height})
    neck_rest_head = cad.transform("rotate", neck_rest_head, {-angle, 0, 0})
    -- Translate to sit on top of body
    neck_rest_head = cad.transform("translate", neck_rest_head, {skel.base_radius / 2, 0, neck_rest_body_height})

    -- NECK CUTOUT
    -- Defined entirely by Skeleton. We create a cylinder along the `skel.axis`.
    
    -- Cutout properties
    local cutout_radius = skel.neck_radius + tolerance
    local cutout_height_len = dims.neck_height * 2 -- Make it long enough to cut through everything
    local cutout = cad.create("cylinder", {h=cutout_height_len, r1=cutout_radius, r2=cutout_radius})
    
    -- Rotate and Position Cutout
    -- Cylinder defaults to Z-axis. We rotate it to match flask axis.
    cutout = cad.transform("rotate", cutout, {skel.diagonal, 0, 0})
    
    -- Translate to Shoulder position minus a shift to ensure it cuts through the start.
    local start_shift = dims.neck_height * 0.5
    local start_x = skel.shoulder.x
    local start_y = skel.shoulder.y - start_shift * skel.axis_y_comp
    local start_z = skel.shoulder.z - start_shift * skel.axis_z_comp
    
    -- Lower the cutout to match the lowered body height and ensure deep fit
    start_z = start_z - thickness
    
    cutout = cad.transform("translate", cutout, {skel.base_radius, start_y, start_z}) -- X is roughly centered
    
    -- Create the Hull for the top opening (Access Slot)
    -- We simulate the user dropping the flask in.
    -- Move a copy of the cutout "Up" (Normal to axis? Or vertical?).
    -- Usually "Up" in world space for a drop-in holder.
    local cutout_top = cad.create("cylinder", {h=cutout_height_len, r1=cutout_radius*1.4, r2=cutout_radius*1.4})
    cutout_top = cad.transform("rotate", cutout_top, {skel.diagonal, 0, 0})
    
    -- Lift top cutout upward by `neck_radius`.
    -- Direction: World Z?
    local lift = skel.neck_radius
    cutout_top = cad.transform("translate", cutout_top, {skel.base_radius, start_y, start_z + lift})
    
    -- Combine Cutouts
    local full_cutout = cad.boolean("hull", {cutout, cutout_top})
    
    -- Combine Rest Parts
    local neck_rest = cad.boolean("union", {neck_rest_base, neck_rest_body, neck_rest_head})
    neck_rest = cad.boolean("difference", {neck_rest, full_cutout})

    -- 4. Base Rest Block
    local base_rest_base = cad.create("cube", {dims.base_diameter, neck_rest_base_length, thickness})
    base_rest_base = cad.transform("translate", base_rest_base, {0, total_length - neck_rest_base_length, 0})

    local base_rest_left = cad.right_angle_triangle(vpro(skel.base_radius, skel.diagonal), hpro(skel.base_radius, skel.diagonal), thickness)
    base_rest_left = cad.transform("rotate", base_rest_left, {180, 270, 0})
    base_rest_left = cad.transform("translate", base_rest_left, {base_width, total_length, 0})

    local base_rest_right = cad.right_angle_triangle(vpro(skel.base_radius, skel.diagonal), hpro(skel.base_radius, skel.diagonal), thickness)
    base_rest_right = cad.transform("rotate", base_rest_right, {180, 270, 0})
    base_rest_right = cad.transform("translate", base_rest_right, {base_width * 2 - thickness, total_length, 0})
    
    local base_rest = cad.boolean("union", {base_rest_base, base_rest_left, base_rest_right})

    -- 5. Ruler Plate (Connector)
    local ruller_width_adjustment = tolerance / math.sin(math.rad(skel.diagonal))
    local ruller_plate = cad.right_angle_triangle(neck_rest_body_height - thickness, dims.chest_height - thickness - hpro(thickness, -angle) - ruller_width_adjustment, thickness)
    ruller_plate = cad.transform("rotate", ruller_plate, {0, 270, 0})
    ruller_plate = cad.transform("translate", ruller_plate, {skel.base_radius, thickness, thickness})

    -- Combine everything
    local result = cad.boolean("union", {base, base_rest, neck_rest, ruller_plate})

    return result
end

function main()
	local measurements_path = arg[1] -- yaml file
	local output_path = arg[2] -- scad file
	local with_flask = arg[3] -- boolean

    local dims = read_yaml(measurements_path)
    dims.body_height = dims.total_height - dims.neck_height
    local erlenmeyer, chest_height = flask(dims)
    dims.chest_height = chest_height

    local angle = 30
    -- Tolerance Calculation (Strict Uniform Gap)
    local tolerance = 0.005 -- 0.005mm uniform gap
    local thickness = round(dims.total_height / 50, 2)

    local holder = erlenmeyer_holder(dims, angle, thickness, tolerance)
    local openscad_holder = cad.encode(holder)
    cad.write(output_path, openscad_holder, 50)

    if with_flask and with_flask == "true" then
        local x_offset = round(dims.base_diameter / 2, 4)
        local y_offset = round(hpro(dims.body_height, angle) + hpro(dims.neck_diameter / 2, 90 - angle) + hpro(thickness, angle), 4)
        local z_offset = round(thickness + tolerance + vpro(dims.base_diameter / 2, 90 - angle), 4)

        erlenmeyer = cad.transform("rotate", erlenmeyer, {90 - angle, 0, 0})
        erlenmeyer = cad.transform("translate", erlenmeyer, {x_offset, y_offset, z_offset})
        local openscad_erlenmeyer = cad.encode(erlenmeyer)
        cad.append(output_path, openscad_erlenmeyer)
    end
end

main()
