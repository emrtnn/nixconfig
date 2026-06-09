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
