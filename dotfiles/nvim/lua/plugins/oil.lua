return {
	{
		"stevearc/oil.nvim",
		-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
		lazy = false,
		---@module 'oil'
		---@type oil.SetupOpts
		opts = {
			columns = {
				"icon",
				{ "size", highlight = "Special", align = "right" },
			},
			skip_confirm_for_simple_edits = true,
		},
		keys = {
			{ "<leader>e", "<CMD>Oil<CR>", { desc = "Open Oil" } },
		},
		dependencies = { { "nvim-mini/mini.icons", opts = {} } },
	},
}
