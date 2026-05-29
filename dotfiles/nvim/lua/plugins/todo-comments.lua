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
				function()
					require("fzf-lua").grep_curbuf({
						prompt = "Buffer Todos> ",
						search = "TODO|FIX|FIXME|HACK|WARN|PERF|NOTE|TEST",
						no_esc = true,
					})
				end,
				desc = "Buffer Todos",
			},
			{
				"<leader>xT",
				"<cmd>TodoFzfLua<cr>",
				desc = "Project Todos",
			},
		},
	},
}
