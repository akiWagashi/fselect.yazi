local root = ya.sync(function() return cx.active.current.cwd end)

local function entry()
    local rules, event = ya.input{
        title = "Filter by fselect",
        pos = { "center", w = 50 },
    }

    if event ~= 1 or rules == nil or rules == "" then return end

    local root = root()

    local output, err = Command("fselect"):arg{ "name", "where", rules }:cwd(tostring(root)):output()

    local id = ya.id("ft")
    local cwd = root:into_search(rules .. "by fselect")
    
    ya.emit("cd", { Url(cwd) })
    ya.emit("update_files", {
        op = fs.op("part", {id = id, url = Url(cwd), files = {} })
    })

    local files = {}
	for path in output.stdout:gmatch("[^\r\n]+") do
        local url = cwd:join(path)
        local cha = fs.cha(url, true)
        if cha then
        	files[#files + 1] = File { url = url, cha = cha }
        end
	end

	ya.emit("update_files", {op = fs.op("part", { id = id, url = Url(cwd), files = files }) })
	ya.emit("update_files", {op = fs.op("done", { id = id, url = cwd, cha = Cha { mode = tonumber("100644", 8) } }) })

end

return { entry = entry }