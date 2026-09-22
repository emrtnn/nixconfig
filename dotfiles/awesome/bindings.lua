local awful = require("awful")
local gears = require("gears")

local bindings = {}

local function focused(action)
	local c = client.focus
	if c and c.valid then
		action(c)
	end
end

local function launch(argv)
	return function()
		awful.spawn(argv)
	end
end

local function focus_direction(direction)
	focused(function(c)
		awful.client.focus.bydirection(direction, c)
		focused(function(target)
			target:raise()
		end)
	end)
end

function bindings.build()
	local keys = gears.table.join(
		awful.key({ "Mod4" }, "Return", launch({ "kitty" })),
		awful.key({ "Mod4" }, "b", launch({ "helium" })),
		awful.key({ "Mod4", "Mod1" }, "b", launch({ "helium", "--incognito" })),
		awful.key({ "Mod4" }, "f", launch({ "kitty", "--class", "monad.yazi", "-e", "yazi" })),
		awful.key({ "Mod4", "Shift" }, "f", launch({ "nautilus", "--new-window" })),
		awful.key({ "Mod4" }, "space", nil, launch({ "rofi", "-show", "drun" })),
		awful.key({ "Mod4", "Shift" }, "v", nil, launch({ "copyq", "toggle" })),
		awful.key({ "Mod4" }, "c", nil, launch({ "xdotool", "key", "--clearmodifiers", "ctrl+Insert" })),
		awful.key({ "Mod4" }, "v", nil, launch({ "xdotool", "key", "--clearmodifiers", "shift+Insert" })),
		awful.key({ "Mod4" }, "x", nil, launch({ "xdotool", "key", "--clearmodifiers", "ctrl+x" })),
		awful.key({ "Mod4" }, "q", function()
			focused(function(c)
				c:kill()
			end)
		end),
		awful.key({ "Mod4" }, "t", function()
			focused(function(c)
				c.floating = not c.floating
			end)
		end),
		awful.key({ "Mod4" }, "F5", function()
			focused(function(c)
				c.fullscreen = not c.fullscreen
				c:raise()
			end)
		end),
		awful.key({ "Mod4" }, "Tab", function()
			focused(function(c)
				awful.client.focus.byidx(1, c)
			end)
			focused(function(c)
				c:raise()
			end)
		end),
		awful.key({ "Mod4", "Mod1" }, "r", awesome.restart),
		awful.key({ "Mod4", "Shift" }, "Escape", function()
			local session = os.getenv("XDG_SESSION_ID")
			if session and session ~= "" then
				awful.spawn({ "loginctl", "lock-session", session })
			end
		end),
		awful.key({ "Mod4" }, "s", nil, launch({ "nixconfig-screenshot", "region-edit" })),
		awful.key({ "Mod4", "Shift" }, "s", nil, launch({ "nixconfig-screenshot", "full-edit" })),
		awful.key({}, "Print", nil, launch({ "nixconfig-screenshot", "region-copy" })),
		awful.key({ "Shift" }, "Print", nil, launch({ "nixconfig-screenshot", "full-save" })),
		awful.key(
			{},
			"XF86AudioRaiseVolume",
			launch({ "wpctl", "set-volume", "--limit", "1.0", "@DEFAULT_AUDIO_SINK@", "5%+" })
		),
		awful.key({}, "XF86AudioLowerVolume", launch({ "wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "5%-" })),
		awful.key({}, "XF86AudioMute", launch({ "wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle" })),
		awful.key({}, "XF86AudioPlay", launch({ "playerctl", "play-pause" })),
		awful.key({}, "XF86AudioPause", launch({ "playerctl", "stop" })),
		awful.key({}, "XF86AudioNext", launch({ "playerctl", "next" })),
		awful.key({}, "XF86AudioPrev", launch({ "playerctl", "previous" }))
	)

	for _, binding in ipairs({
		{ "h", "left" },
		{ "j", "down" },
		{ "k", "up" },
		{ "l", "right" },
		{ "Left", "left" },
		{ "Down", "down" },
		{ "Up", "up" },
		{ "Right", "right" },
	}) do
		local key, direction = binding[1], binding[2]
		keys = gears.table.join(
			keys,
			awful.key({ "Mod4" }, key, function()
				focus_direction(direction)
			end),
			awful.key({ "Mod4", "Shift" }, key, function()
				focused(function(c)
					if not c.floating and not c.fullscreen then
						awful.client.swap.bydirection(direction, c)
					end
				end)
			end)
		)
	end

	for index = 1, 9 do
		local keycode = "#" .. (index + 9)
		keys = gears.table.join(
			keys,
			awful.key({ "Mod4" }, keycode, function()
				awful.screen.focused().tags[index]:view_only()
			end),
			awful.key({ "Mod4", "Shift" }, keycode, function()
				focused(function(c)
					local tag = c.screen.tags[index]
					c:move_to_tag(tag)
					tag:view_only()
					client.focus = c
					c:raise()
				end)
			end)
		)
	end

	return {
		globalkeys = keys,
		clientkeys = {},
		clientbuttons = gears.table.join(
			awful.button({}, 1, function(c)
				client.focus = c
				c:raise()
			end),
			awful.button({ "Mod4" }, 1, function(c)
				client.focus = c
				awful.mouse.client.move(c)
			end),
			awful.button({ "Mod4" }, 3, function(c)
				client.focus = c
				awful.mouse.client.resize(c)
			end)
		),
		rootbuttons = {},
	}
end

return bindings
