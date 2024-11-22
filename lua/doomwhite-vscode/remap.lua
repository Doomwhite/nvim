-- vscode module
local vscode = require('vscode')
local action = vscode.action
local call = vscode.call

-- Shorten function name
local keymap = vim.keymap.set
-- local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
local term_opts = { silent = true }
local cmd = vim.cmd

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",
-- :map   :noremap  :unmap     Normal, Visual, Select, Operator-pending
-- :nmap  :nnoremap :nunmap    Normal
-- :vmap  :vnoremap :vunmap    Visual and Select
-- :smap  :snoremap :sunmap    Select
-- :xmap  :xnoremap :xunmap    Visual
-- :omap  :onoremap :ounmap    Operator-pending
-- :map!  :noremap! :unmap!    Insert and Command-line
-- :imap  :inoremap :iunmap    Insert
-- :lmap  :lnoremap :lunmap    Insert, Command-line, Lang-Arg
-- :cmap  :cnoremap :cunmap    Command-line
-- :tmap  :tnoremap :tunmap    Terminal

--Remap leader key
-- keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

function keybindings()

    -- Marks
    keymap('n', '<leader>mw', "mW", opts)
    keymap('n', '<leader>me', "mE", opts)
    keymap('n', '<leader>mr', "mR", opts)
    keymap('n', '<leader>ms', "mS", opts)
    keymap('n', '<leader>md', "mD", opts)
    keymap('n', '<leader>mf', "mF", opts)
    keymap('n', 'mw', "'W", opts)
    keymap('n', 'me', "'E", opts)
    keymap('n', 'mr', "'R", opts)
    keymap('n', 'ms', "'S", opts)
    keymap('n', 'md', "'D", opts)
    keymap('n', 'mf', "'F", opts)

    -- Basic motions
    keymap('n', '<leader>wc', function()
	action("workbench.action.closeActiveEditor")
    end, opts)
    keymap({'n','x', 'v'}, '<leader>y', "\"+y", opts)
    keymap({'n','x', 'v'}, '<leader>p', "\"+p", opts)
    keymap({'n','x', 'v'}, '<C-u>', "18k", opts)
    keymap({'n','x', 'v'}, '<C-d>', "18j", opts)
    keymap({'n','x', 'v'}, 'H', "^", opts)
    keymap({'n','x', 'v'}, 'L', "$", opts)
    keymap({'n','x', 'v'}, 'J', "}", opts)
    keymap({'n','x', 'v'}, 'K', "{", opts)
    keymap({'n','x', 'v'}, 'gp', "gT", opts)

    -- Refactoring
    keymap({ "n" }, "gq", function()
	call("editor.action.quickFix")
    end, opts)
    keymap({ "x" }, "gq", function()
	vscode.with_insert(function()
	    action("editor.action.quickFix")
	end)
    end, opts)
    keymap({ "n" }, "<leader>rr", function()
	    action("editor.action.rename")
    end, opts)
    
    -- W keybinding
    keymap('n', '<leader>wp', function()
	action("workbench.action.quickOpenPreviousRecentlyUsedEditorInGroup")
    end, opts)
    
    -- ; keybindings
    keymap('n', ';e', function()
	action("revealInExplorer")
    end, opts)

    keymap('n', ';E', function()
	action("workbench.action.toggleSidebarVisibility")
    end, opts)

    keymap('n', ';R', function()
	action("workbench.action.toggleAuxiliaryBar")
    end, opts)

    -- F keybindings
    keymap('n', '<leader>ff', function()
	action("workbench.action.quickOpen")
    end, opts)
    keymap('n', '<leader>ft', function()
	local query = vim.fn.expand('<cword>')
	action("search.action.openNewEditor", {
	    args = { query = query, caseSensitive = true, focusResults = true }
	})
    end, opts)
    keymap('n', '<leader>fT', function()
	local query = vim.fn.expand('<cword>')
	action("search.action.openNewEditor", {
	    args = { query = query, caseSensitive = true, focusResults = true, onlyOpenEditors = true }
	})
    end, opts)
    keymap('x', '<leader>ft', function()
	vim.cmd('normal! "vy')
	local selected_text = vim.fn.getreg('"')
	action("search.action.openNewEditor", {
	    args = { query = selected_text, caseSensitive = true, focusResults = true }
	})
    end, opts)
    keymap('x', '<leader>fT', function()
	vim.cmd('normal! "vy')
	local selected_text = vim.fn.getreg('"')
	action("search.action.openNewEditor", {
	    args = { query = selected_text, caseSensitive = true, focusResults = true, onlyOpenEditors = true }
	})
    end, opts)
    keymap('n', '<leader>fs',
           function() action("workbench.action.files.save")
    end, opts)
    keymap('n', '<leader>fS',
           function() action("workbench.action.files.saveAll")
    end, opts)
    keymap('n', '<leader>f=',
           function() action("editor.action.formatDocument")
    end, opts)
    keymap('n', '<leader>fo',
           function() action("editor.action.organizeImports")
    end, opts)
end

keybindings()
