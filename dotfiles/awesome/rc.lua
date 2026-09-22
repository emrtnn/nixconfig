local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")

beautiful.init(require("theme"))
naughty.config.defaults.position = "bottom_right"

local handling_error = false
awesome.connect_signal("debug::error", function(message)
	gears.debug.print_error(tostring(message))
	if handling_error then
		return
	end
	handling_error = true
	naughty.notify({ preset = naughty.config.presets.critical, title = "Awesome", text = tostring(message) })
	handling_error = false
end)

local bindings = require("bindings").build()
root.keys(bindings.globalkeys)
root.buttons(bindings.rootbuttons)
awful.layout.layouts = { awful.layout.suit.tile }

local function wallpaper(s)
	gears.wallpaper.maximized(beautiful.wallpaper, s, false)
end
screen.connect_signal("property::geometry", wallpaper)

local function button(label, argv)
	local text = wibox.widget.textbox(" " .. label .. " ")
	text:buttons(gears.table.join(awful.button({}, 1, nil, function()
		awful.spawn(argv)
	end)))
	return text
end

local tray = wibox.widget.systray()
tray:set_screen("primary")

awful.screen.connect_for_each_screen(function(s)
	wallpaper(s)
	s.padding = { top = 9, bottom = 9, left = 9, right = 9 }
	awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.suit.tile)
	for _, tag in ipairs(s.tags) do
		tag.master_width_factor = 0.55
		tag.master_count = 1
		tag.column_count = 1
		tag.gap_single_client = true
	end

	local tags = awful.widget.taglist({
		screen = s,
		filter = awful.widget.taglist.filter.all,
		buttons = gears.table.join(awful.button({}, 1, function(t)
			t:view_only()
		end)),
	})
	local tasks = awful.widget.tasklist({
		screen = s,
		filter = awful.widget.tasklist.filter.currenttags,
		buttons = gears.table.join(awful.button({}, 1, function(c)
			c.minimized = false
			client.focus = c
			c:raise()
		end)),
	})
	s.mywibar = awful.wibar({ position = "top", screen = s, height = 35, stretch = false })
	-- Detach the native edge tracker before applying the inset placement.
	s.mywibar.detach_callback()
	s.mywibar.detach_callback = nil
	local place = awful.placement.top + awful.placement.maximize_horizontally
	place(s.mywibar, {
		margins = { top = 10, left = 12, right = 12 },
		attach = true,
		update_workarea = true,
	})
	s.mywibar:setup({
		layout = wibox.layout.align.horizontal,
		{
			layout = wibox.layout.fixed.horizontal,
			button("Apps", { "rofi", "-show", "drun" }),
			tags,
		},
		tasks,
		{
			layout = wibox.layout.fixed.horizontal,
			spacing = 8,
			button("Shot", { "nixconfig-screenshot", "region-edit" }),
			tray,
			wibox.widget.textclock(" %a %d %b  %H:%M "),
		},
	})
end)

awful.rules.rules = {
	{
		rule = {},
		properties = {
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			focus = awful.client.focus.filter,
			raise = true,
			keys = bindings.clientkeys,
			buttons = bindings.clientbuttons,
			screen = awful.screen.preferred,
			placement = awful.placement.no_overlap + awful.placement.no_offscreen,
			honor_workarea = true,
			honor_padding = true,
		},
	},
	{
		rule_any = { type = { "dialog" }, class = { "ksnip", "Ksnip" } },
		properties = {
			floating = true,
			placement = awful.placement.centered + awful.placement.no_offscreen,
		},
	},
}

client.connect_signal("manage", function(c)
	if not awesome.startup then
		awful.client.setslave(c)
	end
end)
client.connect_signal("mouse::enter", function(c)
	if c.valid and awful.client.focus.filter(c) then
		client.focus = c
	end
end)
client.connect_signal("focus", function(c)
	c.border_color = beautiful.border_focus
end)
client.connect_signal("unfocus", function(c)
	c.border_color = beautiful.border_normal
end)
