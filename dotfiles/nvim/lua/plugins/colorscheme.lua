return {
	{
		"nyoom-engineering/oxocarbon.nvim",
		-- Upstream ships compiled Lua; do not rebuild its rockspec with LuaRocks/Fennel.
		build = false,
		lazy = false,
		priority = 1000,
		config = function()
			vim.opt.background = "dark"
			vim.cmd.colorscheme("oxocarbon")

			-- Keep the main editing background transparent without changing theme foregrounds.
			for _, group in ipairs({ "Normal", "NormalNC", "SignColumn" }) do
				local highlight = vim.api.nvim_get_hl(0, { name = group, link = false })
				highlight.bg = nil
				vim.api.nvim_set_hl(0, group, highlight)
			end

			vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { fg = "#78a9ff" })
			vim.api.nvim_set_hl(0, "FFFCursorLine", { bg = "#393939", fg = "#f2f4f8" })
		end,
	},
}
