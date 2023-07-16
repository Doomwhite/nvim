local mark = require("harpoon.mark")
local ui = require("harpoon.ui")
local wk = require("which-key")

local wkutils = require("doomwhite.functions.which-key-utils")
local KB = wkutils.KB

wk.setup()

function setup_normal()
	-- Normal mode options
	local normal_options = {
		mode = "n",   -- NORMAL mode
		prefix = "",
		buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
		silent = true, -- use `silent` when creating keymaps
		noremap = true, -- use `noremap` when creating keymaps
		nowait = true, -- use `nowait` when creating keymaps
	}

	-- Normal mode keybindings
	wk.register({
		["<leader>"] = { name = "Leader layer" },
		["<leader>q"] = KB(":q<CR>", "Quit", true, false, false),
		["<leader>Q"] = KB(":q!<CR>", "Force quit", true, false, false),
		["<leader>y"] = KB("\"+y", "Quit", false, false, false),
		["<leader>p"] = KB("\"+p", "Quit", false, false, false),
		["<leader>u"] = KB(":UndotreeToggle<CR>", "Undo tree history toggle", true, false, false),

		["<leader><leader>"] = { name = "Leader second layer" },
		["<leader><leader>g"] = { vim.cmd.Git, "Git fugitive" },

		["<leader><leader>p"] = { name = "Packer" },
		["<leader><leader>ps"] = KB(":PackerSync<CR>", "Sync", true, false, false),

		["<leader><leader>l"] = { name = "Programming Languages" },

		["<leader><leader>lc"] = { name = "C++" },
		["<leader><leader>lcs"] = KB(":lua SetCompileVars()<CR>", "Sets the compiler variables", true, false, false),
		["<leader><leader>lcS"] = KB(":lua SetMakeVar()<CR>", "Sets the make variable(without extension)", true, false, false),
		["<leader><leader>lct"] = KB(":lua RunCompiler()<CR>", "Executes the compiler", true, false, false),
		["<leader><leader>lcT"] = KB(":lua RunCompilerWithCPP11()<CR>", "Executes the compiler with the C++ standard", true, false, false),
		["<leader><leader>lcm"] = KB(":lua RunMakeAndExecute()<CR>", "Makes the file", true, false, false),

		["<leader>."] = { name = "Current directory" },
		["<leader>.d"] = KB(":echo expand('%p:h:')<CR>", "Prints the current buffer directory", true, false, false),
		["<leader>.s"] = KB(":source<CR>", "Sources the current buffer", false, false, false),
		["<leader>.r"] = KB(":lua set_scroll_bindings()<CR>", "Sets the scrolling settings by window size", false, false, false),
		["<leader>.n"] = KB(":NoNeckPain<CR>", "Toggle NoNeckPain", true, false, false),
		["<leader>.l"] = KB(":lua LogSelectedText()<CR>", "LogSelectedText", false, false, false),
		["<leader>.p"] = KB(":lua PrintSelectedText()<CR>", "PrintSelectedText", false, false, false),

		["<leader>f"] = { name = "Find" },
		["<leader>fs"] = KB(":w<CR>", "Save file", false, false, false),
		["<leader>fS"] = KB(":wa<CR>", "Save all files", false, false, false),
		["<leader>ff"] = KB(":Telescope find_files<CR>", "Find files", false, false, false),
		["<leader>ft"] = KB(":Telescope live_grep<CR>", "Find text", false, false, false),
		["<leader>fk"] = KB(":Telescope keymaps<CR>", "Find keymaps", false, false, false),

		["<leader>w"] = { name = "Window/Buffer" },
		["<leader>w1"] = KB("<Plug>(cokeline-focus-1)", "Go to buffer 1", false, false, false),
		["<leader>w2"] = KB("<Plug>(cokeline-focus-2)", "Go to buffer 1", false, false, false),
		["<leader>w3"] = KB("<Plug>(cokeline-focus-3)", "Go to buffer 1", false, false, false),
		["<leader>w4"] = KB("<Plug>(cokeline-focus-4)", "Go to buffer 1", false, false, false),
		["<leader>w5"] = KB("<Plug>(cokeline-focus-5)", "Go to buffer 1", false, false, false),
		["<leader>w6"] = KB("<Plug>(cokeline-focus-6)", "Go to buffer 1", false, false, false),
		["<leader>w7"] = KB("<Plug>(cokeline-focus-7)", "Go to buffer 1", false, false, false),
		["<leader>w8"] = KB("<Plug>(cokeline-focus-8)", "Go to buffer 1", false, false, false),
		["<leader>w9"] = KB("<Plug>(cokeline-focus-9)", "Go to buffer 1", false, false, false),
		["<leader>wh"] = KB("<C-w>h", "Move to window on the left", false, true, true),
		["<leader>wj"] = KB("<C-w>j", "Move to window below", false, true, true),
		["<leader>wk"] = KB("<C-w>k", "Move to window above", false, true, true),
		["<leader>wl"] = KB("<C-w>l", "Move to window on the right", false, true, true),
		["<leader>ws"] = KB(":split<CR>", "Split window horizontally", true, true, false),
		["<leader>wv"] = KB(":vsplit<CR>", "Split window vertically", true, true, false),
		["<leader>w<C-Up>"] = KB(":resize +2<CR>", "Increase window height", true, true, true),
		["<leader>w<C-Down>"] = KB(":resize -2<CR>", "Decrease window height", true, true, true),
		["<leader>w<C-Right>"] = KB(":vertical resize +2<CR>", "Decrease window width", true, true, true),
		["<leader>w<C-Left>"] = KB(":vertical resize -2<CR>", "Increase window width", true, true, true),

		["<leader>h"] = { name = "Harpoon", },
		["<leader>ha"] = { mark.add_file, "Adds files" },
		["<leader>he"] = { mark.add_file, "Toggles menu" },
		["<leader>hs"] = { function() ui.nav_file(2) end, "Go to file 2" },
		["<leader>hd"] = { function() ui.nav_file(3) end, "Go to file 3" },
		["<leader>hf"] = { function() ui.nav_file(4) end, "Go to file 4" },


		g = { name = "g" },

		["gD"] = { name = "Debugging" },
		["gDp"] = KB(":lua require('refactoring').debug.printf({ normal = true })<CR>", "Prints under the cursor", true, false,
			false),
		["gDv"] = KB(":lua require('refactoring').debug.print_var({ normal = true })<CR>", "Print var under the cursor", true,
			false, false),
		["gDc"] = KB(":lua require('refactoring').debug.print_var({})<CR>", "Clears the prints", true, false, false),

		["ge"] = { name = "Trouble.nvim" },
		["gel"] = KB(":TroubleToggle<CR>", "Toggle quickfix list", true, true, false),


		["<C-t>"] = KB(":ToggleTerm<CR>", "Toggle terminal", false, false, false),
		["H"] = KB("^", "Move to beginning of line", false, false, true),
		["L"] = KB("$", "Move to end of line", false, false, true),


		[";"] = { name = "Unimpaired" },
		[";1"] = KB("<Plug>(cokeline-focus-1)", "Go to buffer 1", false, false, false),
		[";2"] = KB("<Plug>(cokeline-focus-2)", "Go to buffer 1", false, false, false),
		[";3"] = KB("<Plug>(cokeline-focus-3)", "Go to buffer 1", false, false, false),
		[";4"] = KB("<Plug>(cokeline-focus-4)", "Go to buffer 1", false, false, false),
		[";5"] = KB("<Plug>(cokeline-focus-5)", "Go to buffer 1", false, false, false),
		[";6"] = KB("<Plug>(cokeline-focus-6)", "Go to buffer 1", false, false, false),
		[";7"] = KB("<Plug>(cokeline-focus-7)", "Go to buffer 1", false, false, false),
		[";8"] = KB("<Plug>(cokeline-focus-8)", "Go to buffer 1", false, false, false),
		[";9"] = KB("<Plug>(cokeline-focus-9)", "Go to buffer 1", false, false, false),
		[";;"] = KB(";", ";", false, false, false),
		[";E"] = KB(":NvimTreeToggle<CR>", "Toggle tree", true, false, false),
		[";Q"] = KB(":bdelete!<CR>", "Force delete buffer", true, true, false),
		[";e"] = KB(":NvimTreeFocus<CR>", "Focus tree", true, false, false),
		[";q"] = KB(":bdelete<CR>", "Delete buffer", true, true, false),
		[";z"] = KB(":qw!<CR>", "Quit", true, true, false),


		[","] = { name = "Unimpaired" },
		[",,"] = KB(",", ",", false, false, false),


		["zQ"] = KB(":q!<CR>", "Force quit", true, true, false),
		["zZ"] = KB(":wq<CR>", "Save and Quit", true, true, false),
		["ze"] = KB(":NvimTreeToggle<CR>", "Toggle tree", true, true, false),
		["zq"] = KB(":q!<CR>", "Quit", true, true, false),


		["ZZ"] = KB(":wq<CR>", "Save and Quit", true, false, false),
		["Zq"] = KB(":q!<CR>", "Force Quit", false, false, false),


		["J"] = KB("}", "}", false, false, false),
		["K"] = KB("{", "{", false, false, false),
		-- ["="] = { ":CocCommand prettier.forceFormatDocument<CR>", "Format document" }
	}, normal_options)
