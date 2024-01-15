function SetCatppuccinTheme()
	require("catppuccin").setup({
		flavour = "mocha", -- latte, frappe, macchiato, mocha
		background = {
			-- :h background
			light = "latte",
			dark = "mocha",
		},
		transparent_background = false,
		show_end_of_buffer = false, -- show the '~' characters after the end of buffers
		term_colors = false,
		dim_inactive = {
			enabled = false,
			shade = "dark",
			percentage = 0.15,
		},
		no_italic = false, -- Force no italic
		no_bold = false, -- Force no bold
		styles = {
			comments = { "italic" },
			conditionals = { "italic" },
			loops = {},
			functions = {},
			keywords = {},
			strings = {},
			variables = {},
			numbers = {},
			booleans = {},
			properties = {},
			types = {},
			operators = {},
		},
		color_overrides = {},
		custom_highlights = {},
		integrations = {
			cmp = true,
			gitsigns = true,
			nvimtree = true,
			telescope = true,
			notify = false,
			mini = false,
			-- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
		},
	})

	local transparent = require("transparent")
	transparent.setup({
		groups = { -- table: default groups
			'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
			'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
			'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
			'SignColumn', 'CursorLineNr', 'EndOfBuffer',
		},
		extra_groups = { 'NvimTreeNormal', 'NvimTreeStatuslineNc' }, -- table: additional groups that should be cleared
		exclude_groups = {},                                       -- table: groups you don't want to clear
	})
end

function SetKanagawaTheme()
	require('kanagawa').setup({
		compile = false, -- enable compiling the colorscheme
		undercurl = true, -- enable undercurls
		commentStyle = { italic = true },
		functionStyle = {},
		keywordStyle = { italic = true },
		statementStyle = { bold = true },
		typeStyle = {},
		transparent = false, -- do not set background color
		dimInactive = false, -- dim inactive window `:h hl-NormalNC`
		terminalColors = true, -- define vim.g.terminal_color_{0,17}
		colors = {
			-- add/modify theme and palette colors
			palette = {},
			theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
		},
		overrides = function(colors) -- add/modify highlights
			return {}
		end,
		theme = "wave", -- Load "wave" theme when 'background' option is not set
		background = {
			-- map the value of 'background' option to a theme
			dark = "wave", -- try "dragon" !
			light = "lotus"
		},
	})
end

local default_theme = "catppuccin"

function ColorMyPencils(color)
	color = color or default_theme
	vim.cmd.colorscheme(color)
end

if vim.g.vscode then
else
	SetKanagawaTheme()
	ColorMyPencils("kanagawa")
end
