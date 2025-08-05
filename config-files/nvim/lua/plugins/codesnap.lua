return {
	"mistricky/codesnap.nvim",
	build = "make",
	keys = {
		{ "<leader>cc", "<cmd>CodeSnap<cr>", mode = "x", desc = "Save selected code snapshot into clipboard" },
		{
			"<leader>ci",
			"<cmd>CodeSnapSave<cr>",
			mode = "x",
			desc = "Save selected code snapshot in ~/Pictures/codesnap",
		},
	},
	opts = {
		save_path = "~/Pictures/codesnap/",
		bg_theme = "dusk",
		watermark = "",
		code_font_family = "CaskaydiaCove Nerd Font",
		has_breadcrumbs = false,
		has_line_numbers = true,
	},
}
