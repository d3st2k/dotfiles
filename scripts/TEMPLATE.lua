#!/usr/bin/env lua

-- Portable path setup: finds script directory and adds project root to package.path
-- Copy this block to any script that needs to require modules from this project
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
-- local inputs = require("utils.inputs")
-- local logs = require("logs.init")
-- ... add your requires here

-- Your code here
