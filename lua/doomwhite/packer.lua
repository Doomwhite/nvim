-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init {
	display = {
		open_fn = function()
			return require("packer.util").float { border = "rounded" }
		end,
	},
}

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	-- Packer can manage itself
	use('wbthomason/packer.nvim')

	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.1',
		-- or                            , branch = '0.1.x',
		requires = { { 'nvim-lua/plenary.nvim' } }
	}


	use({
		'folke/tokyonight.nvim',
		as = 'tokyonight',
		config = function()
			vim.cmd('colorscheme tokyonight')
			vim.g.tokyonight_style = "storm"
		end
	})

	use { "catppuccin/nvim", as = "catppuccin" }

	use('ThePrimeagen/harpoon')

	use('mbbill/undotree')

	use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })

	use('nvim-treesitter/playground')

	use('tpope/vim-fugitive')

	use {
		'tummetott/unimpaired.nvim',
		config = function()
			require('unimpaired').setup {}
		end
	}

	use {
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v1.x',
		requires = {
			-- LSP Support
			{ 'neovim/nvim-lspconfig' }, -- Required
			{ 'williamboman/mason-lspconfig.nvim' }, -- Optional
			{ 'williamboman/mason.nvim' }, -- Optional

			-- Autocompletion
			{ 'hrsh7th/cmp-buffer' }, -- Optional
			{ 'hrsh7th/cmp-nvim-lsp' }, -- Required
			{ 'hrsh7th/cmp-nvim-lua' }, -- Optional
			{ 'hrsh7th/cmp-path' }, -- Optional
			{ 'hrsh7th/nvim-cmp' }, -- Required
			{ 'saadparwaiz1/cmp_luasnip' }, -- Optional

			-- Snippets
			{ 'L3MON4D3/LuaSnip' }, -- Required
			{ 'rafamadriz/friendly-snippets' }, -- Optional
		}
	}

	use { "akinsho/toggleterm.nvim", tag = '*', config = function()
		require("toggleterm").setup()
	end }

	use('nvim-tree/nvim-web-devicons')

	use { 'akinsho/bufferline.nvim', tag = "v3.*", requires = 'nvim-tree/nvim-web-devicons', config = function()
		require("toggleterm").setup()
	end }

	use {
		'nvim-tree/nvim-tree.lua',
		requires = {
			'nvim-tree/nvim-web-devicons', -- optional, for file icons
		},
		tag = 'nightly' -- optional, updated every week. (see issue #1193)
	}

	use {
		'terrortylor/nvim-comment',
		config = function()
			require('nvim_comment').setup()
		end
	}

	use {
		"folke/trouble.nvim",
		requires = "nvim-tree/nvim-web-devicons",
		config = function()
			require("trouble").setup {
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			}
		end
	}

	use {
		"folke/which-key.nvim",
		config = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
			require("which-key").setup {
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			}
		end
	}

	use {
		'nvim-lualine/lualine.nvim',
		requires = { 'kyazdani42/nvim-web-devicons', opt = true }
	}
end)
