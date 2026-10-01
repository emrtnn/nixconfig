return {
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		opts = {
			theme = "gruvbox-material",
			globalstatus = true,
			sections = {
				lualine_c = {
					{
						"filename",
						path = 1,
						shorting_target = 0,
						-- Show up to two parent directories plus the filename.
						fmt = function(filename)
							return filename:match("([^/]+/[^/]+)$") or filename
						end,
					},
				},
			},
		},
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
}
