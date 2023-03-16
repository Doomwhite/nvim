local mark = require("harpoon.mark")
local ui = require("harpoon.ui")
local wk = require("which-key")

-- RepeateableKeybinding
function RK(action, description, isCommand)
	if isCommand then
		return { function() RepeteableCommand(action) end, description }
	else
		return { function() RepeteableBinding(action) end, description }
	end
end

function RepeteableBinding(action)
	local actionReplaced = vim.api.nvim_replace_termcodes(action, true, true, true)
	vim.api.nvim_input(actionReplaced)
	vim.fn['repeat#set'](actionReplaced, vim.v.count) -- the vim-repeat magic
end

function RepeteableCommand(action)
	local actionReplaced = vim.api.nvim_replace_termcodes(action, true, true, true)
	vim.cmd(RemoveTermCodes(action))
	vim.fn['repeat#set'](actionReplaced, vim.v.count) -- the vim-repeat magic
end

function RemoveTermCodes(str)
	local tempStr = str
	tempStr = string.gsub(tempStr, "<CR>", "")
	tempStr = string.gsub(tempStr, "<Cr>", "")
	tempStr = string.gsub(tempStr, "<Esc>", "")
	tempStr = string.gsub(tempStr, "<Tab>", "")
	tempStr = string.gsub(tempStr, "<C%-[a-zA-Z]>", "")
	return tempStr
end

wk.setup()

local n_opts = {
	mode = "n",    -- NORMAL mode
	prefix = "",
	buffer = nil,  -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = false, -- use `nowait` when creating keymaps
}
wk.register({
	["<leader>"] = {
		name = "Leader layer",
		["<leader>"] = {
			name = "Leader second layer",
			["p"] = {
				name = "Packer",
				["s"] = { ":PackerSync<CR>", "Sync" },
			},
			g = { vim.cmd.Git, "Git fugitive" },
			e = { ":NvimTreeToggle<CR>", "Toggle tree" },
			l = {
				name = "Programming Languages",
				c = {
					name = "C++",
					s = { ":lua SetCompileVars()<CR>", "Sets the compiler variables" },
					S = { ":lua SetMakeVar()<CR>", "Sets the make variable(without extension)" },
					t = { ":lua RunCompiler()<CR>", "Executes the compiler" },
					T = { ":lua RunCompilerWithCPP11()<CR>", "Executes the compiler with the C++ standard" },
					m = { ":lua RunMakeAndExecute()<CR>", "Makes the file" },
				}
			}
		},
		["."] = {
			name = "Current directory",
			d = { ":echo expand('%p:h:')<CR>", "Prints the current buffer directory" },
			s = { ":source<CR>", "Sources the current buffer" },
		},
		q = { ":q<CR>", "Quit" },
		["Q"] = { ":q!<CR>", "Force quit" },
		t = { ":ToggleTerm<CR>i", "Toggle terminal" },
		f = {
			name = "Find",
			f = { ":Telescope find_files<CR>", "Find files" },
			t = { ":Telescope live_grep<CR>", "Find text" },
		},
		w = {
			name = "Window/Buffer",
			[","] = RK(":BufferLineCyclePrev<CR>", "Previous", true),
			["1"] = RK(":BufferLineGoToBuffer 1<CR>", "Go to buffer 1", true),
			["2"] = RK(":BufferLineGoToBuffer 2<CR>", "Go to buffer 2", true),
			["3"] = RK(":BufferLineGoToBuffer 3<CR>", "Go to buffer 3", true),
			["4"] = RK(":BufferLineGoToBuffer 4<CR>", "Go to buffer 4", true),
			["5"] = RK(":BufferLineGoToBuffer 5<CR>", "Go to buffer 5", true),
			["6"] = RK(":BufferLineGoToBuffer 6<CR>", "Go to buffer 6", true),
			["7"] = RK(":BufferLineGoToBuffer 7<CR>", "Go to buffer 7", true),
			["8"] = RK(":BufferLineGoToBuffer 8<CR>", "Go to buffer 8", true),
			["9"] = RK(":BufferLineGoToBuffer 9<CR>", "Go to buffer 9", true),
			[";"] = RK(":BufferLineCycleNext<CR>", "Next", true),
			["="] = RK(":BufferLineSortByTabs<CR>", "Sort by tabs", true),
			a = { ":wa<CR>", "Save all" },
			q = { ":wq<CR>", "Save and Quit" },
			-- c = { function() RepeteableCommand(":BufferLineClose<CR>") end, "Close" },
			ch = RK(":BufferLineCloseLeft<CR>", "Close left", true),
			cl = RK(":BufferLineCloseRight<CR>", "Close right", true),
			e = RK(":NvimTreeFocus<CR>", "Focus tree", true),
			h = RK("<C-w>h", "Move to window on the left", false),
			j = RK("<C-w>j", "Move to window below", false),
			k = RK("<C-w>k", "Move to window above", false),
			l = RK("<C-w>l", "Move to window on the right", false),
			p = RK(":BufferLineTogglePin<CR>", "Pin", true),
			s = RK(":split<CR>", "Split window horizontally", true),
			v = RK(":vsplit<CR>", "Split window vertically", true),
			w = RK(":BufferLinePick<CR>", "Pick", true),
		},
		h = {
			name = "Harpoon",
			a = { mark.add_file, "Adds files" },
			e = { mark.add_file, "Toggles menu" },
			-- a = { function() ui.nav_file(1) end, "Go to file 1" },
			s = { function() ui.nav_file(2) end, "Go to file 2" },
			d = { function() ui.nav_file(3) end, "Go to file 3" },
			f = { function() ui.nav_file(4) end, "Go to file 4" }
		},
	},
	g = {
		d = {
			name = "Debugging",
			p = { ":lua require('refactoring').debug.printf({ normal = true })<CR>", "Prints under the cursor" },
			v = { ":lua require('refactoring').debug.print_var({ normal = true })<CR>", "Print var under the cursor" },
			c = { ":lua require('refactoring').debug.print_var({})<CR>", "Clears the prints" },
		},
		o = {
			name = "Refactoring",
			i = { "<Cmd>lua require('refactoring').refactor('Inline Variable')<CR>", "Inline variable" },
			e = { "<Cmd>lua require('refactoring').refactor('Extract Block')<CR>", "Extract block" },
			f = { "<Cmd>lua require('refactoring').refactor('Extract Block To File')<CR>", "Extract block to file" },
		},
		e = {
			name = "Trouble.nvim",
			l = RK(":TroubleToggle<CR>", "Toggle quickfix list", true)
		},
	},
	["<C-Up>"] = RK(":resize -2<CR>", "Increase window height", true),
	["<C-Down>"] = RK(":resize +2<CR>", "Decrease window height", true),
	["<C-Right>"] = RK(":vertical resize -2<CR>", "Decrease window width", true),
	["<C-Left>"] = RK(":vertical resize +2<CR>", "Increase window width", true),
	-- ["<C-Up>"] = { ":resize +2<CR>", "Increase window height" },
	-- ["<C-Down>"] = { ":resize -2<CR>", "Decrease window height" },
	["H"] = { "^", "Move to beginning of line" },
	["L"] = { "$", "Move to end of line" },
	[";"] = {
		[";"] = { ";", ";" }
	},
	[","] = {
		[","] = { ",", "," }
	},
	z = {
		["Q"] = { ":q!<CR>", "Force quit" },
		["Z"] = { ":wq<CR>", "Save and Quit" },
		e = RK(":NvimTreeToggle<CR>", "Toggle tree", true),
		q = RK(":q!<CR>", "Quit", true),
	},
	["Z"] = {
		["Q"] = { function() RepeteableCommand(":q!<CR>") end, "Force quit" },
		["Z"] = { ":wq<CR>", "Save and Quit" },
		e = { function() RepeteableCommand(":NvimTreeToggle<CR>") end, "Toggle tree" },
		q = { ":q!<CR>", "Quit" },
	},
	["J"] = { "}", "}" },
	["K"] = { "{", "{" },
	-- ["="] = { ":CocCommand prettier.forceFormatDocument<CR>", "Format document" }
}, n_opts)

