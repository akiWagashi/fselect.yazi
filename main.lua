local root = ya.sync(function() return cx.active.current.cwd end)

local function entry()
    local rules, event = ya.input{
        title = "Filter by fselect",
        position = { "center", w = 50 },
    }

    if event ~= 1 or rules == nil or rules == "" then return end

    local cwd = root()

    local cmd = Command("fselect"):arg{ "name", "where", rules }:cwd(tostring(cwd))

    local output, err = cmd:output()

    local id = ya.id("ft")
    local virtual_dir = cwd:into_search(rules .. " by fselect")
    ya.emit("cd", { Url(virtual_dir) })
    ya.emit("update_files", {
        op = fs.op("part", {id = id, url = Url(virtual_dir), files = {} })
    })

    local files = {}
	for path in output.stdout:gmatch("[^\r\n]+") do
        local url = virtual_dir:join(path)
        local cha = fs.cha(url, true)
        if cha then
        	files[#files + 1] = File { url = url, cha = cha }
        end
	end

	ya.emit("update_files", {op = fs.op("part", { id = id, url = Url(virtual_dir), files = files })})
	ya.emit("update_files", {op = fs.op("done", { id = id, url = virtual_dir, cha = Cha { kind = 16 }})})

end

return { entry = entry }