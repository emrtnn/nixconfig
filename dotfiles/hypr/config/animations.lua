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
