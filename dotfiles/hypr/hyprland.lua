terminal = "foot"
file_manager = "nautilus"
mainMod = "SUPER"

function app(cmd)
	-- UWSM sessions should launch long-running apps as systemd user units.
	return "uwsm app -- " .. cmd
end

require("config/monitors")
require("config/env")
require("config/options")
require("config/animations")
require("config/autostart")
require("config/layer-rules")
require("config/keybindings")
require("config/window-rules")
