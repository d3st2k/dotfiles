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

-- Required modules
local colors = require("constants.colors")

-- Define module
local input = {}

-- Ask user for version
function input.get_version(tool, default_ver)
	if not ver or ver == "" then
		io.write(colors.CYAN .. "Enter " .. tool .. " version (default: " .. default_ver .. "): " .. colors.NORMAL)
		ver = io.read()
	end
	if ver == "" or ver == nil then
		ver = default_ver
	end
	return ver
end

return input
