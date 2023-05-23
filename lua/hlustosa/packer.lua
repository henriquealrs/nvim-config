--builtin.git_fi{}) This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use {
	  'nvim-telescope/telescope.nvim', tag = '0.1.1',
	  -- or                            , branch = '0.1.x',
	  requires = { {'nvim-lua/plenary.nvim'} }
  }
  use('navarasu/onedark.nvim', {
	  priority = 1000,
	  config = function()
		  vim.cmd.colorscheme 'onedark'
	  end
  	}
  )

  -- use({ 
	 --  'rose-pine/neovim', 
	 --  as = 'rose-pine',
	 --  config = function()
		--   vim.cmd('colorscheme rose-pine')
	 --  end
  -- })

  -- vim.cmd('colorscheme rose-pine')
  use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
  use('ThePrimeagen/harpoon')
  use('mbbill/undotree')
  use('tpope/vim-fugitive')
  use {
	  'numToStr/Comment.nvim',
	  config = function()
		  require('Comment').setup()
	  end
  }
  -- use('neovim/nvim-lspconfig') 
  -- use('hrsh7th/cmp-nvim-lsp')
  -- use('hrsh7th/cmp-buffer')
  -- use('hrsh7th/cmp-path')
  -- use('hrsh7th/cmp-cmdline')
  -- use('hrsh7th/nvim-cmp')
  -- use('neoclide/coc.nvim', {branch = 'release'})
  -- use {
	 --  "williamboman/mason.nvim",
	 --  run = ":MasonUpdate" -- :MasonUpdate updates registry contents
  -- }

  -- use('ycm-core/YouCompleteMe')
  -- use('grailbio/bazel-compilation-database')


use('williamboman/mason.nvim', { vim.cmd, 'MasonUpdate'})

  use {
	  'VonHeikemen/lsp-zero.nvim',
	  branch = 'v2.x',
	  requires = {
		  -- LSP Support
	  {'neovim/nvim-lspconfig'},             -- Required
	  {'williamboman/mason-lspconfig.nvim'}, -- Optional
	  -- Autocompletion
	  {'hrsh7th/nvim-cmp'},     -- Required
	  {'hrsh7th/cmp-nvim-lsp'}, -- Required
	  {'L3MON4D3/LuaSnip'},     -- Required
  }
}



-- use('ludovicchabant/vim-gutentags')
end)
