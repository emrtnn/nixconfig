return {
	{
		"nvim-mini/mini.pairs",
		version = false,
		event = "InsertEnter",
		opts = {
			modes = { insert = true, command = false, terminal = false },
			skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
			skip_ts = { "string" },
			skip_unbalanced = true,
			markdown = true,
		},
	},
	{
		"nvim-mini/mini.indentscope",
		version = false,
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			symbol = "│",
			options = { try_as_border = true },
		},
		init = function()
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "help", "lazy", "oil" },
				callback = function()
					vim.b.miniindentscope_disable = true
				end,
			})
		end,
	},
	{
		"nvim-mini/mini.surround",
		version = false,
		keys = {
			{ "gsa", mode = { "n", "x" }, desc = "Add surrounding" },
			{ "gsd", desc = "Delete surrounding" },
			{ "gsf", desc = "Find surrounding (right)" },
			{ "gsF", desc = "Find surrounding (left)" },
			{ "gsh", desc = "Highlight surrounding" },
			{ "gsr", desc = "Replace surrounding" },
			{ "gsn", desc = "Update surrounding search lines" },
		},
		opts = {
			mappings = {
				add = "gsa",
				deete = "gsd",
				find = "gsf",
				find_eft = "gsF",
				highlight = "gsh",
				replace = "gsr",
				update_n_lines = "gsn",
			},
		},
	},
}
