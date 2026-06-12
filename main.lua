local root = ya.sync(function() return cx.active.current.cwd end)

local function fail(content) return ya.notify { title = "fselect Filter", content = content, timeout = 5, level = "error" } end

local function entry()
    local rules, event = ya.input{
        title = "Filter by fselect",
        pos = { "top-center", y = 3, w = 50, h = 2 },
    }

    if event ~= 1 or rules == nil or rules == "" then return end

    local root = root()

    local output, err = Command("fselect"):arg{ "name", "where", rules }:cwd(tostring(root)):output()

    if err then
		return fail("Failed to run `fselect`, error: " .. err)
	elseif not output.status.success then
		return fail("Failed to run `fselect`, stderr: " .. output.stderr)
	end

    local search_path = ""
    local via_text = " by fselect"
    if rules:len() > 30 then
        search_path = rules:sub(1, 20) .. "..." .. via_text
    else
        search_path = rules .. via_text
    end

    local cwd = root:into_search(search_path)
    local id = ya.id("ft")

    ya.emit("cd", { Url(cwd), source = "search"})
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