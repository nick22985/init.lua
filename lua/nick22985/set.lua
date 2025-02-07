vim.loader.enable()
vim.opt.nu = true
vim.opt.relativenumber = true
vim.g.have_nerd_font = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = false
-- vim.opt.conceallevel = 2

vim.opt.smartindent = true
vim.opt.autoindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.breakindent = true
-- vim.opt.list = true
-- vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.inccommand = "split"

vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 5
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

-- vim.opt.updatetime = 50
vim.opt.timeoutlen = 1000

vim.g.mapleader = " "

vim.g.aw_hostname = vim.uv.os_gethostname()
vim.g.netrw_banner = 0

-- Fonts
vim.opt.guifont =
	{ "DroidSansMono Nerd Font", "MesloLGS Nerd Font", "Monaco", "Noto Color Emoji", "Consolas", "monospace" }

-- spelling
vim.opt.spelllang = "en_us"
vim.opt.spell = true

-- FIXME: this is not working
-- TODO: todo
-- HACK: hack
-- WARN: warn
-- PERF: perf
-- NOTE: note
-- TEST: test
-- XXX: BROKE
