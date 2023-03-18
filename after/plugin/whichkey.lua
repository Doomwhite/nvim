local mark = require("harpoon.mark")
local ui = require("harpoon.ui")
local wk = require("which-key")

-- Keybinding
function KB(action, description, isCommand, isRepeatable)
	if isRepeatable then
		if isCommand then
			return { function() RepeteableCommand(action) end, description }
		else
			return { function() RepeteableBinding(action) end, description }
		end
	else
		return { action, description }
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
		mode = "n", -- NORMAL mode
		prefix = "",
		buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
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
								["s"] = KB(":PackerSync<CR>", "Sync", false, false),
						},
						g = { vim.cmd.Git, "Git fugitive" },
						e = KB(":NvimTreeToggle<CR>", "Toggle tree", false, false),
						l = {
								name = "Programming Languages",
								c = {
										name = "C++",
										s = KB(":lua SetCompileVars()<CR>", "Sets the compiler variables", false, false),
										S = KB(":lua SetMakeVar()<CR>", "Sets the make variable(without extension)", false, false),
										t = KB(":lua RunCompiler()<CR>", "Executes the compiler", false, false),
										T = KB(":lua RunCompilerWithCPP11()<CR>", "Executes the compiler with the C++ standard", false, false),
										m = KB(":lua RunMakeAndExecute()<CR>", "Makes the file", false, false),
								}
						}
				},
				["."] = {
						name = "Current directory",
						d = KB(":echo expand('%p:h:')<CR>", "Prints the current buffer directory", false, false),
						s = KB(":source<CR>", "Sources the current buffer", false, false),
				},
				q = KB(":q<CR>", "Quit", false, false),
				["Q"] = KB(":q!<CR>", "Force quit", false, false),
				t = KB(":ToggleTerm<CR>i", "Toggle terminal", false, false),
				f = {
						name = "Find",
						f = KB(":Telescope find_files<CR>", "Find files", false, false),
						t = KB(":Telescope live_grep<CR>", "Find text", false, false),
				},
				w = {
						name = "Window/Buffer",
						[","] = KB(":BufferLineCyclePrev<CR>", "Previous", true, true),
						["1"] = KB(":BufferLineGoToBuffer 1<CR>", "Go to buffer 1", true, true),
						["2"] = KB(":BufferLineGoToBuffer 2<CR>", "Go to buffer 2", true, true),
						["3"] = KB(":BufferLineGoToBuffer 3<CR>", "Go to buffer 3", true, true),
						["4"] = KB(":BufferLineGoToBuffer 4<CR>", "Go to buffer 4", true, true),
						["5"] = KB(":BufferLineGoToBuffer 5<CR>", "Go to buffer 5", true, true),
						["6"] = KB(":BufferLineGoToBuffer 6<CR>", "Go to buffer 6", true, true),
						["7"] = KB(":BufferLineGoToBuffer 7<CR>", "Go to buffer 7", true, true),
						["8"] = KB(":BufferLineGoToBuffer 8<CR>", "Go to buffer 8", true, true),
						["9"] = KB(":BufferLineGoToBuffer 9<CR>", "Go to buffer 9", true, true),
						[";"] = KB(":BufferLineCycleNext<CR>", "Next", true, true),
						["="] = KB(":BufferLineSortByTabs<CR>", "Sort by tabs", true),
						a = KB(":wa<CR>", "Save all", false, false),
						q = KB(":wq<CR>", "Save and Quit", false, false),
						-- c = { function() RepeteableCommand(":BufferLineClose<CR>") end, "Close" },
						ch = KB(":BufferLineCloseLeft<CR>", "Close left", true, true),
						cl = KB(":BufferLineCloseRight<CR>", "Close right", true, true),
						e = KB(":NvimTreeFocus<CR>", "Focus tree", true, true),
						h = KB("<C-w>h", "Move to window on the left", false, true),
						j = KB("<C-w>j", "Move to window below", false, true),
						k = KB("<C-w>k", "Move to window above", false, true),
						l = KB("<C-w>l", "Move to window on the right", false, true),
						p = KB(":BufferLineTogglePin<CR>", "Pin", true, true),
						s = KB(":split<CR>", "Split window horizontally", true, true),
						v = KB(":vsplit<CR>", "Split window vertically", true, true),
						w = KB(":BufferLinePick<CR>", "Pick", true, true),
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
						p = KB(":lua require('refactoring').debug.printf({ normal = true })<CR>", "Prints under the cursor", false, false),
						v = KB(":lua require('refactoring').debug.print_var({ normal = true })<CR>", "Print var under the cursor", false, false),
						c = KB(":lua require('refactoring').debug.print_var({})<CR>", "Clears the prints", false, false),
				},
				o = {
						name = "Refactoring",
						i = KB("<Cmd>lua require('refactoring').refactor('Inline Variable')<CR>", "Inline variable", false, false),
						e = KB("<Cmd>lua require('refactoring').refactor('Extract Block')<CR>", "Extract block", false, false),
						f = KB("<Cmd>lua require('refactoring').refactor('Extract Block To File')<CR>", "Extract block to file", false, false),
				},
				e = {
						name = "Trouble.nvim",
						l = KB(":TroubleToggle<CR>", "Toggle quickfix list", true, true)
				},
		},
		["<C-Up>"] = KB(":resize -2<CR>", "Increase window height", true, true),
		["<C-Down>"] = KB(":resize +2<CR>", "Decrease window height", true, true),
		["<C-Right>"] = KB(":vertical resize -2<CR>", "Decrease window width", true, true),
		["<C-Left>"] = KB(":vertical resize +2<CR>", "Increase window width", true, true, true),
		-- ["<C-Up>"] = { ":resize +2<CR>", "Increase window height" },
		-- ["<C-Down>"] = { ":resize -2<CR>", "Decrease window height" },
		["H"] = KB("^", "Move to beginning of line", false, false),
		["L"] = KB("$", "Move to end of line", false, false),
		[";"] = {
				name = "Unimpaired",
				[";"] = KB(";", ";", false, false)
		},
		[","] = {
				name = "Unimpaired",
				[","] = KB(",", ",", false, false)
		},
		z = {
				["Q"] = KB(":q!<CR>", "Force quit", true, false),
				["Z"] = KB(":wq<CR>", "Save and Quit", true, false),
				e = KB(":NvimTreeToggle<CR>", "Toggle tree", true, true),
				q = KB(":q!<CR>", "Quit", true, true),
		},
		["Z"] = {
				["Q"] = { function() RepeteableCommand(":q!<CR>") end, "Force quit" },
				["Z"] = KB(":wq<CR>", "Save and Quit", true, false),
				e = { function() RepeteableCommand(":NvimTreeToggle<CR>") end, "Toggle tree" },
				q = KB(":q!<CR>", "Quit", false, false),
		},
		["J"] = KB("}", "}", false, false),
		["K"] = KB("{", "{", false, false)
		,
		-- ["="] = { ":CocCommand prettier.forceFormatDocument<CR>", "Format document" }
}, n_opts)

