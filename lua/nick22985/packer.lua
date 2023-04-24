local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
		vim.cmd [[packadd packer.nvim]]
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()

-- This file can be loaded by calling `lua require('packer')` from your init.vim
local status, packer = pcall(require, "packer")
if not status then
	print("Packer is not installed")
	return
end
-- Reloads Neovim after whenever you save plugins.lua
vim.cmd([[
    augroup packer_user_config
      autocmd!
     autocmd BufWritePost packer.lua source <afile> | PackerSync
  augroup END
]])



-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return packer.startup(function(use)
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'

	----------------------------Packer--------------------------------
	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.1',
		-- or                            , branch = '0.1.x',
		requires = { { 'nvim-lua/plenary.nvim' } }
	}

	use {
		"nvim-telescope/telescope-file-browser.nvim",
		requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
	}
	-- {{{ needs setup
	use {
		"nvim-telescope/telescope-hop.nvim",
		requires = { "nvim-telescope/telescope.nvim" }
	}

	use { 'nvim-telescope/telescope-ui-select.nvim' }
	use { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }
	use "ThePrimeagen/git-worktree.nvim"
	use "AckslD/nvim-neoclip.lua"
	-- }}}
	use({
		'rose-pine/neovim',
		as = 'rose-pine',
	})

	use "olimorris/onedarkpro.nvim"


	use("folke/trouble.nvim")

	use {
		'nvim-treesitter/nvim-treesitter',
		requires = {
			'JoosepAlviste/nvim-ts-context-commentstring'
		},
	}
	use('nvim-treesitter/nvim-treesitter-context')
	use({
		"nvim-treesitter/nvim-treesitter-textobjects",
		after = "nvim-treesitter",
		requires = "nvim-treesitter/nvim-treesitter",
	})


	use('windwp/nvim-ts-autotag')
	use('numToStr/Comment.nvim')

	use('nvim-treesitter/playground')
	use('theprimeagen/harpoon')
	use('mbbill/undotree')
	use {
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v2.x',
		requires = {
			-- LSP Support
			{ 'neovim/nvim-lspconfig' }, -- Required
			{
				-- Optional
				'williamboman/mason.nvim',
				run = function()
					pcall(vim.cmd, 'MasonUpdate')
				end,
			},
			{ 'williamboman/mason-lspconfig.nvim' }, -- Optional

			-- Autocompletion
			{ 'hrsh7th/nvim-cmp' }, -- Required
			{ 'hrsh7th/cmp-nvim-lsp' }, -- Required
			{ 'L3MON4D3/LuaSnip' }, -- Required
		}
	}

	use('wakatime/vim-wakatime')

	use("github/copilot.vim")

	use("laytan/cloak.nvim")

	use({
		"NTBBloodbath/galaxyline.nvim",
		-- some optional icons
		requires = { "kyazdani42/nvim-web-devicons", opt = true }
	})

	use 'nvim-tree/nvim-web-devicons'
	use 'ryanoasis/vim-devicons'

	use 'windwp/nvim-autopairs'
	-- git Stuff
	use('tpope/vim-fugitive')
	use 'lewis6991/gitsigns.nvim'
	-- use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' }
	-- DAP
	-- use 'mfussenegger/nvim-dap'
	-- use { "mxsdev/nvim-dap-vscode-js", requires = {"mfussenegger/nvim-dap"} }
	-- use 'rcarriga/nvim-dap-ui'
	-- use 'ldelocsa/nvim-dap-projects'

	---------------------------------------------------------------
	use('eandrju/cellular-automaton.nvim')
	-- use({'neoclide/coc.nvim', branch = 'release'})
	use "nvim-lua/plenary.nvim"

	if packer_bootstrap then
		packer.sync()
	end
end)
