-- Disable netrw as per nvim-tree request
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Large cursor
vim.opt.guicursor = ""

-- Set highlight on search
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Make line numbers default
vim.opt.nu = true
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable mouse mode
vim.opt.mouse = "a"

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Decrease update time
vim.opt.updatetime = 50
vim.opt.signcolumn = "yes"

-- Set colorscheme
vim.opt.termguicolors = true

-- Set completeopt to have a better completion experience
vim.opt.completeopt = "menuone,noselect"

vim.opt.scrolloff = 8
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

-- No swapfiles
vim.opt.swapfile = false

-- Spellchecking
vim.opt.spelllang = "en_us"
vim.opt.spell = true
