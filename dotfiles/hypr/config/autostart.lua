hl.on("hyprland.start", function()
	-- Noctalia owns wallpaper, notifications, OSD, idle/lock UI, launcher,
	-- control center, screen recorder UI, and panels in this setup.
	hl.exec_cmd(app("noctalia-shell"))
end)
