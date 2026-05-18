local terminal = "foot"
local file_manager = "nautilus"
local mainMod = "SUPER"

local function app(cmd)
	-- UWSM sessions should launch long-running apps as systemd user units.
	return "uwsm app -- " .. cmd
end

-- Monitor setup: keep the desktop monitor from the niri config, and let other
-- outputs choose preferred modes automatically.
hl.monitor({ output = "DP-1", mode = "2560x1440@239.970", position = "0x0", scale = 1 })
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })

-- Environment that must exist before clients start. UWSM also receives the Home
-- Manager session variables through ~/.config/uwsm/env.
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("NIXOS_OZONE_WL", "1")
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")

hl.config({
	general = {
		gaps_in = 3,
		gaps_out = 10,
		border_size = 3,
		resize_on_border = true,
		layout = "dwindle",
		col = {
			active_border = "#d79921",
			inactive_border = "#595959aa",
		},
	},
	decoration = {
		rounding = 1,
		active_opacity = 1.0,
		inactive_opacity = 0.95,
		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = "#1a1a1aee",
		},
		blur = {
			enabled = true,
			size = 3,
			passes = 2,
			vibrancy = 0.1696,
		},
	},
	animations = { enabled = true },
	input = {
		kb_layout = "us",
		kb_variant = "altgr-intl",
		repeat_delay = 600,
		repeat_rate = 25,
		follow_mouse = 1,
		sensitivity = 0.35,
		scroll_method = "on_button_down",
		scroll_button = 274,
		touchpad = { natural_scroll = true },
	},
	dwindle = {
		preserve_split = true,
		smart_split = true,
	},
	misc = {
		disable_hyprland_logo = true,
		force_default_wallpaper = 0,
	},
})

-- Fast, smooth animations adapted from HyDE's "optimized" preset for
-- Hyprland's Lua API. This keeps movement snappy without fully disabling
-- animation polish.
hl.curve("hyde_wind", { type = "bezier", points = { { 0.05, 0.85 }, { 0.03, 0.97 } } })
hl.curve("hyde_winIn", { type = "bezier", points = { { 0.07, 0.88 }, { 0.04, 0.99 } } })
hl.curve("hyde_easeOutCirc", { type = "bezier", points = { { 0, 0.48 }, { 0.38, 1 } } })
hl.curve("hyde_md3_decel", { type = "bezier", points = { { 0.05, 0.80 }, { 0.10, 0.97 } } })
hl.curve("hyde_menu_decel", { type = "bezier", points = { { 0.05, 0.82 }, { 0, 1 } } })
hl.curve("hyde_menu_accel", { type = "bezier", points = { { 0.20, 0 }, { 0.82, 0.10 } } })
hl.curve("hyde_linear", { type = "bezier", points = { { 1, 1 }, { 1, 1 } } })

hl.animation({ leaf = "border", enabled = true, speed = 1.6, bezier = "hyde_linear" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 3.2, bezier = "hyde_winIn", style = "slide" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 2.8, bezier = "hyde_easeOutCirc" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 3.0, bezier = "hyde_wind", style = "slide" })
hl.animation({ leaf = "fade", enabled = true, speed = 1.8, bezier = "hyde_md3_decel" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 1.8, bezier = "hyde_menu_decel", style = "slide" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "hyde_menu_accel" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.6, bezier = "hyde_menu_decel" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.8, bezier = "hyde_menu_accel" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 4.0, bezier = "hyde_menu_decel", style = "slide" })
hl.animation({
	leaf = "specialWorkspace",
	enabled = true,
	speed = 2.3,
	bezier = "hyde_md3_decel",
	style = "slidefadevert 15%",
})

hl.on("hyprland.start", function()
	-- Noctalia owns wallpaper, notifications, OSD, idle/lock UI, launcher,
	-- control center, screen recorder UI, and panels in this setup.
	hl.exec_cmd(app("noctalia-shell"))
end)

-- Noctalia layer surfaces. Niri had explicit layer rules for these; keep the
-- same intent here so its wallpaper/background layers integrate cleanly.
hl.layer_rule({ name = "noctalia-wallpaper", match = { namespace = "^noctalia-wallpaper" }, no_anim = true })
hl.layer_rule({
	name = "noctalia-background",
	match = { namespace = "noctalia-background-.*$" },
	ignore_alpha = 0.5,
	blur = true,
	blur_popups = true,
})

