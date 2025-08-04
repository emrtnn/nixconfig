return {
	"nvim-telescope/telescope.nvim",
	dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-ui-select.nvim" },
	config = function()
		local telescope = require("telescope")
		local builtin = require("telescope.builtin")

		vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "Telescope find files" })
		vim.keymap.set("n", "<leader>ff", builtin.live_grep, { desc = "Telescope live grep" })
		vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
		vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })

		telescope.setup({
			defaults = {
				theme = require("telescope.themes").get_dropdown(),
			},
		})

		-- You still load extensions after setup
		telescope.load_extension("ui-select")
	end,
}
