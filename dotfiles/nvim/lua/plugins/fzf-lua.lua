return {
	{
		"ibhagwan/fzf-lua",
		event = "VeryLazy",
		cmd = "FzfLua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			winopts = {
				border = "rounded",
				preview = {
					border = "rounded",
				},
			},
		},
		keys = {
			{
				"<leader>xx",
				function()
					require("fzf-lua").diagnostics_document()
				end,
				desc = "Buffer Diagnostics",
			},
			{
				"<leader>xX",
				function()
					require("fzf-lua").diagnostics_workspace()
				end,
				desc = "Workspace Diagnostics",
			},
		},
	},
}
