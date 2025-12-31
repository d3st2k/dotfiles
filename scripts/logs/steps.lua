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
local utils = require("logs.utils")

-- Define module
local steps = {}

--
-- Steps logic
--

-- Create directory
function steps.create_dir(step, skip)
	return "\n"
		.. colors.BOLD
		.. colors.CYAN
		.. utils.step(step)
		.. colors.NORMAL
		.. "Creating directory"
		.. utils.skip(skip)
end

-- Proxy config
function steps.proxy_config(step, skip)
	return "\n" .. colors.BOLD .. colors.CYAN .. utils.step(step) .. colors.NORMAL .. "Proxy config" .. utils.skip(skip)
end

-- Updating SHELL config
function steps.update_shell(step, skip, rc)
	return "\n"
		.. colors.BOLD
		.. colors.CYAN
		.. utils.step(step)
		.. colors.NORMAL
		.. "Updating shell config at "
		.. rc
		.. utils.skip(skip)
end

-- Updating Symlink pointer
function steps.update_symlink(step, skip, tool, version)
	return "\n"
		.. colors.BOLD
		.. colors.CYAN
		.. utils.step(step)
		.. colors.NORMAL
		.. "Updating 'current' symlink to "
		.. colors.CYAN
		.. tool
		.. " v"
		.. version
		.. utils.skip(skip)
end

-- Cleanup worklfow
function steps.cleanup(step, skip)
	return "\n"
		.. colors.BOLD
		.. colors.CYAN
		.. utils.step(step)
		.. colors.NORMAL
		.. "Cleanup done."
		.. utils.skip(skip)
end

return steps