local i_opts = {
		mode = "i", -- INSERT mode
		prefix = "",
		buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
		silent = true, -- use `silent` when creating keymaps
		noremap = true, -- use `noremap` when creating keymaps
		nowait = false, -- use `nowait` when creating keymaps
}

wk.register({
		["jk"] = KB("<ESC>", "Exit insert mode (jk)", false, false)
}, i_opts)

local v_opts = {
		mode = "v", -- VISUAL mode
		prefix = "",
		buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
		silent = true, -- use `silent` when creating keymaps
		noremap = true, -- use `noremap` when creating keymaps
		nowait = false, -- use `nowait` when creating keymaps
}


wk.register({
		g = {
				d = {
						name = "Debugging",
						p = KB(":lua require('refactoring').debug.printf()<CR>", "Prints selected text", false, false),
						v = KB(":lua require('refactoring').debug.print_var()<CR>", "Print var selected text", false, false),
				},
				o = KB(":lua require('refactoring').select_refactor()<CR>", "Refactoring", false, false),
		},
		["H"] = KB("^", "Move to beginning of line", false, false),
		["L"] = KB("$", "Move to end of line", false, false),
		["J"] = KB("}", "}", false, false),
		["K"] = KB("{", "{", false, false)
}, v_opts)

local x_opts = {
		mode = "x", -- VISUAL LINE  mode
		prefix = "",
		buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
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
		mode = "t", -- TERMINAL mode
		prefix = "",
		buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
		silent = true, -- use `silent` when creating keymaps
		noremap = true, -- use `noremap` when creating keymaps
		nowait = false, -- use `nowait` when creating keymaps
}

wk.register({
		["<C-h>"] = KB("<C-\\><C-N><C-w>h", "Move left in terminal mode", false, false),
		["<C-j>"] = KB("<C-\\><C-N><C-w>j", "Move down in terminal mode", false, false),
		["<C-k>"] = KB("<C-\\><C-N><C-w>k", "Move up in terminal mode", false, false),
		["<C-l>"] = KB("<C-\\><C-N><C-w>l", "Move right in terminal mode", false, false),
		["<Esc>"] = KB("<C-\\><C-n>", "Exit terminal mode", false, false),
		["<leader>t"] = KB("<C-\\><C-n>:ToggleTerm<CR>", "Toggle terminal", false, false)
}, t_opts)

local c_opts = {
		mode = "c", -- COMMAND mode
		prefix = "",
		buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
		silent = true, -- use `silent` when creating keymaps
		noremap = true, -- use `noremap` when creating keymaps
		nowait = false, -- use `nowait` when creating keymaps
}

wk.register({
		["<C-v>"] = KB("<C-r>*", "Paste", false, false),
}, c_opts)


-- vim.api.nvim_set_keymap('n', '<Plug>MyWonderfulMap', ":lua require'My_module'.my_function()<CR>", {noremap=true})

-- local function t(str)
--     return vim.api.nvim_replace_termcodes(str, true, true, true)
-- end
