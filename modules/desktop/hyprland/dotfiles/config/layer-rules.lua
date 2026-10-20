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
