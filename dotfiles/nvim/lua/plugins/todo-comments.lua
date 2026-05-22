return {
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		event = { "BufReadPre", "BufNewFile" },
		opts = {},
		keys = {
			{
				"]t",
				function()
					require("todo-comments").jump_next()
				end,
				desc = "Next Todo Comment",
			},
			{
				"[t",
				function()
					require("todo-comments").jump_prev()
				end,
				desc = "Previous Todo Comment",
			},
			{
				"<leader>xt",
				"<cmd>Trouble todo_float toggle focus=true filter.buf=0<cr>",
				desc = "Buffer Todo (Trouble)",
			},
			{
				"<leader>xT",
				"<cmd>Trouble todo_float toggle focus=true<cr>",
				desc = "Global Todo (Trouble)",
			},
		},
	},
}
