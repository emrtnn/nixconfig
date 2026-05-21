return {
	{
		"saghen/blink.cmp",
    event = { "InsertEnter", "CmdlineEnter" },
		dependencies = {
			"saghen/blink.lib",
			"rafamadriz/friendly-snippets",
		},

		build = function()
			require("blink.cmp").build():wait(60000)
		end,

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			keymap = { preset = "super-tab" },

			appearance = {
				nerd_font_variant = "mono",
			},

			completion = {
				accept = { auto_brackets = { enabled = true } },
				menu = {
					border = "rounded",
					draw = { treesitter = { "lsp" } },
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 200,
					window = { border = "rounded" },
				},
			},

			sources = { default = { "lsp", "path", "snippets", "buffer" } },

			signature = { enabled = true, window = { border = "rounded" } },
		},
	},
}
