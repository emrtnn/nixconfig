return {
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				signs = {
					add = { text = "▎" },
					change = { text = "▎" },
					delete = { text = "" },
					topdelete = { text = "" },
					changedelete = { text = "▎" },
					untracked = { text = "▎" },
				},
				signs_staged = {
					add = { text = "▎" },
					change = { text = "▎" },
					delete = { text = "" },
					topdelete = { text = "" },
					changedelete = { text = "▎" },
				},
				on_attach = function(bufnr)
					local gs = package.loaded.gitsigns

					local function map(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end

					-- Navigation
					map("n", "]c", function()
						if vim.wo.diff then
							return "]c"
						end
						vim.schedule(function()
							gs.next_hunk()
						end)
						return "<Ignore>"
					end, { expr = true, desc = "Next Hunk" })

					map("n", "[c", function()
						if vim.wo.diff then
							return "[c"
						end
						vim.schedule(function()
							gs.prev_hunk()
						end)
						return "<Ignore>"
					end, { expr = true, desc = "Previous Hunk" })

					-- Actions
					-- Staging commands are removed as they are redundant with jujutsu.
					-- We keep reset_hunk and reset_buffer to quickly revert unwanted changes.
					map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset Hunk" })
					map("v", "<leader>hr", function()
						gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, { desc = "Reset Hunk" })
					map("n", "<leader>hR", gs.reset_buffer, { desc = "Reset Buffer" })

					map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview Hunk" })
					map("n", "<leader>hb", function()
						gs.blame_line({ full = true })
					end, { desc = "Blame Line" })
					map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "Toggle Blame" })
					map("n", "<leader>hd", gs.diffthis, { desc = "Diff This" })
					map("n", "<leader>hD", function()
						gs.diffthis("~")
					end, { desc = "Diff This ~" })
					map("n", "<leader>td", gs.toggle_deleted, { desc = "Toggle Deleted" })

					map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select Hunk" })
				end,
			})
		end,
	},
}
