return {
	{
		"folke/lazydev.nvim",
		event = { "BufReadPre", "BufNewFile" },
		ft = "lua",
		opts = {
			library = {
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
			},
		},
	},
	{ "Bilal2453/luvit-meta", lazy = true },
}
