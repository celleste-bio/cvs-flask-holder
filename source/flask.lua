-- Luametry entry: build the flask model from a measurements YAML.

script_dir = string.match(debug.getinfo(1).source, "@(.*[/\\])") or "./"
repo_root = script_dir .. "../"
projects_root = repo_root .. "../"

function add_path(path)
    if path == nil then return end
    if string.sub(path, -1) == "/" or string.sub(path, -1) == "\\" then
        path = string.sub(path, 1, -2)
    end
    package.path = path .. "/?.lua;" .. package.path
end

add_path(script_dir)
add_path(repo_root .. "source")
add_path(projects_root .. "luametry/src")
add_path(projects_root .. "luam/lib")

const utils = require("utils")
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
dims = utils.read_yaml(measurements_path)
dims.body_height = dims.total_height - dims.neck_height

flask_shape = flask_geom.build_flask(dims)
return flask_shape
