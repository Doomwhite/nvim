local M = {
	"folke/which-key.nvim",
	lazy = true,
}

function M.config()
	vim.o.timeout = true
	vim.o.timeoutlen = 300

	local mark = require("harpoon.mark")
	local ui = require("harpoon.ui")
	local wk = require("which-key")

	wk.setup {}

	-- Keybinding
	function KB(action, description, isCommand, isRepeatable, usesCount)
		if isRepeatable then
			if isCommand then
				return { function() RepeteableCommand(action, usesCount) end, description }
			else
				return { function() RepeteableBinding(action, usesCount) end, description }
			end
		end
		if usesCount then
			return { vim.v.count1 .. action, description }
		end
		return { action, description }
	end

	function RepeteableBinding(action, usesCount)
		if usesCount then
			local actionWithCount = vim.v.count1 .. action
			local actionReplaced = vim.api.nvim_replace_termcodes(actionWithCount, true, true, true)
			vim.api.nvim_input(actionReplaced)
			vim.fn['repeat#set'](actionReplaced, vim.v.count) -- the vim-repeat magic
		else
			local actionReplaced = vim.api.nvim_replace_termcodes(action, true, true, true)
			vim.api.nvim_input(actionReplaced)
			vim.fn['repeat#set'](actionReplaced, vim.v.count) -- the vim-repeat magic
		end
	end

	function RepeteableCommand(action, usesCount)
		local actionReplaced = vim.api.nvim_replace_termcodes(action, true, true, true)
		vim.cmd(RemoveTermCodes(action))
		if usesCount then
			vim.fn['repeat#set'](actionReplaced, vim.v.count) -- the vim-repeat magic
		else
			vim.fn['repeat#set'](actionReplaced, 0)        -- the vim-repeat magic
		end
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

	function setup_normal()
		-- Normal mode options
		local n_opts = {
			mode = "n",  -- NORMAL mode
			prefix = "",
			buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
			silent = true, -- use `silent` when creating keymaps
			noremap = true, -- use `noremap` when creating keymaps
			nowait = false, -- use `nowait` when creating keymaps
		}

		-- Normal mode keybindings
		wk.register({
			["<leader>"] = {
				name = "Leader layer",
				["<leader>"] = {
					name = "Leader second layer",
					["p"] = {
						name = "Packer",
						["s"] = KB(":PackerSync<CR>", "Sync", true, false, false),
					},
					g = { vim.cmd.Git, "Git fugitive" },
					l = {
						name = "Programming Languages",
						["."] = { KB(":PackerSync<CR>", "Sync", true, false, false) },
						c = {
							name = "C++",
							s = KB(":lua SetCompileVars()<CR>", "Sets the compiler variables", true, false, false),
							S = KB(":lua SetMakeVar()<CR>", "Sets the make variable(without extension)", true, false, false),
							t = KB(":lua RunCompiler()<CR>", "Executes the compiler", true, false, false),
							T = KB(":lua RunCompilerWithCPP11()<CR>", "Executes the compiler with the C++ standard", true, false, false),
							m = KB(":lua RunMakeAndExecute()<CR>", "Makes the file", true, false, false),
						}
					}
				},
				["."] = {
					name = "Current directory",
					d = KB(":echo expand('%p:h:')<CR>", "Prints the current buffer directory", true, false, false),
					s = KB(":source<CR>", "Sources the current buffer", false, false, false),
				},
				q = KB(":q<CR>", "Quit", false, false, false),
				["Q"] = KB(":q!<CR>", "Force quit", false, false, false),
				t = KB(":ToggleTerm<CR>", "Toggle terminal", false, false, false),
				u = KB(":UndotreeToggle<CR>", "Undo tree history toggle", true, false, false),
				f = {
					name = "Find",
					f = KB(":Telescope find_files<CR>", "Find files", false, false, false),
					t = KB(":Telescope live_grep<CR>", "Find text", false, false, false),
					k = KB(":Telescope keymaps<CR>", "Find keymaps", false, false, false),
				},
				w = {
					name = "Window/Buffer",
					-- [","] = KB(":BufferLineCyclePrev<CR>", "Previous", true, true, false),
					-- ["1"] = KB(":BufferLineGoToBuffer 1<CR>", "Go to buffer 1", true, true, false),
					-- ["2"] = KB(":BufferLineGoToBuffer 2<CR>", "Go to buffer 2", true, true, false),
					-- ["3"] = KB(":BufferLineGoToBuffer 3<CR>", "Go to buffer 3", true, true, false),
					-- ["4"] = KB(":BufferLineGoToBuffer 4<CR>", "Go to buffer 4", true, true, false),
					-- ["5"] = KB(":BufferLineGoToBuffer 5<CR>", "Go to buffer 5", true, true, false),
					-- ["6"] = KB(":BufferLineGoToBuffer 6<CR>", "Go to buffer 6", true, true, false),
					-- ["7"] = KB(":BufferLineGoToBuffer 7<CR>", "Go to buffer 7", true, true, false),
					-- ["8"] = KB(":BufferLineGoToBuffer 8<CR>", "Go to buffer 8", true, true, false),
					-- ["9"] = KB(":BufferLineGoToBuffer 9<CR>", "Go to buffer 9", true, true, false),
					-- [";"] = KB(":BufferLineCycleNext<CR>", "Next", true, true, false),
					-- ["="] = KB(":BufferLineSortByTabs<CR>", "Sort by tabs", true, false),
					a = KB(":wa<CR>", "Save all", false, false, false),
					q = KB(":wq<CR>", "Save and Quit", false, false, false),
					-- c = { function() RepeteableCommand(":BufferLineClose<CR>") end, "Close" },
					-- ch = KB(":BufferLineCloseLeft<CR>", "Close left", true, true, false),
					-- cl = KB(":BufferLineCloseRight<CR>", "Close right", true, true, false),
					-- e = KB(":NvimTreeFocus<CR>", "Focus tree", true, true, false),
					h = KB("<C-w>h", "Move to window on the left", false, true, true),
					j = KB("<C-w>j", "Move to window below", false, true, true),
					k = KB("<C-w>k", "Move to window above", false, true, true),
					l = KB("<C-w>l", "Move to window on the right", false, true, true),
					-- p = KB(":BufferLineTogglePin<CR>", "Pin", true, true, false),
					s = KB(":split<CR>", "Split window horizontally", true, true, false),
					v = KB(":vsplit<CR>", "Split window vertically", true, true, false),
					-- w = KB(":BufferLinePick<CR>", "Pick", true, true, false),
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
				["D"] = {
					name = "Debugging",
					p = KB(":lua require('refactoring').debug.printf({ normal = true })<CR>", "Prints under the cursor", true,
						false,
						false),
					v = KB(":lua require('refactoring').debug.print_var({ normal = true })<CR>", "Print var under the cursor", true,
						false, false),
					c = KB(":lua require('refactoring').debug.print_var({})<CR>", "Clears the prints", true, false, false),
				},
				-- o = {
				-- 	name = "Refactoring",
				-- 	i = KB("<Cmd>lua require('refactoring').refactor('Inline Variable')<CR>", "Inline variable", true, false, false),
				-- 	e = KB("<Cmd>lua require('refactoring').refactor('Extract Block')<CR>", "Extract block", true, false, false),
				-- 	f = KB("<Cmd>lua require('refactoring').refactor('Extract Block To File')<CR>", "Extract block to file", true,
				-- 		false, false),
				-- },
				e = {
					name = "Trouble.nvim",
					l = KB(":TroubleToggle<CR>", "Toggle quickfix list", true, true, false),
				},
			},
			["<C-Up>"] = KB(":resize +2<CR>", "Increase window height", true, true, true),
			["<C-Down>"] = KB(":resize -2<CR>", "Decrease window height", true, true, true),
			["<C-Right>"] = KB(":vertical resize +2<CR>", "Decrease window width", true, true, true),
			["<C-Left>"] = KB(":vertical resize -2<CR>", "Increase window width", true, true, true),
			["H"] = KB("^", "Move to beginning of line", false, false, true),
			["L"] = KB("$", "Move to end of line", false, false, true),
			[";"] = {
				name = "Unimpaired",
				[";"] = KB(";", ";", false, false, false),
				["E"] = KB(":NvimTreeToggle<CR>", "Toggle tree", true, false, false),
				e = KB(":NvimTreeFocus<CR>", "Focus tree", true, false, false),
				z = KB(":qw!<CR>", "Quit", true, true, false),
			},
			[","] = {
				name = "Unimpaired",
				[","] = KB(",", ",", false, false, false),
			},
			z = {
				["Q"] = KB(":q!<CR>", "Force quit", true, true, false),
				["Z"] = KB(":wq<CR>", "Save and Quit", true, true, false),
				e = KB(":NvimTreeToggle<CR>", "Toggle tree", true, true, false),
				q = KB(":q!<CR>", "Quit", true, true, false),
			},
			["Z"] = {
				["Z"] = KB(":wq<CR>", "Save and Quit", true, false, false),
				q = KB(":q!<CR>", "Force Quit", false, false, false),
			},
			["J"] = KB("}", "}", false, false, false),
			["K"] = KB("{", "{", false, false, false),
			-- ["="] = { ":CocCommand prettier.forceFormatDocument<CR>", "Format document" }
		}, n_opts)
	end

	function setup_insert()
		-- Insert mode options
		local i_opts = {
			mode = "i",  -- INSERT mode
			prefix = "",
			buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
			silent = true, -- use `silent` when creating keymaps
			noremap = true, -- use `noremap` when creating keymaps
			nowait = false, -- use `nowait` when creating keymaps
		}

		-- Insert mode keybindings
		wk.register({
			["jk"] = KB("<ESC>", "Exit insert mode (jk)", false, false, false)
		}, i_opts)
	end

	function setup_visual()
		-- Visual mode options
		local v_opts = {
			mode = "v",  -- VISUAL mode
			prefix = "",
			buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
			silent = true, -- use `silent` when creating keymaps
			noremap = true, -- use `noremap` when creating keymaps
			nowait = false, -- use `nowait` when creating keymaps
		}

		-- Visual model keybindings
		wk.register({
			g = {
				-- d = {
				-- 	name = "Debugging",
				-- 	p = KB(":lua require('refactoring').debug.printf()<CR>", "Prints selected text", false, false, false),
				-- 	v = KB(":lua require('refactoring').debug.print_var()<CR>", "Print var selected text", false, false, false),
				-- },
				-- o = KB(":lua require('refactoring').select_refactor()<CR>", "Refactoring", false, false, false),
			},
			["H"] = KB("^", "Move to beginning of line", false, false, false),
			["L"] = KB("$", "Move to end of line", false, false, false),
			["J"] = KB("}", "}", false, false, false),
			["K"] = KB("{", "{", false, false, false)
		}, v_opts)
	end

	function setup_visual_line()
		-- Visual line mode options
		local x_opts = {
			mode = "x",  -- VISUAL LINE  mode
			prefix = "",
			buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
			silent = true, -- use `silent` when creating keymaps
			noremap = true, -- use `noremap` when creating keymaps
			nowait = false, -- use `nowait` when creating keymaps
		}

		-- Visual line keybindings
		-- wk.register({
		-- 	["J"] = { ":m '>+1<CR>gv-gv", "Move selected text down" },
		-- 	["K"] = { ":m '<-2<CR>gv-gv", "Move selected text up" },
		-- 	["<A-j>"] = { ":m '>+1<CR>gv-gv", "Move selected text down" },
		-- 	["<A-k>"] = { ":m '<-2<CR>gv-gv", "Move selected text up" }
		-- }, x_opts)
	end

	function setup_terminal()
		-- Terminal line options

		local t_opts = {
			mode = "t",  -- TERMINAL mode
			prefix = "",
			buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
			silent = true, -- use `silent` when creating keymaps
			noremap = true, -- use `noremap` when creating keymaps
			nowait = false, -- use `nowait` when creating keymaps
		}

		-- Terminal line keybindings
		wk.register({
			["<C-h>"] = KB("<C-\\><C-N><C-w>h", "Move left in terminal mode", false, false, false),
			["<C-j>"] = KB("<C-\\><C-N><C-w>j", "Move down in terminal mode", false, false, false),
			["<C-k>"] = KB("<C-\\><C-N><C-w>k", "Move up in terminal mode", false, false, false),
			["<C-l>"] = KB("<C-\\><C-N><C-w>l", "Move right in terminal mode", false, false, false),
			["<Esc>"] = KB("<C-\\><C-n>", "Exit terminal mode", false, false, false),
			["<leader>t"] = KB("<C-\\><C-n>:ToggleTerm<CR>", "Toggle terminal", false, false, false)
		}, t_opts)
	end

	function setup_command()
		-- Command mode options
		local c_opts = {
			mode = "c",  -- COMMAND mode
			prefix = "",
			buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
			silent = true, -- use `silent` when creating keymaps
			noremap = true, -- use `noremap` when creating keymaps
			nowait = false, -- use `nowait` when creating keymaps
		}

		-- Command mode keybindings
		wk.register({
			["<C-v>"] = KB("<C-r>*", "Paste", false, false, false),
		}, c_opts)
	end

	setup_normal()
	setup_insert()
	setup_visual()
	setup_visual_line()
	setup_terminal()
	setup_command()
end

return M
