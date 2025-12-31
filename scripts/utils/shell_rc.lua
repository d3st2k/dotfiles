#!/usr/bin/env lua

do
	local function get_script_dir()
		local str = debug.getinfo(2, "S").source:sub(2)
		return str:match("^(.*)/") or "."
	end
	local script_dir = get_script_dir()
	-- Convert to absolute path if needed
	if not script_dir:match("^/") then
		local handle = io.popen("cd '" .. script_dir .. "' && pwd")
		script_dir = handle:read("*l")
		handle:close()
	end

	-- Add project root (parent of script_dir) to path
	local project_root = script_dir:match("^(.*)/[^/]+$") or script_dir
	package.path = project_root .. "/?.lua;" .. project_root .. "/?/init.lua;" .. package.path
end

-- Define module
local shell_rc = {}

-- Upsert environment variable in the shell rc file
function shell_rc.upsert(path, var, value)
	local f = io.open(path, "r")
	local content = f:read("*a")
	f:close()

	local nvar = "export " .. var .. "=" .. value

	if os.getenv(var) then
		content = content:gsub("export%s+" .. var .. "=%S+", nvar)
	else
		if not content:match("\n$") then
			content = content .. "\n"
		end
		content = content .. nvar .. "\n"
	end

	local w = io.open(path, "w")
	w:write(content)
	w:close()
end

return shell_rc
