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
local spacings = require("constants.spacings")

--Define module
local errors = {}

--
-- ERROR LOGS
--

-- Tool already installed
function errors.already_installed(tool, version, dir)
	return colors.GRAY
		.. spacings.secondary
		.. tool
		.. " v"
		.. version
		.. " already installed in "
		.. dir
		.. colors.NORMAL
end

return errors
