return {
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPost", "BufNewFile" },
		keys = {
			{
				"<leader>cl",
				function()
					require("lint").try_lint()
				end,
				desc = "Lint current buffer",
			},
		},
		config = function()
			local lint = require("lint")

			-- Biome's human-readable output changes as diagnostics gain notes, so
			-- consume its stable Reviewdog JSON output instead.
			local biomejs = lint.linters.biomejs
			biomejs.args = { "lint", "--reporter=rdjson" }
			biomejs.stream = "stdout"
			biomejs.parser = function(output)
				local ok, decoded = pcall(vim.json.decode, output)
				if not ok then
					return {}
				end

				local severities = {
					ERROR = vim.diagnostic.severity.ERROR,
					WARNING = vim.diagnostic.severity.WARN,
					INFO = vim.diagnostic.severity.INFO,
				}
				local diagnostics = {}

				for _, diagnostic in ipairs(decoded.diagnostics or {}) do
					local range = diagnostic.location and diagnostic.location.range
					if range and range.start then
						table.insert(diagnostics, {
							lnum = range.start.line - 1,
							col = range.start.column - 1,
							end_lnum = range["end"] and range["end"].line - 1,
							end_col = range["end"] and range["end"].column - 1,
							severity = severities[diagnostic.severity] or vim.diagnostic.severity.WARN,
							message = diagnostic.message,
							source = (decoded.source and decoded.source.name) or "Biome",
							code = diagnostic.code and diagnostic.code.value,
						})
					end
				end

				return diagnostics
			end

			-- Keep analyzers already exposed by an LSP out of this table. In
			-- particular, Ruff, Clippy, clang-tidy, Solhint, and Zig diagnostics
			-- are provided by their respective language servers.
			lint.linters_by_ft = {
				astro = { "biomejs" },
				css = { "biomejs" },
				html = { "biomejs" },
				javascript = { "biomejs" },
				javascriptreact = { "biomejs" },
				json = { "biomejs" },
				jsonc = { "biomejs" },
				typescript = { "biomejs" },
				typescriptreact = { "biomejs" },

				c = { "cppcheck" },
				cpp = { "cppcheck" },
				cmake = { "cmakelint" },

				nix = { "statix" },
				sh = { "shellcheck" },
				bash = { "shellcheck" },
				dockerfile = { "hadolint" },
			}

			local function lint_buffer(opts)
				if vim.bo.buftype == "" then
					lint.try_lint(nil, opts)
				end
			end

			local group = vim.api.nvim_create_augroup("nvim-lint", { clear = true })

			-- Run every analyzer when the on-disk contents are current.
			vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
				group = group,
				callback = function()
					lint_buffer()
				end,
			})

			-- Between writes, only run analyzers which explicitly support stdin.
			vim.api.nvim_create_autocmd("InsertLeave", {
				group = group,
				callback = function()
					lint_buffer({ filter = "stdin" })
				end,
			})

			-- The plugin is loaded by BufReadPost, so its autocmd cannot observe
			-- that same event. Lint the initial buffer once setup has completed.
			local initial_buffer = vim.api.nvim_get_current_buf()
			vim.schedule(function()
				if not vim.api.nvim_buf_is_valid(initial_buffer) then
					return
				end
				vim.api.nvim_buf_call(initial_buffer, function()
					if vim.fn.filereadable(vim.api.nvim_buf_get_name(0)) == 1 then
						lint_buffer()
					else
						lint_buffer({ filter = "stdin" })
					end
				end)
			end)
		end,
	},
}
