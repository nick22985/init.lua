local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
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

    if packer_bootstrap then
        require('packer').sync()
    end

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.1',
        -- or                            , branch = '0.1.x',
        requires = { {'nvim-lua/plenary.nvim'} }
    }

    use({ 'rose-pine/neovim',
    as = 'rose-pine',
    config = function()
        vim.cmd('colorscheme rose-pine')
        --vim.cmd('lua ColorMyPencils()')
    end
})

use "olimorris/onedarkpro.nvim"


use({
    "folke/trouble.nvim",
    config = function()
        require("trouble").setup {
            --icons = false,
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        }
    end
})

use {
    'nvim-treesitter/nvim-treesitter',
    requires = {
        'JoosepAlviste/nvim-ts-context-commentstring'
    },
    run = ':TSUpdate'
}

    use('nvim-treesitter/nvim-treesitter-context')


use {
    'numToStr/Comment.nvim',
    config = function()
        require('Comment').setup()
    end
}

use('nvim-treesitter/playground')
use('theprimeagen/harpoon')
use('mbbill/undotree')
use('tpope/vim-fugitive')
use {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    requires = {
        -- LSP Support
        {'neovim/nvim-lspconfig'},             -- Required
        {                                      -- Optional
        'williamboman/mason.nvim',
        run = function()
            pcall(vim.cmd, 'MasonUpdate')
        end,
    },
    {'williamboman/mason-lspconfig.nvim'}, -- Optional

    -- Autocompletion
    {'hrsh7th/nvim-cmp'},     -- Required
    {'hrsh7th/cmp-nvim-lsp'}, -- Required
    {'L3MON4D3/LuaSnip'},     -- Required
}
}

use('wakatime/vim-wakatime')

use("github/copilot.vim")

use("laytan/cloak.nvim")

end)
