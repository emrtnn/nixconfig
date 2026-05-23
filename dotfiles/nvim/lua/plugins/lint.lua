return {
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPost", "BufNewFile", "BufWritePost" },
		opts = {
			-- Event to trigger linters
			events = { "BufWritePost", "BufReadPost", "InsertLeave" },
			linters_by_ft = {
				dockerfile = { "hadolint" },
				nix = { "statix" },
				cmake = { "cmakelint" },
			},
			---@type table<string,table>
			linters = {},
		},
		config = function(_, opts)
			local M = {}
			local lint = require("lint")

			-- Safely merge custom linter options from the opts table
			for name, linter in pairs(opts.linters) do
				local current = lint.linters[name] ---@type table
				if type(linter) == "table" and type(current) == "table" then
					lint.linters[name] = vim.tbl_deep_extend("force", current, linter)
					if type(linter.prepend_args) == "table" then
						lint.linters[name].args = lint.linters[name].args or {}
						vim.list_extend(lint.linters[name].args, linter.prepend_args)
					end
				else
					lint.linters[name] = linter
				end
			end
			lint.linters_by_ft = opts.linters_by_ft

			-- Debounce function to prevent spawning too many linter processes
			function M.debounce(ms, fn)
				local timer = assert(vim.uv.new_timer(), "Failed to create timer")
				return function(...)
					local argv = { ... }
					timer:start(ms, 0, function()
						timer:stop()
						vim.schedule_wrap(fn)(unpack(argv))
					end)
				end
			end

			-- Custom linting logic to handle conditions and fallbacks
			function M.lint()
				-- Safely handle potential nil returns with `or {}`
				local names = lint._resolve_linter_by_ft(vim.bo.filetype) or {}
				names = vim.list_extend({}, names)

				if #names == 0 then
					vim.list_extend(names, lint.linters_by_ft["_"] or {})
				end

				vim.list_extend(names, lint.linters_by_ft["*"] or {})

				local ctx = { filename = vim.api.nvim_buf_get_name(0) }
				ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")

				names = vim.tbl_filter(function(name)
					-- Cast linter to any to suppress undefined field warnings for 'condition'
					local linter = lint.linters[name] ---@type any
					if not linter then
						vim.notify("Linter not found: " .. name, vim.log.levels.WARN, { title = "nvim-lint" })
					end
					return linter and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
				end, names)

				if #names > 0 then
					lint.try_lint(names)
				end
			end

			-- Attach the debounced linting function to the specified events
			vim.api.nvim_create_autocmd(opts.events, {
				group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
				callback = M.debounce(100, M.lint),
			})

			-- Manual trigger
			vim.keymap.set("n", "<leader>cl", function()
				M.lint()
				vim.notify("Linting triggered", vim.log.levels.INFO)
			end, { desc = "Trigger Linting" })
		end,
	},
}