-- Keybindings
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(app(terminal)))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd(app(file_manager .. " --new-window")))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.exec_cmd(app("footclient --app-id monad.yazi -e yazi")))
hl.bind(mainMod .. " + T", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + F5", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + O", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd("noctalia-shell ipc call lockScreen lock"))

-- Noctalia controls, matching the Niri config.
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd("noctalia-shell ipc call launcher toggle"))
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd("noctalia-shell ipc call launcher clipboard"))
hl.bind(mainMod .. " + comma", hl.dsp.exec_cmd("noctalia-shell ipc call settings toggle"))
hl.bind(mainMod .. " + SHIFT + Return", hl.dsp.exec_cmd("noctalia-shell ipc call controlCenter toggle"))
hl.bind(mainMod .. " + period", hl.dsp.exec_cmd("noctalia-shell ipc call launcher emoji"))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("noctalia-shell ipc call plugin:screen-recorder toggle"))

-- Universal copy/paste from the Niri config.
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("wtype -M ctrl -k Insert"))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("wtype -M shift -k Insert"))

-- Common app shortcuts from the Niri config.
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(app("helium")))
hl.bind(mainMod .. " + ALT + B", hl.dsp.exec_cmd(app("helium --incognito")))
hl.bind(mainMod .. " + SHIFT + Slash", hl.dsp.exec_cmd(app("bitwarden")))
hl.bind(mainMod .. " + X", hl.dsp.exec_cmd(app("helium --app=https://x.com")))
hl.bind(mainMod .. " + SHIFT + X", hl.dsp.exec_cmd(app("helium --app=https://x.com/compose/post")))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(app("helium --app=https://web.whatsapp.com")))
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd(app("helium --app=https://chatgpt.com")))
hl.bind(mainMod .. " + SHIFT + A", hl.dsp.exec_cmd(app("helium --app=https://gemini.google.com")))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(app("thunderbird")))
hl.bind(mainMod .. " + SHIFT + T", hl.dsp.exec_cmd(app("Telegram")))
hl.bind(mainMod .. " + G", hl.dsp.exec_cmd(app("helium --app=https://calendar.google.com")))
hl.bind(mainMod .. " + Y", hl.dsp.exec_cmd(app("helium --app=https://youtube.com")))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd(app("helium --app=https://notion.so")))
hl.bind(mainMod .. " + SHIFT + Y", hl.dsp.exec_cmd(app("google-chrome-stable --app=https://primevideo.com")))

hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.swap({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.swap({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.swap({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.swap({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.swap({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.swap({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.swap({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.swap({ direction = "down" }))

hl.bind(mainMod .. " + ALT + H", hl.dsp.window.resize({ x = -160, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + ALT + L", hl.dsp.window.resize({ x = 160, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + ALT + K", hl.dsp.window.resize({ x = 0, y = -160, relative = true }), { repeating = true })
hl.bind(mainMod .. " + ALT + J", hl.dsp.window.resize({ x = 0, y = 160, relative = true }), { repeating = true })

for i = 1, 10 do
	local key = i % 10
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + grave", hl.dsp.workspace.toggle_special("scratch"))
hl.bind(mainMod .. " + SHIFT + grave", hl.dsp.window.move({ workspace = "special:scratch" }))
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind(mainMod .. " + S", hl.dsp.exec_cmd('grim -g "$(slurp -w 0)" -t png - | tee >(wl-copy) | swappy -f -'))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("grim -t png - | tee >(wl-copy) | swappy -f -"))
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd("hyprpicker -a"))
hl.bind("Print", hl.dsp.exec_cmd('grim -g "$(slurp -d)" - | wl-copy'))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("grim ~/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png"))
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Window rules
hl.window_rule({ name = "suppress-maximize", match = { class = ".*" }, suppress_event = "maximize" })
hl.window_rule({ name = "swappy-floating", match = { class = "^swappy$" }, float = true, center = true })
hl.window_rule({
	name = "localsend-floating",
	match = { class = "localsend" },
	float = true,
	size = { 900, 800 },
	center = true,
})
hl.window_rule({
	name = "telegram-floating",
	match = { class = "^org.telegram.desktop$" },
	float = true,
	size = { 600, 1050 },
	center = true,
})
hl.window_rule({ name = "bitwarden-private", match = { class = "^Bitwarden$" }, no_screen_share = true })
