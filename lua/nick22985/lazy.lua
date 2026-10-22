-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

if vim.env.PROF then
	-- example for lazy.nvim
	-- change this to the correct path for your plugin manager
	local snacks = vim.fn.stdpath("data") .. "/lazy/snacks.nvim"
	vim.opt.rtp:append(snacks)
	require("snacks.profiler").startup({
		startup = {
			event = "VimEnter", -- stop profiler on this event. Defaults to `VimEnter`
			-- event = "UIEnter",
			-- event = "VeryLazy",
		},
	})
end

require("lazy").setup("nick22985.plugins", {
	-- defaults = {
	-- 	lazy = true,
	-- },
	rocks = { enabled = false },
	dev = {
		path = function(plugin)
			local dir = vim.fn.expand(vim.env.NVIM_DEV_PLUGINS or "~/projects/personal/neovim/plugins")
				.. "/"
				.. plugin.name
			local head = io.open(dir .. "/.bare/HEAD") or io.open(dir .. "/HEAD")
			if head then
				local branch = (head:read("*l") or ""):match("^ref: refs/heads/(.+)$")
				head:close()
				if branch and vim.uv.fs_stat(dir .. "/" .. branch) then
					return dir .. "/" .. branch
				end
			end
			return dir
		end,
		fallback = false,
	},
	ui = {
		icons = {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			source = "📄",
			start = "🚀",
			task = "📌",
		},
	},
})
