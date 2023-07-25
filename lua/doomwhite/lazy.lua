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

			-- Rust
			{ 'simrat39/rust-tools.nvim' }
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
		lazy = false,
		run = ":TransparentEnable"
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

	--{
	--	"nvim-neo-tree/neo-tree.nvim",
	--	version = "v2.x",
	--	dependencies = {
	--		"nvim-lua/plenary.nvim",
	--		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
	--		"MunifTanjim/nui.nvim",
	--	}
	--},

	{
		"folke/todo-comments.nvim",
		dependencies = "nvim-lua/plenary.nvim"
	},
	{
		"elihunter173/dirbuf.nvim"
	},
	{
		"rebelot/kanagawa.nvim"
	},
	{
		"epwalsh/obsidian.nvim",
		lazy = true,
		-- event = { "BufReadPre path/to/my-vault/**.md" },
		-- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand':
		-- event = { "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md" },
		dependencies = {
			"hrsh7th/nvim-cmp",
		},
		opts = {
			-- Required, the path to your vault directory.
			dir = "~/Documents/Obsidian-vault/", -- no need to call 'vim.fn.expand' here

			-- Optional, if you keep notes in a specific subdirectory of your vault.
			notes_subdir = "notes",

			-- Optional, set the log level for Obsidian. This is an integer corresponding to one of the log
			-- levels defined by "vim.log.levels.*" or nil, which is equivalent to DEBUG (1).
			log_level = vim.log.levels.DEBUG,

			daily_notes = {
				-- Optional, if you keep daily notes in a separate directory.
				folder = "notes/dailies",
				-- Optional, if you want to change the date format for daily notes.
				date_format = "%Y-%m-%d"
			},

			-- Optional, completion.
			completion = {
				-- If using nvim-cmp, otherwise set to false
				nvim_cmp = true,
				-- Trigger completion at 2 chars
				min_chars = 2,
				-- Where to put new notes created from completion. Valid options are
				--  * "current_dir" - put new notes in same directory as the current buffer.
				--  * "notes_subdir" - put new notes in the default notes subdirectory.
				new_notes_location = "current_dir"
			},

			-- Optional, customize how names/IDs for new notes are created.
			note_id_func = function(title)
				-- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
				-- In this case a note with the title 'My new note' will given an ID that looks
				-- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
				local suffix = ""
				if title ~= nil then
					-- If title is given, transform it into valid file name.
					suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
				else
					-- If title is nil, just add 4 random uppercase letters to the suffix.
					for _ = 1, 4 do
						suffix = suffix .. string.char(math.random(65, 90))
					end
				end
				return tostring(os.time()) .. "-" .. suffix
			end,

			-- Optional, set to true if you don't want Obsidian to manage frontmatter.
			disable_frontmatter = false,

			-- Optional, alternatively you can customize the frontmatter data.
			note_frontmatter_func = function(note)
				-- This is equivalent to the default frontmatter function.
				local out = { id = note.id, aliases = note.aliases, tags = note.tags }
				-- `note.metadata` contains any manually added fields in the frontmatter.
				-- So here we just make sure those fields are kept in the frontmatter.
				if note.metadata ~= nil and require("obsidian").util.table_length(note.metadata) > 0 then
					for k, v in pairs(note.metadata) do
						out[k] = v
					end
				end
				return out
			end,

			-- Optional, for templates (see below).
			templates = {
				subdir = "templates",
				date_format = "%Y-%m-%d-%a",
				time_format = "%H:%M",
			},

			-- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
			-- URL it will be ignored but you can customize this behavior here.
			follow_url_func = function(url)
				-- Open the URL in the default web browser.
				vim.fn.jobstart({ "open", url }) -- Mac OS
				-- vim.fn.jobstart({"xdg-open", url})  -- linux
			end,

			-- Optional, set to true if you use the Obsidian Advanced URI plugin.
			-- https://github.com/Vinzent03/obsidian-advanced-uri
			use_advanced_uri = true,

			-- Optional, set to true to force ':ObsidianOpen' to bring the app to the foreground.
			open_app_foreground = false,

			-- Optional, by default commands like `:ObsidianSearch` will attempt to use
			-- telescope.nvim, fzf-lua, and fzf.nvim (in that order), and use the
			-- first one they find. By setting this option to your preferred
			-- finder you can attempt it first. Note that if the specified finder
			-- is not installed, or if it the command does not support it, the
			-- remaining finders will be attempted in the original order.
			finder = "telescope.nvim",
		},
		config = function(_, opts)
			require("obsidian").setup(opts)

			-- Optional, override the 'gf' keymap to utilize Obsidian's search functionality.
			-- see also: 'follow_url_func' config option below.
			vim.keymap.set("n", "gf", function()
				if require("obsidian").util.cursor_on_markdown_link() then
					return "<cmd>ObsidianFollowLink<CR>"
				else
					return "gf"
				end
			end, { noremap = false, expr = true })
		end,
	}
}

-- Initialize lazy.nvim
require("lazy").setup(plugins, opts)
