vim.loader.enable()
vim.opt.nu = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.g.have_nerd_font = true

-- tabstop to define the number of spaces a tab character is displayed as
vim.opt.tabstop = 2
-- will make tab = spaces if true
vim.opt.expandtab = false
-- set softtabstop to control how many spaces are inserted when pressing the Tab key if expandtab true
vim.opt.softtabstop = 8
-- shiftwidth to control the number of spaces used for indentation:
vim.opt.shiftwidth = 2

vim.keymap.set("v", ">", ">gv")

vim.opt.conceallevel = 0

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
vim.opt.list = true
vim.opt.listchars = { tab = "→ ", space = "·", trail = "·", nbsp = "␣" }
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

vim.o.grepprg = "rg --vimgrep --smart-case"
vim.o.grepformat = "%f:%l:%c:%m"

-- Don't have `o` add a comment
vim.opt.formatoptions:remove({ "o", "r" })
vim.opt.titlestring = '%t%( %M%)%( (%{expand("%:~:h")})%)%a (nvim)'

-- FIXME: this is not working
-- TODO: todo
-- HACK: hack
-- WARN: warn
-- PERF: perf
-- NOTE: note
-- TEST: test
-- XXX: BROKE
-- SEC: security
-- vim.lsp.set_log_level("DEBUG")
