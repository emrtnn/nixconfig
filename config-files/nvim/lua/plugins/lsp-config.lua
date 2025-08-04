return {
	"neovim/nvim-lspconfig",

	config = function()
		-- Lsp global configurations
		vim.diagnostic.config({
			underline = true,
			update_in_insert = false,
			virtual_text = {
				spacing = 4,
				source = "if_many", -- Only show source if there are multiple diagnostics
				prefix = "●",
			},
			severity_sort = true,
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = "",
					[vim.diagnostic.severity.WARN] = "",
					[vim.diagnostic.severity.HINT] = "",
					[vim.diagnostic.severity.INFO] = "",
				},
			},
		})

		-- Override the default hover handler to add a border
		local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
		vim.lsp.util.open_floating_preview = function(contents, syntax, opts, ...)
			opts = opts or {}
			opts.border = opts.border or "rounded"
			return orig_util_open_floating_preview(contents, syntax, opts, ...)
		end

		-- Define the callback that will run ONCE for any LSP attach
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				local client = vim.lsp.get_client_by_id(ev.data.client_id)
				if not client then
					return
				end

				local bufnr = ev.buf

				-- Enable omnifunc completion
				vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

				-- Keymaps with descriptions for which-key
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to Declaration", buffer = bufnr })
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition", buffer = bufnr })
				vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover Documentation", buffer = bufnr })
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to Implementation", buffer = bufnr })
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename Symbol", buffer = bufnr })
				vim.keymap.set(
					{ "n", "v" },
					"<leader>ca",
					vim.lsp.buf.code_action,
					{ desc = "Code Action", buffer = bufnr }
				)
				vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Go to References", buffer = bufnr })

				if client:supports_method("textDocument/inlayHint") then
					vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
				end
				if client:supports_method("textDocument/codeLens") then
					vim.lsp.codelens.refresh()
					vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
						buffer = bufnr,
						callback = vim.lsp.codelens.refresh,
					})
				end
			end,
		})

		-- The actual list of servers
		local servers = {
			"nil_ls",
			"hyprls",
			"marksman",
			"docker_compose_language_service",
			"dockerls",
			"html",
			"cssls",
			"jsonls",
			"eslint",
			"vtsls",
			"pyright",
			"ruff",
			"biome",
			"emmet_ls",
			"gopls",
			"rust_analyzer",
			"yamlls",
			"tailwindcss",
			"lua_ls",
		}

		-- Just enable the servers. The autocmd will handle the rest.
		for _, server_name in ipairs(servers) do
			vim.lsp.enable(server_name)
		end

		vim.lsp.config("pyright", {
			-- Disable pyright's formatting provider in favor of conform.nvim
			on_init = function(client)
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.documentRangeFormattingProvider = false
			end,
		})

		vim.lsp.config("vtsls", {
			-- Disable vtsls's formatting provider in favor of conform.nvim
			on_init = function(client)
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.documentRangeFormattingProvider = false
			end,
		})
	end,
}
