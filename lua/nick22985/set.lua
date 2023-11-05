vim.loader.enable()
vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = false

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.backup = false
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 5
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

vim.opt.updatetime = 50
vim.opt.timeoutlen = 500

vim.g.mapleader = " "


-- netrw
vim.g.netrw_banner = 0

-- Fonts
vim.opt.guifont = { "DroidSansMono Nerd Font", "MesloLGS Nerd Font", "Monaco", "Noto Color Emoji", "Consolas", "monospace" }

-- spelling
vim.opt.spelllang = "en_us"
vim.opt.spell = true

-- tabs

-- clipboard support ssh windows

-- vim.g.clipboard = {
-- 	name = "win32yank-wsl",
-- 	copy = {
-- 		["+"] = "win32yank.exe -i --crlf",
-- 		["*"] = "win32yank.exe -i --crlf"
-- 	},
-- 	paste = {
-- 		["+"] = "win32yank.exe -o --lf",
-- 		["*"] = "win32yank.exe -o --lf"
-- 	},
-- 	cache_enabled = 0
-- }

-- vim.g.clipboard = {
-- 	name = "WslClipboard",
-- 	copy = {
-- 		["+"] = "clip.exe",
-- 		["*"] = "clip.exe"
-- 	},
-- 	paste = {
-- 		["+"] = "powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace('`r', ''))",
-- 		["*"] = "powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace('`r', ''))"
-- 	},
-- 	cache_enabled = 0
--
-- }


-- FIXME: this is not working
-- TODO: todo 
-- HACK: hack
-- WARN: warn
-- PERF: perf
-- NOTE: note
-- TEST: test
-- XXX: BROKE
