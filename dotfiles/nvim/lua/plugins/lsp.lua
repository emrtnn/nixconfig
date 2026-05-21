return {
	-- 1. Modern Lua setup for Neovim config
	{
		"folke/lazydev.nvim",
		event = { "BufReadPre", "BufNewFile" },
		ft = "lua",
		opts = {
			library = {
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
			},
		},
	},
	{ "Bilal2453/luvit-meta", lazy = true },
	-- 2. The Core LSP Configuration
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			-- Grab modern capabilities from blink.cmp
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			-- Global Autocommand that runs ONLY when an LSP attaches to a buffer
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					map("gd", vim.lsp.buf.definition, "Go to Definition")
					map("gD", vim.lsp.buf.declaration, "Go to Declaration")
					map("gr", vim.lsp.buf.references, "Go to References")
					map("gI", vim.lsp.buf.implementation, "Go to Implementation")
					map("K", vim.lsp.buf.hover, "Hover Documentation")
					map("<leader>cr", vim.lsp.buf.rename, "Rename Symbol")
					map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
					map("<leader>cd", vim.diagnostic.open_float, "Show Diagnostics")

					-- Enable Native Inlay Hints
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "Toggle Inlay Hints")
					end
				end,
			})

			-- --- THE NEW NATIVE LSP ENABLEMENT API --- --

			-- C/C++
			vim.lsp.config("clangd", { capabilities = capabilities })
			vim.lsp.enable("clangd")

			-- Rust
			vim.lsp.config("rust_analyzer", {
				capabilities = capabilities,
				settings = {
					["rust-analyzer"] = {
						checkOnSave = { command = "clippy" },
					},
				},
			})
			vim.lsp.enable("rust_analyzer")

			-- Modern Nix
			vim.lsp.config("nixd", { capabilities = capabilities })
			vim.lsp.enable("nixd")

			-- Modern Web
			vim.lsp.config("vtsls", { capabilities = capabilities })
			vim.lsp.enable("vtsls")

			vim.lsp.config("astro", { capabilities = capabilities })
			vim.lsp.enable("astro")

			-- Modern Python
			vim.lsp.config("pyright", {
				capabilities = capabilities,
				settings = {
					python = {
						analysis = {
							ignore = { "*" },
							typeCheckingMode = "basic",
						},
					},
				},
			})
			vim.lsp.enable("pyright")

			vim.lsp.config("ruff", { capabilities = capabilities })
			vim.lsp.enable("ruff")

			-- Lua
			vim.lsp.config("lua_ls", {
				capabilities = capabilities,
				settings = {
					Lua = {
						completion = { callSnippet = "Replace" },
						telemetry = { enable = false },
						hint = { enable = true },
					},
				},
			})
			vim.lsp.enable("lua_ls")
		end,
	},
}
