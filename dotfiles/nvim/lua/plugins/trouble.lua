return {
	"folke/trouble.nvim",
	cmd = "Trouble",
	opts = {
		keys = {
			["<cr>"] = "jump_close",
			["o"] = "jump",
		},
		auto_close = true,
		focus = true,
		modes = {
			-- Custom mode to make Trouble behave like a floating popup
			diagnostics_float = {
				mode = "diagnostics",
				preview = {
					type = "split",
					relative = "win",
					position = "right",
					size = 0.7,
				},
				win = {
					type = "float",
					relative = "editor",
					border = "rounded",
					title = " Diagnostics ",
					title_pos = "center",
					position = { 0.5, 0.25 },
					size = { width = 0.45, height = 0.8 },
				},
			},
			todo_float = {
				mode = "todo",
				preview = {
					type = "split",
					relative = "win",
					position = "right",
					size = 0.7,
				},
				win = {
					type = "float",
					relative = "editor",
					border = "rounded",
					title = " Project Todos ",
					title_pos = "center",
					position = { 0.5, 0.25 },
					size = { width = 0.45, height = 0.8 },
				},
			},
		},
	},
	keys = {
		{
			"<leader>xx",
			"<cmd>Trouble diagnostics_float toggle filter.buf=0<cr>",
			desc = "Floating Diagnostics",
		},
		{ "<leader>xX", "<cmd>Trouble diagnostics_float toggle focus=true<cr>", desc = "Floating Diagnostics" },
	},
}
