return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			vim.diagnostic.config({
				virtual_text = true,
				virtual_lines = { current_line = true },
				underline = false,
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

					-- Optional: You can remove these if you decide to use the new Nvim native defaults
					map("gr", vim.lsp.buf.references, "Go to References")
					map("gI", vim.lsp.buf.implementation, "Go to Implementation")
					map("<leader>cr", vim.lsp.buf.rename, "Rename Symbol")
					map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
					map("<leader>cd", vim.diagnostic.open_float, "Show Diagnostics")

					local client = vim.lsp.get_client_by_id(event.data.client_id)

					-- Language-specific keymaps
					if client and client.name == "clangd" then
						map("<leader>ch", "<cmd>ClangdSwitchSourceHeader<cr>", "Switch Source/Header")
					end

					-- Inlay hints
					if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
						vim.defer_fn(function()
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

			-- Apply capabilities globally to ALL LSP clients
			vim.lsp.config("*", {
				capabilities = capabilities,
			})

			-- C/C++
			vim.lsp.config("clangd", {
				-- We still need to extend capabilities here because of offsetEncoding
				capabilities = vim.tbl_deep_extend("force", capabilities, { offsetEncoding = { "utf-16" } }),
				cmd = {
					"clangd",
					"--background-index",
					"--clang-tidy",
					"--header-insertion=iwyu",
					"--completion-style=detailed",
					"--function-arg-placeholders",
					"--fallback-style=llvm",
				},
				init_options = {
					usePlaceholders = true,
					completeUnimported = true,
					clangdFileStatus = true,
				},
			})
			vim.lsp.enable("clangd")

			-- Rust
			vim.lsp.config("rust_analyzer", {
				settings = {
					["rust-analyzer"] = {
						cargo = {
							allFeatures = true,
							loadOutDirsFromCheck = true,
							buildScripts = { enable = true },
						},
						procMacro = { enable = true },
						checkOnSave = { command = "clippy" },
					},
				},
			})

			vim.lsp.enable("rust_analyzer")

			vim.lsp.enable("nixd")

			vim.lsp.enable("astro")

			vim.lsp.enable("ruff")

			vim.lsp.enable("neocmake")

			vim.lsp.enable("dockerls")

			vim.lsp.enable("docker_compose_language_services")

			-- Web
			vim.lsp.config("vtsls", {
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

			-- Python
			vim.lsp.config("pyright", {
				settings = {
					python = { analysis = { ignore = { "*" }, typeCheckingMode = "basic" } },
				},
			})
			vim.lsp.enable("pyright")

			-- Lua
			vim.lsp.config("lua_ls", {
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
