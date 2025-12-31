-- Required modules
local colors = require("constants.colors")

-- Define module
local global = {}

-- Begin installation setup
function global.begin_install(tool, version)
	return "\n" .. colors.BOLD .. "🛠️ Installing " .. colors.CYAN .. tool .. " v" .. version .. colors.NORMAL
end

-- Setup complete
function global.setup_complete()
	return "\n" .. "✅ Setup complete.\n"
end

return global
