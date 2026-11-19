-- Luametry entry: build the flask model from a measurements YAML.

script_dir = string.match(debug.getinfo(1).source, "@(.*[/\\])")
if script_dir == nil then
    script_dir = "./"
end
bootstrap = dofile(script_dir .. "bootstrap.lua")
bootstrap.configure_imports(script_dir)

const paths = require("paths")
const yaml = require("yaml")
const flask_geom = require("flask_geom")

function resolve_measurements_path()
    path = os.getenv("CVS_MEASUREMENTS")
    if (path == nil or path == "") and type(arg) == "table" then
        path = arg[1]
    end
    if path == nil or path == "" then
        error("CVS_MEASUREMENTS is not set and no measurements path was provided.")
    end
    return path
end

measurements_path = resolve_measurements_path()
raw_yaml, read_err = paths.read_file(measurements_path)
if raw_yaml == nil then
    error("Failed to read measurements YAML: " .. tostring(read_err))
end
dims = yaml.load(raw_yaml)
dims.body_height = dims.total_height - dims.neck_height

flask_shape = flask_geom.build_flask(dims)
return flask_shape
