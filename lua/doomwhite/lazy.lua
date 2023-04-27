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


-- Lazy options
local opts = {
	root = vim.fn.stdpath("data") .. "/lazy", -- directory where plugins will be installed
	defaults = {
		lazy = false,                          -- should plugins be lazy-loaded?
		version = nil,
		-- default `cond` you can use to globally disable a lot of plugins
		-- when running inside vscode for example
		cond = nil, ---@type boolean|fun(self:LazyPlugin):boolean|nil
		-- version = "*", -- enable this to try installing the latest stable versions of plugins
	},
	-- leave nil when passing the spec as the first argument to setup()
	spec = nil, ---@type LazySpec
	lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json", -- lockfile generated after running update.
	concurrency = nil, ---@type number limit the maximum amount of concurrent tasks
	git = {
		-- defaults for the `Lazy log` command
		-- log = { "-10" }, -- show the last 10 commits
		log = { "--since=3 days ago" }, -- show commits from the last 3 days
		timeout = 120,                -- kill processes that take more than 2 minutes
		url_format = "https://github.com/%s.git",
		-- lazy.nvim requires git >=2.19.0. If you really want to use lazy with an older version,
		-- then set the below to false. This should work, but is NOT supported and will
		-- increase downloads a lot.
		filter = true,
	},
	dev = {
		-- directory where you store your local plugin projects
		path = "~/projects",
		---@type string[] plugins that match these patterns will use your local versions instead of being fetched from GitHub
		patterns = {},  -- For example {"folke"}
		fallback = false, -- Fallback to git when local plugin doesn't exist
	},
	install = {
		-- install missing plugins on startup. This doesn't increase startup time.
		missing = true,
		-- try to load one of these colorschemes when starting an installation during startup
		colorscheme = { "catppuccin" },
	},
	ui = {
		-- a number <1 is a percentage., >1 is a fixed size
		size = { width = 0.8, height = 0.8 },
		wrap = true, -- wrap the lines in the ui
		-- The border to use for the UI window. Accepts same border values as |nvim_open_win()|.
		border = "none",
		icons = {
			cmd = " ",
			config = "",
			event = "",
			ft = " ",
			init = " ",
			import = " ",
			keys = " ",
			lazy = "󰒲 ",
			loaded = "●",
			not_loaded = "○",
			plugin = " ",
			runtime = " ",
			source = " ",
			start = "",
			task = "✔ ",
			list = {
				"●",
				"➜",
				"★",
				"‒",
			},
		},
		-- leave nil, to automatically select a browser depending on your OS.
		-- If you want to use a specific browser, you can define it here
		browser = nil, ---@type string?
		throttle = 20, -- how frequently should the ui process render events
		custom_keys = {
			-- you can define custom key maps here.
			-- To disable one of the defaults, set it to false

			-- open lazygit log
			["<localleader>l"] = function(plugin)
				require("lazy.util").float_term({ "lazygit", "log" }, {
					cwd = plugin.dir,
				})
			end,
			-- open a terminal for the plugin dir
			["<localleader>t"] = function(plugin)
				require("lazy.util").float_term(nil, {
					cwd = plugin.dir,
				})
			end,
		},
	},
	diff = {
		-- diff command <d> can be one of:
		-- * browser: opens the github compare view. Note that this is always mapped to <K> as well,
		--   so you can have a different command for diff <d>
		-- * git: will run git diff and open a buffer with filetype git
		-- * terminal_git: will open a pseudo terminal with git diff
		-- * diffview.nvim: will open Diffview to show the diff
		cmd = "git",
	},
	checker = {
		-- automatically check for plugin updates
		enabled = false,
		concurrency = nil, ---@type number? set to 1 to check for updates very slowly
		notify = true,  -- get a notification when new updates are found
		frequency = 3600, -- check for updates every hour
	},
	change_detection = {
		-- automatically check for config file changes and reload the ui
		enabled = true,
		notify = true, -- get a notification when changes are found
	},
	performance = {
		cache = {
			enabled = true,
		},
		reset_packpath = true, -- reset the package path to improve startup time
		rtp = {
			reset = true,      -- reset the runtime path to $VIMRUNTIME and your config directory
			---@type string[]
			paths = {},        -- add any custom paths here that you want to includes in the rtp
			---@type string[] list any plugins you want to disable here
			disabled_plugins = {
				-- "gzip",
				-- "matchit",
				-- "matchparen",
				-- "netrwPlugin",
				-- "tarPlugin",
				-- "tohtml",
				-- "tutor",
				-- "zipPlugin",
			},
		},
	},
	-- lazy can generate helptags from the headings in markdown readme files,
	-- so :help works even for plugins that don't have vim docs.
	-- when the readme opens with :help it will be correctly displayed as markdown
	readme = {
		enabled = true,
		root = vim.fn.stdpath("state") .. "/lazy/readme",
		files = { "README.md", "lua/**/README.md" },
		-- only generate markdown helptags for plugins that dont have docs
		skip_if_doc_exists = true,
	},
	state = vim.fn.stdpath("state") .. "/lazy/state.json", -- state info for checker and other things
}


