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
local system = require("constants.system")

-- Define module
local utils = {}

-- Read CMD output
function utils.read_cmd(cmd)
	local f = io.popen(cmd)
	local out = f:read("*l")
	f:close()
	return out
end

-- Detect shell RC
function utils.detect_rc()
	local home = os.getenv("HOME")
	local shell = os.getenv("SHELL") or ""

	if shell:find("zsh") then
		return home .. "/.zshrc"
	end

	if shell:find("bash") then
		return home .. "/.bashrc"
	end

	return home .. "/.profile"
end

-- Prefix install path
function utils.prefix_path(tool)
	return system.HOME .. "/packages/" .. tool
end

-- Current package Symlink
function utils.current_symlink(prefix)
	return prefix .. "/current"
end

-- Is directory empty
function utils.isDirEmpty(dir)
	return os.execute('[ -d "' .. dir .. '" ] && [ "$(ls -A ' .. dir .. ' 2>/dev/null)" ]')
end

-- Create directory
function utils.create_dir(dir)
	return os.execute('mkdir -p "' .. dir .. '"')
end

-- Install external package
function utils.ex_install(url, dir)
	return 'curl -sL --compressed "'
		.. system.ARTIFACT
		.. "/"
		.. url
		.. '" | tar xz --no-same-owner --strip-components=1 -C "'
		.. dir
		.. '"'
end

-- Create Symlink pointer
function utils.create_symlink(source, target)
	return os.execute('ln -sfn "' .. source .. '" "' .. target .. '"')
end

return utils
