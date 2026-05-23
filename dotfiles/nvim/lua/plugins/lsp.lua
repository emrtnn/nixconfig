return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			vim.diagnostic.config({
				virtual_text = false,
				virtual_lines = true,
				signs = true,
				update_in_insert = false,
				severity_sort = true,
				float = {
					border = "rounded",
					source = true,
				},
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					map("]d", function()
						vim.diagnostic.jump({ count = 1, float = true })
					end, "Next diagnostic")
					map("[d", function()
						vim.diagnostic.jump({ count = -1, float = true })
					end, "Previous diagnostic")
					map("gd", vim.lsp.buf.definition, "Go to Definition")
					map("gD", vim.lsp.buf.declaration, "Go to Declaration")
					map("gr", vim.lsp.buf.references, "Go to References")
					map("gI", vim.lsp.buf.implementation, "Go to Implementation")
					map("<leader>cr", vim.lsp.buf.rename, "Rename Symbol")
					map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
					map("<leader>cd", vim.diagnostic.open_float, "Show Diagnostics")
					-- I think this is now binded by Nvim >0.10 but I'll leave it here to make it more explicit
					map("K", vim.lsp.buf.hover, "Hover Documentation")

					-- Enable Native Inlay Hints
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
						-- Delay the enablement by 500ms so the viewport finishes rendering first
						-- This fixes bug where hints not showing on initial viewport text
						vim.defer_fn(function()
							-- Double check the buffer is still valid before applying
							if vim.api.nvim_buf_is_valid(event.buf) then
								vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
							end
						end, 500)
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "Toggle Inlay Hints")
					end
				end,
			})

			-- C/C++
			vim.lsp.config("clangd", { capabilities = capabilities })
			vim.lsp.config("neocmkae", { capabilities = capabilities })
			vim.lsp.enable("clangd")
			vim.lsp.enable("neocmake")

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

			-- Nix
			vim.lsp.config("nixd", { capabilities = capabilities })
			vim.lsp.enable("nixd")

			-- Web
			-- Typescript/Javascript
			vim.lsp.config("vtsls", {
				capabilities = capabilities,
				settings = {
					typescript = {
						inlayHints = {
							parameterNames = { enabled = "literals" },
							parameterTypes = { enabled = true },
							variableTypes = { enabled = true },
							propertyDeclarationTypes = { enabled = true },
							functionLikeReturnTypes = { enabled = true },
							enumMemberValues = { enabled = true },
						},
					},
					javascript = {
						inlayHints = {
							parameterNames = { enabled = "literals" },
							parameterTypes = { enabled = true },
							variableTypes = { enabled = true },
							propertyDeclarationTypes = { enabled = true },
							functionLikeReturnTypes = { enabled = true },
							enumMemberValues = { enabled = true },
						},
					},
				},
			})
			vim.lsp.enable("vtsls")

			-- Astro
			vim.lsp.config("astro", { capabilities = capabilities })
			vim.lsp.enable("astro")
			--- ---

			-- Python
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
