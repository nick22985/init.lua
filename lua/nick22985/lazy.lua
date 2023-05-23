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

local plugins = {
	{
		'nvim-telescope/telescope.nvim',
		dependencies = {
			 'nvim-telescope/telescope-file-browser.nvim',
			'nvim-telescope/telescope-hop.nvim', -- NEEDS SETUP
			'nvim-telescope/telescope-ui-select.nvim',
			'nvim-lua/plenary.nvim',
			{
				'nvim-telescope/telescope-fzf-native.nvim',
				build = 'make',
			}
		}
	},
	"ThePrimeagen/git-worktree.nvim",
	"AckslD/nvim-neoclip.lua",
	{
		'rose-pine/neovim',
		name = 'rose-pine',
	},
	"olimorris/onedarkpro.nvim",
	"folke/trouble.nvim",
	{
		'nvim-treesitter/nvim-treesitter',
		build = ":TSUpdate",
		dependencies = {
			'JoosepAlviste/nvim-ts-context-commentstring',
			'nvim-treesitter/nvim-treesitter-context',
			'nvim-treesitter/nvim-treesitter-textobjects',
			'nvim-treesitter/playground',
			'windwp/nvim-ts-autotag',
		},
	},
	'numToStr/Comment.nvim',
	'theprimeagen/harpoon',
	'mbbill/undotree',
	{
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v2.x',
		dependencies = {
			-- LSP Support
			{ 'neovim/nvim-lspconfig' }, -- Required
			{
				-- Optional
				'williamboman/mason.nvim',
				build = ":MasonUpdate"

			},
			{ 'williamboman/mason-lspconfig.nvim' }, -- Optional

			-- Autocompletion
			{ 'hrsh7th/nvim-cmp' }, -- Required
			{ 'hrsh7th/cmp-nvim-lsp' }, -- Required
			{ 'L3MON4D3/LuaSnip' }, -- Required
		}
	},
	'wakatime/vim-wakatime',
	"github/copilot.vim",
	"laytan/cloak.nvim",
	{
		"NTBBloodbath/galaxyline.nvim",
	},
	'nvim-tree/nvim-web-devicons',
	'ryanoasis/vim-devicons',

	'windwp/nvim-autopairs',
	-- git Stuff
	'tpope/vim-fugitive',
	'lewis6991/gitsigns.nvim',
	-- use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' }
	-- DAP
	-- use 'mfussenegger/nvim-dap'
	-- use { "mxsdev/nvim-dap-vscode-js", requires = {"mfussenegger/nvim-dap"} }
	-- use 'rcarriga/nvim-dap-ui'
	-- use 'ldelocsa/nvim-dap-projects'

	---------------------------------------------------------------
	'eandrju/cellular-automaton.nvim',
	"nvim-lua/plenary.nvim",
	"jose-elias-alvarez/null-ls.nvim",
}

local opts = {
	-- checker = {
	-- 	notify = true,
	-- 	frequency = 60, -- 3600 1 hour
	-- },
	-- change_detection = {
	-- 	enable = true,
	-- 	notify = true,
	-- }
}

require("lazy").setup(plugins, opts)
