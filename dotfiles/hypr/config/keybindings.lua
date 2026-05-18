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
hl.bind(
	mainMod .. " + C",
	hl.dsp.send_shortcut({ mods = "CTRL", key = "Insert", window = "activewindow" }),
	{ description = "Universal Copy" }
)
hl.bind(
	mainMod .. " + V",
	hl.dsp.send_shortcut({ mods = "SHIFT", key = "Insert", window = "activewindow" }),
	{ description = "Universal paste" }
)
hl.bind(
	mainMod .. " + X",
	hl.dsp.send_shortcut({ mods = "CTRL", key = "X", window = "activewindow" }),
	{ description = "Universal cut" }
)

-- Common app shortcuts from the Niri config.
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(app("helium")))
hl.bind(mainMod .. " + ALT + B", hl.dsp.exec_cmd(app("helium --incognito")))
hl.bind(mainMod .. " + SHIFT + Slash", hl.dsp.exec_cmd(app("bitwarden")))
hl.bind(mainMod .. " + SHIFT + X", hl.dsp.exec_cmd(app("helium --app=https://x.com")))
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
