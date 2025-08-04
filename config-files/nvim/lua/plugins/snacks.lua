return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		buffdelete = { enabled = true },
		indent = { enabled = true },
		notifier = { enabled = true },
		quickfile = { enabled = true },
	},
	keys = {
		{
			"<leader>bo",
			function()
				require("snacks.bufdelete").other()
			end,
			desc = "Delete Other Buffers",
		},
	},
}
