local keymap = vim.keymap.set

-- Options
vim.g.mapleader = " "

-- Clipboard
keymap({ "n", "v" }, "<leader>y", [["+y]])
keymap({ "n", "v" }, "<leader>p", [["+p]])
keymap({ "n" }, "<leader>P", [["+P]])

-- Buffer Navigation
keymap("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
keymap("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
keymap("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete Buffer" })

-- Search
keymap("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })
