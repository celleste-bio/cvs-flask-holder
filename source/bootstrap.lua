function add_path(path)
    if path == nil or path == "" then return end
    if string.sub(path, -1) == "/" or string.sub(path, -1) == "\\" then
        path = string.sub(path, 1, -2)
    end
    package.path = path .. "/?.lua;" .. package.path
end

function add_path_list(paths)
    if paths == nil or paths == "" then return end
    for path in string.gmatch(paths, "([^;]+)") do
        add_path(path)
    end
end

function configure_imports(script_dir)
    -- Project-local modules live next to the entry files in source/.
    add_path(script_dir)

    -- Optional explicit overrides for non-standard environments.
    -- Use semicolon-separated directories, each containing Lua modules.
    add_path_list(os.getenv("CVS_LUA_PATH"))
end

return {
    configure_imports = configure_imports
}