local i_opts = {
	mode = "i",    -- INSERT mode
	prefix = "",
	buffer = nil,  -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = false, -- use `nowait` when creating keymaps
}

wk.register({
	["jk"] = { "<ESC>", "Exit insert mode (jk)" }
}, i_opts)

local v_opts = {
	mode = "v",    -- VISUAL mode
	prefix = "",
	buffer = nil,  -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = false, -- use `nowait` when creating keymaps
}


wk.register({
	g = {
		d = {
			name = "Debugging",
			p = { ":lua require('refactoring').debug.printf()<CR>", "Prints selected text" },
			v = { ":lua require('refactoring').debug.print_var()<CR>", "Print var selected text" },
		},
		o = {
			":lua require('refactoring').select_refactor()<CR>", "Refactoring"
		},
	},
	["H"] = { "^", "Move to beginning of line" },
	["L"] = { "$", "Move to end of line" }
}, v_opts)

local x_opts = {
	mode = "x",    -- VISUAL LINE  mode
	prefix = "",
	buffer = nil,  -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = false, -- use `nowait` when creating keymaps
}

wk.register({
	-- ["J"] = { ":m '>+1<CR>gv-gv", "Move selected text down" },
	-- ["K"] = { ":m '<-2<CR>gv-gv", "Move selected text up" },
	-- ["<A-j>"] = { ":m '>+1<CR>gv-gv", "Move selected text down" },
	-- ["<A-k>"] = { ":m '<-2<CR>gv-gv", "Move selected text up" }
}, x_opts)

local t_opts = {
	mode = "t",    -- TERMINAL mode
	prefix = "",
	buffer = nil,  -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = false, -- use `nowait` when creating keymaps
}

wk.register({
	["<C-h>"] = { "<C-\\><C-N><C-w>h", "Move left in terminal mode" },
	["<C-j>"] = { "<C-\\><C-N><C-w>j", "Move down in terminal mode" },
	["<C-k>"] = { "<C-\\><C-N><C-w>k", "Move up in terminal mode" },
	["<C-l>"] = { "<C-\\><C-N><C-w>l", "Move right in terminal mode" },
	["<Esc>"] = { "<C-\\><C-n>", "Exit terminal mode" },
	["<leader>t"] = { "<C-\\><C-n>:ToggleTerm<CR>", "Toggle terminal" }
}, t_opts)

local c_opts = {
	mode = "c",    -- COMMAND mode
	prefix = "",
	buffer = nil,  -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = false, -- use `nowait` when creating keymaps
}

wk.register({
	["<C-v>"] = { "<C-r>*", "Paste" },
}, c_opts)


-- vim.api.nvim_set_keymap('n', '<Plug>MyWonderfulMap', ":lua require'My_module'.my_function()<CR>", {noremap=true})

-- local function t(str)
--     return vim.api.nvim_replace_termcodes(str, true, true, true)
-- end