-- Lazy plugins
local plugins = {
	{
		'nvim-telescope/telescope.nvim',
		lazy = true,
		tag = '0.1.1',
		dependencies = { { 'nvim-lua/plenary.nvim' } }
	},
	{
		'folke/tokyonight.nvim',
		name = 'tokyonight',
		config = function()
			vim.cmd('colorscheme tokyonight')
			vim.g.tokyonight_style = "storm"
		end
	},
	{
		"catppuccin/nvim",
		name = "catppuccin"
	},
	{
		'ThePrimeagen/harpoon',
		lazy = true
	},
	{
		'mbbill/undotree',
		lazy = true
	},
	{
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate'
	},
	{
		'nvim-treesitter/playground',
		lazy = true
	},
	{
		'tpope/vim-fugitive',
		lazy = true
	},
	{
		'tpope/vim-repeat',
	},
	{
		'tummetott/unimpaired.nvim',
		config = function()
			require('unimpaired').setup {}
		end
	},
	{
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v1.x',
		-- lazy = true,
		dependencies = {
			-- LSP Support
			{ 'neovim/nvim-lspconfig' },          -- Required
			{ 'williamboman/mason-lspconfig.nvim' }, -- Optional
			{ 'williamboman/mason.nvim' },        -- Optional
			{ 'jay-babu/mason-nvim-dap.nvim' },

			-- Autocompletion
			{ 'hrsh7th/nvim-cmp' },
			{ 'hrsh7th/cmp-buffer' },    -- Optional
			{ 'hrsh7th/cmp-nvim-lsp' },  -- Required
			{ 'hrsh7th/cmp-nvim-lua' },  -- Optional
			{ 'hrsh7th/cmp-path' },      -- Optional
			{ 'saadparwaiz1/cmp_luasnip' }, -- Optional

			-- Snippets
			{ 'L3MON4D3/LuaSnip' },          -- Required
			{ 'rafamadriz/friendly-snippets' }, -- Optional
		}
	},
	{
		"glepnir/lspsaga.nvim",
		event = "BufRead",
		config = function()
			require("lspsaga").setup({})
		end,
		dependencies = {
			{ "nvim-tree/nvim-web-devicons" },
			{ "nvim-treesitter/nvim-treesitter" }
		}
	},
	{
		'akinsho/toggleterm.nvim',
		lazy = true,
		version = '*',
		config = true
	},
	{ 'nvim-tree/nvim-web-devicons' },
	-- {
	-- 	'akinsho/bufferline.nvim',
	-- 	version = 'v3.*',
	-- 	dependencies = 'nvim-tree/nvim-web-devicons',
	-- 	config = function()
	-- 		require('toggleterm').setup()
	-- 	end
	-- },
	{
		'nvim-tree/nvim-tree.lua',
		lazy = true,
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		tag = 'nightly' -- optional, updated every week (see issue #1193)
	},
	{
		'terrortylor/nvim-comment',
		keys = { { "g", mode = "v" }, { "g", mode = "n" } },
		config = function()
			require('nvim_comment').setup()
		end
	},
	{
		'folke/trouble.nvim',
		cmd = "TroubleToggle",
		dependencies = 'nvim-tree/nvim-web-devicons',
		config = function()
			require('trouble').setup {}
		end
	},

	{
		"folke/which-key.nvim",
		lazy = true,
		config = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
			require("which-key").setup {}
		end
	},

	{
		'nvim-lualine/lualine.nvim',
		lazy = true,
		dependencies = { 'nvim-tree/nvim-web-devicons' }
	},

	{
		"ThePrimeagen/refactoring.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-treesitter/nvim-treesitter" }
		}
	},

	{
		"windwp/nvim-autopairs",
		config = function() require("nvim-autopairs").setup {} end
	},

	{
		'nvim-orgmode/orgmode',
		ft = 'org',
		config = function()
			require('orgmode').setup {}
		end
	},

	-- {
	-- 	"nvim-neorg/neorg",
	-- 	build = ":Neorg sync-parsers",
	-- 	opts = {
	-- 		load = {
	-- 			["core.defaults"] = {},   -- Loads default behaviour
	-- 			["core.norg.concealer"] = {}, -- Adds pretty icons to your documents
	-- 			["core.norg.dirman"] = {  -- Manages Neorg workspaces
	-- 				config = {
	-- 					workspaces = {
	-- 						notes = "~/notes",
	-- 					},
	-- 				},
	-- 			},
	-- 		},
	-- 	},
	-- 	dependencies = { { "nvim-lua/plenary.nvim" } },
	-- },

	{
		'glepnir/dashboard-nvim',
		event = 'VimEnter',
		config = function()
			require('dashboard').setup {
				-- config
			}
		end,
		dependencies = { { 'nvim-tree/nvim-web-devicons' } }
	},
	-- {
	-- 	"folke/noice.nvim",
	-- 	config = function()
	-- 		require("noice").setup({})
	-- 	end,
	-- 	dependencies = {

	-- 		"MunifTanjim/nui.nvim",
	-- 		"rcarriga/nvim-notify",
	-- 	}
	-- }
	{
		'mfussenegger/nvim-dap',
		cmd = "DapContinue",
		dependencies = {
			'rcarriga/nvim-dap-ui',
			'ldelossa/nvim-dap-projects'
		}
	},
	{
		'xiyaowong/transparent.nvim',
		lazy = false
	},
	{
		'saecki/crates.nvim',
		event = 'BufRead Cargo.toml',
		tag = 'v0.3.0',
		dependencies = { 'nvim-lua/plenary.nvim' },
		config = function()
			require('crates').setup()
		end,
	},

	-- { 'andweeb/presence.nvim' },

	{
		'willothy/nvim-cokeline',
		-- dependencies = 'kyazdani42/nvim-web-devicons', -- If you want devicons
	},

	{
		'Bekaboo/deadcolumn.nvim'
	},

	{
		'chentoast/marks.nvim'
	},

	{
		"ellisonleao/glow.nvim",
		config = true,
		cmd = "Glow"
	},

	-- {
	-- 	'declancm/cinnamon.nvim',
	-- 	config = function() require('cinnamon').setup() end
	-- }
	{
		{ "shortcuts/no-neck-pain.nvim", version = "*" }
	},
}


-- Initialize lazy.nvim
require("lazy").setup(plugins, opts)
