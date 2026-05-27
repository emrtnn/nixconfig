local opt = vim.opt

-- Search
opt.ignorecase = true
opt.smartcase = true

-- Undo
opt.undofile = true
opt.undolevels = 1000

-- Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true
opt.shiftround = true

-- UI & Scrolling
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.scrolloff = 4
opt.sidescrolloff = 8
opt.wrap = false
opt.termguicolors = true
opt.signcolumn = "yes"
opt.laststatus = 3
opt.showmode = false
opt.guicursor = "i:block-blinkwait0-blinkon400-blinkoff250"

-- Misc
opt.autowrite = true
opt.confirm = true
opt.splitbelow = true
opt.splitright = true
opt.updatetime = 200
opt.timeoutlen = 300
opt.virtualedit = "block"

-- Windows
vim.o.winborder = "rounded"
