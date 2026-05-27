return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = "ConformInfo",
		keys = {
			{
				"<leader>cf",
				function()
					require("conform").format({ lsp_format = "fallback", timeout_ms = 3000 })
				end,
				mode = { "n", "x" },
				desc = "Format Buffer",
			},
			{
				"<leader>tf",
				function()
					if vim.g.disable_autoformat then
						vim.cmd("FormatEnable")
						vim.notify("Autoformat enabled", vim.log.levels.WARN)
					else
						vim.cmd("FormatDisable")
						vim.notify("Autoformat disabled", vim.log.levels.WARN)
					end
				end,
				desc = "Toggle Autoformat on Save",
			},
		},
		init = function()
			vim.api.nvim_create_user_command("FormatDisable", function(args)
				if args.bang then
					vim.b.disable_autoformat = true
				else
					vim.g.disable_autoformat = true
				end
			end, {
				desc = "Disable autoformat-on-save",
				bang = true,
			})

			vim.api.nvim_create_user_command("FormatEnable", function()
				vim.b.disable_autoformat = false
				vim.g.disable_autoformat = false
			end, {
				desc = "Re-enable autoformat-on-save",
			})
		end,
		opts = {
			default_format_opts = {
				timeout_ms = 3000,
				async = false,
				quiet = false,
				lsp_format = "fallback",
			},
			format_on_save = function(bufnr)
				if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
					return
				end
				return { timeout_ms = 500, lsp_format = "fallback" }
			end,
			formatters_by_ft = {
				lua = { "stylua" },

				python = { "ruff_format", "ruff_fix", "ruff_organize_imports" },

				javascript = { "biome" },
				typescript = { "biome" },
				javascriptreact = { "biome" },
				typescriptreact = { "biome" },
				json = { "biome" },
				css = { "biome" },
				astro = { "prettier" },

				c = { "clang-format" },
				cpp = { "clang-format" },
				cmake = { "cmake_format" },

				rust = { "rustfmt" },

				nix = { "alejandra" },
			},
			formatters = {
				["clang-format"] = {
					args = { "--style={BasedOnStyle: LLVM, PointerAlignment: Left}" },
				},
				cmake_format = {
					command = "cmake-format",
					args = {
						"--line-width",
						"80",
						"--tab-size",
						"2",
						"--use-tabchars",
						"false",
						"--max-prefix-chars",
						"0",
					},
				},
			},
		},
	},
}
