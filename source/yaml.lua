yaml = {}

function yaml.load(content)
    data = {}
    for line in string.gmatch(content, "[^\n\r]+") do
        trimmed = string.gsub(line, "^%s+", "")
        trimmed = string.gsub(trimmed, "%s+$", "")
        if trimmed != "" and string.sub(trimmed, 1, 1) != "#" then
            sep_start, sep_end = string.find(trimmed, ":", 1, true)
            if sep_start != nil then
                key = string.sub(trimmed, 1, sep_start - 1)
                key = string.gsub(key, "%s+$", "")
                raw_value = string.sub(trimmed, sep_end + 1)
                raw_value = string.gsub(raw_value, "^%s+", "")

                if raw_value == "true" then
                    data[key] = true
                elseif raw_value == "false" then
                    data[key] = false
                else
                    num = tonumber(raw_value)
                    if num != nil then
                        data[key] = num
                    else
                        data[key] = raw_value
                    end
                end
            end
        end
    end
    return data
end

yaml.eval = yaml.load

return yaml
