return {
	{
		"dmtrKovalenko/fff.nvim",
		-- The plugin manages its own lazy-loading internally, so we tell lazy.nvim to load it immediately
		lazy = false,

		-- The NixOS-specific build command. When lazy.nvim clones the repo,
		-- it will run this command to compile the Rust binary natively for your system.
		build = "nix run .#release",
		opts = {
			debug = {
				enabled = false,
				show_scores = false,
			},
			git = {
				status_text_color = true,
			},
		},
		keys = {
			{
				"<leader>ff",
				function()
					require("fff").find_files()
				end,
				desc = "Find files",
			},
			{
				"<leader>fg",
				function()
					require("fff").live_grep()
				end,
				desc = "Live grep",
			},
			{
				"<leader>fz",
				function()
					require("fff").live_grep({
						grep = { modes = { "fuzzy", "plain" } },
					})
				end,
				desc = "Live fuzzy grep",
			},
			{
				"<leader>fc",
				function()
					require("fff").live_grep({ query = vim.fn.expand("<cword>") })
				end,
				desc = "Search current word",
			},
		},
	},
}
