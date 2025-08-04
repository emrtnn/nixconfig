vim.g.mapleader = " "

local keymap = vim.keymap

-- Oil.nvim
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
keymap.set("n", "<leader>e", "<cmd>Oil<CR>", { desc = "Open Oil at current dir" })
keymap.set("n", "<leader>E", "<cmd>Oil .<CR>", { desc = "Open Oil at root dir" })

-- Formatting
vim.keymap.set({ "n", "v" }, "<leader>f", function()
	require("conform").format({ async = true })
end, { desc = "Format buffer" })

-- Window navigation
keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to window left" })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to window below" })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to window above" })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to window right" })

-- Clipboard
keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
keymap.set("n", "<leader>yy", '"+yy', { desc = "Yank line to system clipboard" })
keymap.set({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from system clipboard after cursor" })
keymap.set("n", "<leader>P", '"+P', { desc = "Paste from system clipboard before cursor" })
