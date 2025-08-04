return {
	"numToStr/Comment.nvim",
	dependencies = { "folke/ts-comments.nvim" },
	event = "VeryLazy",
	config = function()
		require("Comment").setup()
	end,
}