end

function setup_insert()
	-- Insert mode options
	local insert_options = {
		mode = "i",   -- INSERT mode
		prefix = "",
		buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
		silent = true, -- use `silent` when creating keymaps
		noremap = true, -- use `noremap` when creating keymaps
		nowait = true, -- use `nowait` when creating keymaps
	}

	-- Insert mode keybindings
	wk.register({
		["jk"] = KB("<ESC>", "Exit insert mode (jk)", false, false, false)
	}, insert_options)
end

function setup_visual()
	-- Visual mode options
	local visual_options = {
		mode = "v",   -- VISUAL mode
		prefix = "",
		buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
		silent = true, -- use `silent` when creating keymaps
		noremap = true, -- use `noremap` when creating keymaps
		nowait = true, -- use `nowait` when creating keymaps
	}

	-- Visual model keybindings
	wk.register({
		-- g = {
		-- d = {
		-- 	name = "Debugging",
		-- 	p = KB(":lua require('refactoring').debug.printf()<CR>", "Prints selected text", false, false, false),
		-- 	v = KB(":lua require('refactoring').debug.print_var()<CR>", "Print var selected text", false, false, false),
		-- },
		-- o = KB(":lua require('refactoring').select_refactor()<CR>", "Refactoring", false, false, false),
		-- },


		["<leader>"] = { name = "Leader layer" },

		["<leader>."] = { name = "Current directory" },
		["<leader>y"] = KB("\"+y", "Quit", false, false, false),
		["<leader>p"] = KB("\"+p", "Quit", false, false, false),
		["<leader>.l"] = KB(":lua LogSelectedText()<CR>", "LogSelectedText", false, false, false),
		["<leader>.p"] = KB(":lua PrintSelectedText()<CR>", "PrintSelectedText", false, false, false),


		["H"] = KB("^", "Move to beginning of line", false, false, false),
		["L"] = KB("$", "Move to end of line", false, false, false),
		["J"] = KB("}", "}", false, false, false),
		["K"] = KB("{", "{", false, false, false)
	}, visual_options)
