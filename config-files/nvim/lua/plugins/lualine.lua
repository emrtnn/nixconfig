return {
	"nvim-lualine/lualine.nvim",
	config = function()
		local lazy_status = require("lazy.status")
		require("lualine").setup({
			theme = "dracula",
			sections = {
				lualine_c = {
					{ "filename", path = 1 },
				},
				lualine_x = {
					{
						lazy_status.updates,
						cond = lazy_status.has_updates,
						color = { fg = "#ff9e64" },
					},
					{ "encoding" },
					{ "fileformat" },
					{ "filetype" },
				},
			},
		})
	end,
}
