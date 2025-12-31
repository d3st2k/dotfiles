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

-- Define module
local output = {}

--
-- Output LOGS
--
function output.installed(bool, tool, version, dir)
	if bool == true then
		return colors.GRAY
			.. spacings.secondary
			.. "Installed "
			.. tool
			.. " v"
			.. version
			.. " into "
			.. dir
			.. colors.NORMAL
	else
		return colors.RED .. "Failed to install " .. tool .. " v" .. version .. "into " .. dir .. colors.NORMAL
	end
end

return output
