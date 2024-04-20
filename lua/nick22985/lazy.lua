local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("nick22985.plugins")
require("lazy").setup({
	icons = vim.g.have_nerd_font and {} or {
		cmd = "⌘",
		config = "🛠",
		event = "📅",
		ft = "📂",
		init = "⚙",
		keys = "🗝",
		plugin = "🔌",
		runtime = "💻",
		require = "🌙",
		source = "📄",
		start = "🚀",
		task = "📌",
		lazy = "💤 ",
	},
})

-- local plugins = {
-- 	-- git Stuff
-- 	{
-- 		'anuvyklack/keymap-amend.nvim',
-- 		dependencies = {
-- 			'anuvyklack/keymap-amend.nvim',
-- 		}
-- 	},
-- 	-- "ActivityWatch/aw-watcher-vim",
-- }
--
-- local opts = {
-- 	-- checker = {
-- 	-- 	notify = true,
-- 	-- 	frequency = 60, -- 3600 1 hour
-- 	-- },
-- 	-- change_detection = {
-- 	-- 	enable = true,
-- 	-- 	notify = true,
-- 	-- }
-- }
--
-- require("lazy").setup(plugins, opts)
