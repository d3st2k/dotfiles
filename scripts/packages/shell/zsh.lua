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

-- Export the ZSH CUSTOM folder path
os.execute([[export ZSH_CUSTOM="$HOME/dotfiles/configs/zsh/custom"]])

-- Create symlinks to point to repo
os.execute("ln -sf $HOME/dotfiles/configs/zsh/.zshrc $HOME/.zshrc")

-- Change SHELL to ZSH
os.execute("sudo apt -y install zsh")

-- Install Oh-My-Zsh
os.execute([[
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
]])

-- Add ZSH Plugins
os.execute([[
  while read -r repo; do
    git clone "$repo" "$ZSH_CUSTOM/plugins/$(basename "$repo" .git)"
  done <"$ZSH_CUSTOM/plugins/plugins.list"
]])

-- Change the SHELL
os.execute("sudo chsh -s $(which zsh)")
