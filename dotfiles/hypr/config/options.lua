hl.config({
	general = {
		gaps_in = 3,
		gaps_out = 12,
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
	ecosystem = {
		no_update_news = true,
		no_donation_nag = true,
	},
})
