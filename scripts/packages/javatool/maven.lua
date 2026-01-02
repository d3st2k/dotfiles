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
		if not handle then
			error("Failed to open pipe")
		end
		script_dir = handle:read("*l")
		handle:close()
	end

	-- Add project root (parent of script_dir) to path
	local project_root = script_dir:match("^(.*)/[^/]+$") or script_dir
	package.path = project_root .. "/?.lua;" .. project_root .. "/?/init.lua;" .. package.path
end

-- Required modules
local inputs = require("utils.inputs")
local colors = require("constants.colors")
local logs = require("logs.init")
local utils = require("utils.utils")
local system = require("constants.system")
local shell_rc = require("utils.shell_rc")

-- Default values
local TOOL = "maven"
local DEFAULT_VERSION = "3.9.1"

--
-- MAIN INSTALLER
--
local function install()
	local version = inputs.get_version(TOOL, DEFAULT_VERSION)
	local prefix = utils.prefix_path(TOOL)
	local dir = string.format("%s/%s_%s", prefix, version, system.SYS)
	local link = utils.current_symlink(prefix)
	local url = string.format("public/org/apache/maven/apache-maven/%s/apache-maven-%s-bin.tar.gz", version, version)
	local rc = utils.detect_rc()

	print(logs.global.begin_install(TOOL, version))

	-------------------------------------------------------------------
	-- STEP 1: download + extract
	-------------------------------------------------------------------
	local already_installed = utils.isDirEmpty(dir)
	if already_installed then
		print(logs.steps.create_dir(1, true))
		print(logs.error.already_installed(TOOL, version, dir))
		print(logs.steps.proxy_config(2, true))
	else
		print(logs.steps.create_dir(1, false))
		utils.create_dir(dir)

		local download = utils.ex_install(url, dir)
		if os.execute(download) then
			print(logs.output.installed(true, TOOL, version, dir))
		else
			print(logs.output.installed(false, TOOL, version, dir))
			os.exit(1)
		end

		-------------------------------------------------------------------
		-- STEP 2: settings.xml for Artifactory proxy
		-------------------------------------------------------------------
		print("\n" .. colors.BOLD .. colors.CYAN .. "[3] " .. colors.NORMAL .. "Creating " .. TOOL .. " settings.xml")
		utils.create_dir(dir .. "/.m2")
	end

	-------------------------------------------------------------------
	-- STEP 3: symlink updates
	-------------------------------------------------------------------
	print(logs.steps.update_symlink(3, false, TOOL, version))

	utils.create_symlink(dir, link)
	utils.create_symlink(link, system.HOME .. "/bin/")

	-------------------------------------------------------------------
	-- STEP 4: update shell configuration
	-------------------------------------------------------------------
	print(logs.steps.update_shell(4, false, rc))

	shell_rc.upsert(rc, TOOL .. "_home", link)

	-------------------------------------------------------------------
	-- STEP 5: cleanup
	-------------------------------------------------------------------
	print(logs.steps.cleanup(5, false))
	print(logs.global.setup_complete())
end

-- Start the installation setup
install()