end

function setup_visual_line()
	-- Visual line mode options
	local visual_line_options = {
		mode = "x",   -- VISUAL LINE  mode
		prefix = "",
		buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
		silent = true, -- use `silent` when creating keymaps
		noremap = true, -- use `noremap` when creating keymaps
		nowait = true, -- use `nowait` when creating keymaps
	}

	-- Visual line keybindings
	-- wk.register({
	-- 	["J"] = { ":m '>+1<CR>gv-gv", "Move selected text down" },
	-- 	["K"] = { ":m '<-2<CR>gv-gv", "Move selected text up" },
	-- 	["<A-j>"] = { ":m '>+1<CR>gv-gv", "Move selected text down" },
	-- 	["<A-k>"] = { ":m '<-2<CR>gv-gv", "Move selected text up" }
	-- }, visual_line_options)
end

function setup_terminal()
	-- Terminal line options

	local terminal_options = {
		mode = "t",   -- TERMINAL mode
		prefix = "",
		buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
		silent = true, -- use `silent` when creating keymaps
		noremap = true, -- use `noremap` when creating keymaps
		nowait = true, -- use `nowait` when creating keymaps
	}

	-- Terminal line keybindings
	wk.register({
		["<C-h>"] = KB("<C-\\><C-N><C-w>h", "Move left in terminal mode", false, false, false),
		["<C-j>"] = KB("<C-\\><C-N><C-w>j", "Move down in terminal mode", false, false, false),
		["<C-k>"] = KB("<C-\\><C-N><C-w>k", "Move up in terminal mode", false, false, false),
		["<C-l>"] = KB("<C-\\><C-N><C-w>l", "Move right in terminal mode", false, false, false),
		["<Esc>"] = KB("<C-\\><C-n>", "Exit terminal mode", false, false, false),
		["<C-t>"] = KB("<C-\\><C-n>:ToggleTerm<CR>", "Toggle terminal", false, false, false)
	}, terminal_options)
end

function setup_command()
	-- Command mode options
	local command_options = {
		mode = "c",   -- COMMAND mode
		prefix = "",
		buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
		silent = true, -- use `silent` when creating keymaps
		noremap = true, -- use `noremap` when creating keymaps
		nowait = true, -- use `nowait` when creating keymaps
	}

	-- Command mode keybindings
	wk.register({
		["<C-v>"] = KB("<C-r>*", "Paste", false, false, false),
	}, command_options)
end

setup_normal()
setup_insert()
setup_visual()
setup_visual_line()
setup_terminal()
setup_command()

-- vim.keymap.set({ 'n', 'v', 'x' }, '<C-u>', "15k")
-- vim.keymap.set({ 'n', 'v', 'x' }, '<C-d>', "15j")

-- vim.api.nvim_set_keymap('n', '<expr> <C-u>', "(vim.api.nvim_win_get_height(0)/4) .. 'k'", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<expr> <C-d>', "(vim.api.nvim_win_get_height(0)/4) .. 'j'", { noremap = true, silent = true })

-- local actionReplaced = vim.api.nvim_replace_termcodes(":nnoremap <expr> <C-u> (winheight(0)/4).'k'", true, true, true)
-- vim.api.nvim_input(actionReplaced)
-- -- vim.fn['repeat#set'](, 0)
-- -- vim.fn['repeat#set'](":nnoremap <expr> <C-d> (winheight(0)/4).'j'", 0)

-- vim.keymap.set({ "n", "v", "x" }, "<C-u>", ":lua scroll_one_quarter('up')<CR>", { silent = true })
-- vim.keymap.set({ "n", "v", "x" }, "<C-d>", ":lua scroll_one_quarter('down')<CR>", { silent = true })

-- vim.api.nvim_set_keymap('n', '<Plug>MyWonderfulMap', ":lua require'My_module'.my_function()<CR>", {noremap=true})
