return {
	{
		"stevearc/conform.nvim",
		lazy = true,
		cmd = "ConformInfo",
		keys = {
			{
				"<leader>cf",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = { "n", "x" },
				desc = "Format Buffer",
			},
		},
		opts = {
			default_format_opts = {
				timeout_ms = 3000,
				async = true,
				quiet = false,
				lsp_format = "fallback",
			},
			format_on_save = {
				timeout_ms = 500,
				lsp_format = "fallback",
			},
			formatters_by_ft = {
				lua = { "stylua" },

				-- The Astral Stack
				python = { "ruff_format", "ruff_fix", "ruff_organize_imports" },

				-- The Modern Web Stack (Biome)
				javascript = { "biome" },
				typescript = { "biome" },
				javascriptreact = { "biome" },
				typescriptreact = { "biome" },
				json = { "biome" },
				css = { "biome" },

				-- Astro (Prettier is still the most stable for .astro files)
				astro = { "prettier" },

				-- Native tools
				c = { "clang-format" },
				cpp = { "clang-format" },
				rust = { "rustfmt" },

				-- Modern Nix
				nix = { "alejandra" },
			},
		},
	},
}
