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

-- Get archticture type
local function read_cmd(cmd)
	local f = io.popen(cmd)
	local out = f:read("*l")
	f:close()
	return out
end

-- System values
local ARCH = read_cmd("uname -m"):gsub("x86_64", "x64"):gsub("aarch64", "aarch64")
local OS = "linux"
local HOME = os.getenv("HOME")
local ARTIFACT = "https://artifacts.rbi.tech/artifactory"
local SHELL = os.getenv("SHELL") or ""

-- Define module
local system = {
	ARCH = ARCH,
	OS = OS,
	HOME = HOME,
	ARTIFACT = ARTIFACT,
	SHELL = SHELL,
	SYS = OS .. "-" .. ARCH,
}

return system
