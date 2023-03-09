local mark = require("harpoon.mark")
local ui = require("harpoon.ui")
local wk = require("which-key")

local function t(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
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
								["s"] = { ":PackerSync<CR>", "Sync" },
						},
						g = { vim.cmd.Git, "Git fugitive" },
						e = { ":NvimTreeToggle<CR>", "Toggle tree" },
						l = {
								name = "Programming Languages",
								c = {
										name = "C++",
										s = { ":lua SetCompileVars()<CR>", "Sets the compiler variables" },
										t = { ":lua RunCompiler()<CR>", "Executes the compiler" }
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
						[","] = { function() RepeteableCommand(":BufferLineCyclePrev<CR>") end, "Previous" },
						["1"] = { function() RepeteableCommand(":BufferLineGoToBuffer 1<CR>") end, "Go to buffer 1" },
						["2"] = { function() RepeteableCommand(":BufferLineGoToBuffer 2<CR>") end, "Go to buffer 2" },
						["3"] = { function() RepeteableCommand(":BufferLineGoToBuffer 3<CR>") end, "Go to buffer 3" },
						["4"] = { function() RepeteableCommand(":BufferLineGoToBuffer 4<CR>") end, "Go to buffer 4" },
						["5"] = { function() RepeteableCommand(":BufferLineGoToBuffer 5<CR>") end, "Go to buffer 5" },
						["6"] = { function() RepeteableCommand(":BufferLineGoToBuffer 6<CR>") end, "Go to buffer 6" },
						["7"] = { function() RepeteableCommand(":BufferLineGoToBuffer 7<CR>") end, "Go to buffer 7" },
						["8"] = { function() RepeteableCommand(":BufferLineGoToBuffer 8<CR>") end, "Go to buffer 8" },
						["9"] = { function() RepeteableCommand(":BufferLineGoToBuffer 9<CR>") end, "Go to buffer 9" },
						[";"] = { function() RepeteableCommand(":BufferLineCycleNext<CR>") end, "Next" },
						["="] = { function() RepeteableCommand(":BufferLineSortByTabs<CR>") end, "Sort by tabs" },
						a = { ":wa<CR>", "Save all" },
						q = { ":wq<CR>", "Save and Quit" },
						-- c = { function() RepeteableCommand(":BufferLineClose<CR>") end, "Close" },
						ch = { function() RepeteableCommand(":BufferLineCloseLeft<CR>") end, "Close left" },
						cl = { function() RepeteableCommand(":BufferLineCloseRight<CR>") end, "Close right" },
						e = { ":NvimTreeFocus<CR>", "Focus tree" },
						h = { function() RepeteableBinding("<C-w>h") end, "Move to window on the left" },
						j = { function() RepeteableBinding("<C-w>j") end, "Move to window below" },
						k = { function() RepeteableBinding("<C-w>k") end, "Move to window above" },
						l = { function() RepeteableBinding("<C-w>l") end, "Move to window on the right" },
						p = { function() RepeteableCommand(":BufferLineTogglePin<CR>") end, "Pin" },
						s = { function() RepeteableCommand(":split<CR>") end, "Split window horizontally" },
						v = { function() RepeteableCommand(":vsplit<CR>") end, "Split window vertically" },
						w = { function() RepeteableCommand(":BufferLinePick<CR>") end, "Pick" },
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
				["e"] = {
						name = "Trouble.nvim",
						l = { function() RepeteableCommand(":TroubleToggle<CR>") end, "Toggle quickfix list" }
				},
		},
		["<C-Up>"] = { function() RepeteableCommand(":resize -2<CR>") end, "Increase window height" },
		["<C-Down>"] = { function() RepeteableCommand(":resize +2<CR>") end, "Decrease window height" },
		["<C-Right>"] = { function() RepeteableCommand(":vertical resize -2<CR>") end, "Decrease window width" },
		["<C-Left>"] = { function() RepeteableCommand(":vertical resize +2<CR>") end, "Increase window width" },
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
				e = { function() RepeteableCommand(":NvimTreeToggle<CR>") end, "Toggle tree" },
				q = { function() RepeteableCommand(":q!<CR>") end, "Quit" },
		},
		["Z"] = {
				["Q"] = { function() RepeteableCommand(":q!<CR>") end, "Force quit" },
				["Z"] = { ":wq<CR>", "Save and Quit" },
				e = { function() RepeteableCommand(":NvimTreeToggle<CR>") end, "Toggle tree" },
				q = { ":q!<CR>", "Quit" },
		},
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
		["jk"] = { "<ESC>", "Exit insert mode (jk)" }
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
		["H"] = { "^", "Move to beginning of line" },
		["L"] = { "$", "Move to end of line" }
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
		["<C-h>"] = { "<C-\\><C-N><C-w>h", "Move left in terminal mode" },
		["<C-j>"] = { "<C-\\><C-N><C-w>j", "Move down in terminal mode" },
		["<C-k>"] = { "<C-\\><C-N><C-w>k", "Move up in terminal mode" },
		["<C-l>"] = { "<C-\\><C-N><C-w>l", "Move right in terminal mode" },
		["<Esc>"] = { "<C-\\><C-n>", "Exit terminal mode" },
		["<leader>t"] = { "<C-\\><C-n>:ToggleTerm<CR>", "Toggle terminal" }
}, t_opts)

-- vim.api.nvim_set_keymap('n', '<Plug>MyWonderfulMap', ":lua require'My_module'.my_function()<CR>", {noremap=true})

-- local function t(str)
--     return vim.api.nvim_replace_termcodes(str, true, true, true)
-- end
