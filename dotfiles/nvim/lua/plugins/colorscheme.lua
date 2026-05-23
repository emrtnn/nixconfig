return {
	{
		"sainnhe/gruvbox-material",
		lazy = false,
		priority = 1000,
		config = function()
			vim.g.gruvbox_material_background = "medium"
			vim.g.gruvbox_material_foreground = "original"
			vim.g.gruvbox_material_better_performance = 1
			vim.g.gruvbox_material_enable_italic = true
			vim.g.gruvbox_material_enable_bold = true
			vim.cmd.colorscheme("gruvbox-material")

			vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { fg = "#d79921" })
			vim.api.nvim_set_hl(0, "FFFCursorLine", { bg = "#504945", fg = "#ebdbb2" })
		end,
	},
}
