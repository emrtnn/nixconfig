local keymap = vim.keymap.set

-- Options
vim.g.mapleader = " "

-- Clipboard
keymap({ "n", "v" }, "<leader>y", [["+y]])
keymap({ "n", "v" }, "<leader>p", [["+p]])
keymap({ "n" }, "<leader>P", [["+P]])

-- Search
keymap("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })
