-- Shorten function name
local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
local term_opts = { silent = true }

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

function vscodeCommentary(...)
	if not ... then
		vim.api.nvim_buf_set_option(0, 'operatorfunc', vim.fn.matchstr(vim.fn.expand('<sfile>'), '[^. ]*$'))
		return 'g@'
	elseif ... > 1 then
		local line1, line2 = ...
	else
		local line1, line2 = vim.fn.line("'["), vim.fn.line("']")
	end

	vim.fn["VSCodeCallRange"]('editor.action.commentLine', line1, line2, 0)
end

function vscodeGoToDefinition(str)
	if vim.b.vscode_controlled and vim.b.vscode_controlled == 1 then
		vim.fn["VSCodeNotify"]('editor.action.' .. str)
	else
		-- Allow to function in help files
		vim.cmd [[normal! \<C-]>]]
	end
end

function code_actions()
	-- Bind format and comment to vscode format/comment command
	keymap('x', '=', [[:call VSCodeCall('editor.action.formatSelection')<CR>]], opts)
	keymap('n', '=', [[:call VSCodeCall('editor.action.formatSelection')<CR>]], opts)
	keymap('n', '==', [[:call VSCodeCall('editor.action.formatSelection')<CR>]], opts)


	vim.cmd [[
    command! -range -bar VSCodeCommentary call luaeval('vscodeCommentary', <line1>, <line2>)
]]

	keymap('x', '<expr> <Plug>VSCodeCommentary', [[:lua vscodeCommentary()]], opts)
	keymap('n', '<expr> <Plug>VSCodeCommentary', [[:lua vscodeCommentary()]], opts)
	keymap('n', '<expr> <Plug>VSCodeCommentaryLine', [[:lua vscodeCommentary() .. '_']], opts)

	-- Bind C-/ to vscode commentary to add dot-repeat and auto-deselection
	keymap('x', '<C-/>', [[:lua vscodeCommentary()]], { noremap = true, expr = true, silent = true })
	keymap('n', '<C-/>', [[:lua vscodeCommentary() .. '_']], { noremap = true, expr = true, silent = true })


	-- gf/gF. Map to go to definition for now
	-- keymap('n', 'K', [[:lua vscodeGoToDefinition('showHover')<CR>]], opts)
	-- keymap('n', 'gh', [[:lua vscodeGoToDefinition('showHover')<CR>]], opts)
	-- keymap('n', 'gf', [[:lua vscodeGoToDefinition('revealDeclaration')<CR>]], opts)
	-- keymap('n', 'gd', [[:lua vscodeGoToDefinition('revealDefinition')<CR>]], opts)
	-- keymap('n', '<C-]>', [[:lua vscodeGoToDefinition('revealDefinition')<CR>]], opts)
	-- keymap('n', 'gO', [[:lua vim.fn["VSCodeNotify"]('workbench.action.gotoSymbol')<CR>]], opts)
	-- keymap('n', 'gF', [[:lua vim.fn["VSCodeNotify"]('editor.action.peekDeclaration')<CR>]], opts)
	-- keymap('n', 'gD', [[:lua vim.fn["VSCodeNotify"]('editor.action.peekDefinition')<CR>]], opts)
	-- keymap('n', 'gH', [[:lua vim.fn["VSCodeNotify"]('editor.action.referenceSearch.trigger')<CR>]], opts)
	--
	-- keymap('x', 'K', [[:lua vscodeGoToDefinition('showHover')<CR>]], opts)
	-- keymap('x', 'gh', [[:lua vscodeGoToDefinition('showHover')<CR>]], opts)
	-- keymap('x', 'gf', [[:lua vscodeGoToDefinition('revealDeclaration')<CR>]], opts)
	-- keymap('x', 'gd', [[:lua vscodeGoToDefinition('revealDefinition')<CR>]], opts)
	-- keymap('x', '<C-]>', [[:lua vscodeGoToDefinition('revealDefinition')<CR>]], opts)
	-- keymap('x', 'gO', [[:lua vim.fn["VSCodeNotify"]('workbench.action.gotoSymbol')<CR>]], opts)
	-- keymap('x', 'gF', [[:lua vim.fn["VSCodeNotify"]('editor.action.peekDeclaration')<CR>]], opts)
	-- keymap('x', 'gD', [[:lua vim.fn["VSCodeNotify"]('editor.action.peekDefinition')<CR>]], opts)
	-- keymap('x', 'gH', [[:lua vim.fn["VSCodeNotify"]('editor.action.referenceSearch.trigger')<CR>]], opts)

	-- <C-w> gf opens definition on the side
	keymap('n', '<C-w>gf', [[:lua vim.fn["VSCodeNotify"]('editor.action.revealDefinitionAside')<CR>]], opts)
	keymap('n', '<C-w>gd', [[:lua vim.fn["VSCodeNotify"]('editor.action.revealDefinitionAside')<CR>]], opts)
	keymap('x', '<C-w>gf', [[:lua vim.fn["VSCodeNotify"]('editor.action.revealDefinitionAside')<CR>]], opts)
	keymap('x', '<C-w>gd', [[:lua vim.fn["VSCodeNotify"]('editor.action.revealDefinitionAside')<CR>]], opts)

	-- Open quickfix menu for spelling corrections and refactoring
	keymap('n', 'z=', [[:lua vim.fn["VSCodeNotify"]('editor.action.quickFix')<CR>]], opts)
end

function editOrNew(file, bang)
	if file == '' then
		if bang == '!' then
			vim.fn["VSCodeNotify"]('workbench.action.files.revert')
		else
			vim.fn["VSCodeNotify"]('workbench.action.quickOpen')
		end
	else
		vim.fn["VSCodeExtensionNotify"]('open-file', vim.fn["expand"](file), bang == '!' and 1 or 0)
	end
end

function saveAndClose()
	vim.fn["VSCodeCall"]('workbench.action.files.save')
	vim.fn["VSCodeNotify"]('workbench.action.closeActiveEditor')
end

function saveAllAndClose()
	vim.fn["VSCodeCall"]('workbench.action.files.saveAll')
	vim.fn["VSCodeNotify"]('workbench.action.closeAllEditors')
end

function file_commands()
	vim.cmd [[
    command! -bang -nargs=? Edit lua editOrNew(<q-args>, <q-bang>)
    command! -bang Ex lua editOrNew(<q-args>, <q-bang>)
    command! -bang Enew lua editOrNew('__vscode_new__', <q-bang>)
    command! -bang Find lua vim.fn["VSCodeNotify"]('workbench.action.quickOpen')
    command! -complete=file -bang -nargs=? Write lua vim.cmd('if ' .. (vim.fn["expand"]('<q-bang>') ==# '!' and 'true' or 'false') .. ' then vim.fn["VSCodeNotify"]("workbench.action.files.saveAs") else vim.fn["VSCodeNotify"]("workbench.action.files.save") end')
    command! -bang Saveas lua vim.fn["VSCodeNotify"]('workbench.action.files.saveAs')
    command! -bang Wall lua vim.fn["VSCodeNotify"]('workbench.action.files.saveAll')
    command! -bang Quit lua vim.cmd('if ' .. (vim.fn["expand"]('<q-bang>') ==# '!' and 'true' or 'false') .. ' then vim.fn["VSCodeNotify"]("workbench.action.revertAndCloseActiveEditor") else vim.fn["VSCodeNotify"]("workbench.action.closeActiveEditor") end')
    command! -bang Wq lua saveAndClose()
    command! -bang Xit lua saveAndClose()
    command! -bang Qall lua vim.fn["VSCodeNotify"]('workbench.action.closeAllEditors')
    command! -bang Wqall lua saveAllAndClose()
    command! -bang Xall lua saveAllAndClose()
]]

	-- Additional mappings
	keymap('n', 'ZZ', [[:lua vim.cmd('Wq')<CR>]], opts)
	keymap('n', 'ZQ', [[:lua vim.cmd('Quit!')<CR>]], opts)
end

function jumplist()
	keymap('n', '<C-o>', [[:lua vim.fn["VSCodeNotify"]('workbench.action.navigateBack')<CR>]], opts)
	keymap('n', '<C-i>', [[:lua vim.fn["VSCodeNotify"]('workbench.action.navigateForward')<CR>]], opts)
	keymap('n', '<Tab>', [[:lua vim.fn["VSCodeNotify"]('workbench.action.navigateForward')<CR>]], opts)
	keymap('n', '<C-t>', [[:lua vim.fn["VSCodeNotify"]('workbench.action.navigateBack')<CR>]], opts)
end

-- function toFirstCharOfScreenLine()
--     vim.fn["VSCodeNotify"]('cursorMove', { 'to': 'wrappedLineFirstNonWhitespaceCharacter' })
-- end
--
-- function toLastCharOfScreenLine()
--     vim.fn["VSCodeNotify"]('cursorMove', { 'to': 'wrappedLineLastNonWhitespaceCharacter' })
--     -- Offset cursor moving to the right caused by calling VSCode command in Vim mode
--     vim.fn["VSCodeNotify"]('cursorLeft')
-- end

function motion()
	-- vim.api.nvim_set_keymap('n', 'g0', [[:lua toFirstCharOfScreenLine()<CR>]], { noremap = true, silent = true })
	-- vim.api.nvim_set_keymap('n', 'g$', [[:lua toLastCharOfScreenLine()<CR>]], { noremap = true, silent = true })
	--
	-- -- Note: Using these in a macro may break it
	-- vim.api.nvim_set_keymap('n', 'gk', [[:lua vim.fn["VSCodeNotify"]('cursorMove', { 'to': 'up', 'by': 'wrappedLine', 'value': vim.fn["v:count1"] })<CR>]], { noremap = true, silent = true })
	-- vim.api.nvim_set_keymap('n', 'gj', [[:lua vim.fn["VSCodeNotify"]('cursorMove', { 'to': 'down', 'by': 'wrappedLine', 'value': vim.fn["v:count1"] })<CR>]], { noremap = true, silent = true })
end

function reveal(direction, resetCursor)
	vim.fn["VSCodeExtensionNotify"]('reveal', direction, resetCursor)
end

function moveCursor(to)
	-- Native VSCode commands don't register jumplist. Fix by registering jumplist in Vim e.g. for subsequent use of <C-o>
	vim.fn["feedkeys"]("m'", 'n')
	vim.fn["VSCodeExtensionNotify"]('move-cursor', to)
end

function scrolling()
	-- Reveal mappings
	keymap('n', 'z<CR>', [[:lua reveal('top', 1)<CR>]], opts)
	keymap('x', 'z<CR>', [[:lua reveal('top', 1)<CR>]], opts)
	keymap('n', 'zt', [[:lua reveal('top', 0)<CR>]], opts)
	keymap('x', 'zt', [[:lua reveal('top', 0)<CR>]], opts)
	keymap('n', 'z.', [[:lua reveal('center', 1)<CR>]], opts)
	keymap('x', 'z.', [[:lua reveal('center', 1)<CR>]], opts)
	keymap('n', 'zz', [[:lua reveal('center', 0)<CR>]], opts)
	keymap('x', 'zz', [[:lua reveal('center', 0)<CR>]], opts)
	keymap('n', 'z-', [[:lua reveal('bottom', 1)<CR>]], opts)
	keymap('x', 'z-', [[:lua reveal('bottom', 1)<CR>]], opts)
	keymap('n', 'zb', [[:lua reveal('bottom', 0)<CR>]], opts)
	keymap('x', 'zb', [[:lua reveal('bottom', 0)<CR>]], opts)

	-- Move Cursor mappings
	-- keymap('n', 'H', [[:lua moveCursor('top')<CR>]],  opts)
	-- keymap('x', 'H', [[:lua moveCursor('top')<CR>]],  opts)
	-- keymap('n', 'M', [[:lua moveCursor('middle')<CR>]],  opts)
	-- keymap('x', 'M', [[:lua moveCursor('middle')<CR>]],  opts)
	-- keymap('n', 'L', [[:lua moveCursor('bottom')<CR>]],  opts)
	-- keymap('x', 'L', [[:lua moveCursor('bottom')<CR>]],  opts)
end

function switchEditor(count, direction)
	for i = 1, (count == 0 and 1 or count) do
		vim.fn["VSCodeCall"](direction == 'next' and 'workbench.action.nextEditorInGroup' or
			'workbench.action.previousEditorInGroup')
	end
end

function gotoEditor(count)
	vim.fn["VSCodeCall"](count > 0 and 'workbench.action.openEditorAtIndex' .. count or
		'workbench.action.nextEditorInGroup')
end

function tab_commands()
	-- Tabedit command
	vim.cmd [[
    command! -complete=file -nargs=? Tabedit lua if vim.fn.empty(<q-args>) then vim.fn["VSCodeNotify"]('workbench.action.quickOpen') else vim.fn["VSCodeExtensionNotify"]('open-file', vim.fn["expand"](<q-args>), 0) end
    command! -complete=file -nargs=? Tabnew lua vim.fn["VSCodeExtensionNotify"]('open-file', '__vscode_new__', 0)
    command! Tabfind lua vim.fn["VSCodeNotify"]('workbench.action.quickOpen')
    command! Tab echoerr 'Not supported'
    command! Tabs echoerr 'Not supported'
    command! -bang Tabclose lua if vim.fn["expand"]('<q-bang>') ==# '!' then vim.fn["VSCodeNotify"]('workbench.action.revertAndCloseActiveEditor') else vim.fn["VSCodeNotify"]('workbench.action.closeActiveEditor') end
    command! Tabonly lua vim.fn["VSCodeNotify"]('workbench.action.closeOtherEditors')
    command! -nargs=? Tabnext lua vim.fn["switchEditor"](<q-args>, 'next')
    command! -nargs=? Tabprevious lua vim.fn["switchEditor"](<q-args>, 'prev')
    command! Tabfirst lua vim.fn["VSCodeNotify"]('workbench.action.firstEditorInGroup')
    command! Tablast lua vim.fn["VSCodeNotify"]('workbench.action.lastEditorInGroup')
    command! Tabrewind lua vim.fn["VSCodeNotify"]('workbench.action.firstEditorInGroup')
    command! -nargs=? Tabmove echoerr 'Not supported yet'
]]

	-- Tabedit aliases
	-- 	vim.cmd [[
	--     alias tabe tabedit
	--     alias tabn tabnew
	--     alias tabf tabfind
	--     alias tab tab
	--     alias tabs tabs
	--     alias tabc tabclose
	--     alias tabo tabonly
	--     alias tabn tabnext
	--     alias tabp tabprevious
	--     alias tabr tabrewind
	--     alias tabfir tabfirst
	--     alias tabl tablast
	--     alias tabm tabmove
	-- ]]

	-- Key mappings
	keymap('n', 'gt', [[:lua gotoEditor(vim.fn["v:count"])<CR>]], opts)
	keymap('x', 'gt', [[:lua gotoEditor(vim.fn["v:count"])<CR>]], opts)
	keymap('n', 'gT', [[:lua switchEditor(vim.fn["v:count"], 'prev')<CR>]], opts)
	keymap('x', 'gT', [[:lua switchEditor(vim.fn["v:count"], 'prev')<CR>]], opts)
end

function split(direction, file)
	vim.fn["VSCodeCall"](direction == 'h' and 'workbench.action.splitEditorDown' or 'workbench.action.splitEditorRight')
	if not vim.fn["empty"](file) then
		vim.fn["VSCodeExtensionNotify"]('open-file', vim.fn["expand"](file), 'all')
	end
end

function splitNew(file)
	split('h', vim.fn["empty"](file) and '__vscode_new__' or file)
end

function closeOtherEditors()
	vim.fn["VSCodeNotify"]('workbench.action.closeEditorsInOtherGroups')
	vim.fn["VSCodeNotify"]('workbench.action.closeOtherEditors')
end

function manageEditorHeight(count, to)
	for i = 1, (count == 0 and 1 or count) do
		vim.fn["VSCodeNotify"](to == 'increase' and 'workbench.action.increaseViewHeight' or
			'workbench.action.decreaseViewHeight')
	end
end

function manageEditorWidth(count, to)
	for i = 1, (count == 0 and 1 or count) do
		vim.fn["VSCodeNotify"](to == 'increase' and 'workbench.action.increaseViewWidth' or
			'workbench.action.decreaseViewWidth')
	end
end

function window_commands()
	-- Split commands
	vim.cmd [[
    command! -complete=file -nargs=? Split lua vim.fn["split"]('h', <q-args>)
    command! -complete=file -nargs=? Vsplit lua vim.fn["split"]('v', <q-args>)
    command! -complete=file -nargs=? New lua vim.fn["splitNew"](<q-args>)
    command! -complete=file -nargs=? Vnew lua vim.fn["splitNew"](<q-args>)
    command! -bang Only lua if vim.fn["expand"]('<q-bang>') ==# '!' then vim.fn["closeOtherEditors"]() else vim.fn["VSCodeNotify"]('workbench.action.joinAllGroups') end
]]

	-- 	-- Split aliases
	-- 	vim.cmd [[
	--     alias sp Split
	--     alias vs Vsplit
	--     alias new New
	--     alias vnew Vnew
	--     alias on Only
	-- ]]
	--
	-- Buffer management key mappings
	keymap('n', '<C-w>n', [[:lua vim.fn["splitNew"]('h', '__vscode_new__')<CR>]], opts)
	keymap('x', '<C-w>n', [[:lua vim.fn["splitNew"]('h', '__vscode_new__')<CR>]], opts)
	keymap('n', '<C-w>q', [[:lua vim.fn["VSCodeNotify"]('workbench.action.closeActiveEditor')<CR>]], opts)
	keymap('x', '<C-w>q', [[:lua vim.fn["VSCodeNotify"]('workbench.action.closeActiveEditor')<CR>]], opts)
	keymap('n', '<C-w>c', [[:lua vim.fn["VSCodeNotify"]('workbench.action.closeActiveEditor')<CR>]], opts)
	keymap('x', '<C-w>c', [[:lua vim.fn["VSCodeNotify"]('workbench.action.closeActiveEditor')<CR>]], opts)
	keymap('n', '<C-w><C-c>', [[:lua vim.fn["VSCodeNotify"]('workbench.action.closeActiveEditor')<CR>]], opts)
	keymap('x', '<C-w><C-c>', [[:lua vim.fn["VSCodeNotify"]('workbench.action.closeActiveEditor')<CR>]], opts)

	-- Window/splits management key mappings
	-- keymap('n', '<C-w>s', [[:lua vim.fn["split"]('h')<CR>]], opts)
	-- keymap('x', '<C-w>s', [[:lua vim.fn["split"]('h')<CR>]], opts)
	-- keymap('n', '<C-w><C-s>', [[:lua vim.fn["split"]('h')<CR>]], opts)
	-- keymap('x', '<C-w><C-s>', [[:lua vim.fn["split"]('h')<CR>]], opts)
	-- keymap('n', '<C-w>v', [[:lua vim.fn["split"]('v')<CR>]], opts)
	-- keymap('x', '<C-w>v', [[:lua vim.fn["split"]('v')<CR>]], opts)
	-- keymap('n', '<C-w><C-v>', [[:lua vim.fn["split"]('v')<CR>]], opts)
	-- keymap('x', '<C-w><C-v>', [[:lua vim.fn["split"]('v')<CR>]], opts)
	-- keymap('n', '<C-w>=', [[:lua vim.fn["VSCodeNotify"]('workbench.action.evenEditorWidths')<CR>]], opts)
	-- keymap('x', '<C-w>=', [[:lua vim.fn["VSCodeNotify"]('workbench.action.evenEditorWidths')<CR>]], opts)
	-- keymap('n', '<C-w>_', [[:lua vim.fn["VSCodeNotify"]('workbench.action.toggleEditorWidths')<CR>]], opts)
	-- keymap('x', '<C-w>_', [[:lua vim.fn["VSCodeNotify"]('workbench.action.toggleEditorWidths')<CR>]], opts)

	-- Editor height management key mappings
	-- keymap('n', '<C-w>+', [[:lua vim.fn["manageEditorHeight"](vim.fn["v:count"], 'increase')<CR>]], opts)
	-- keymap('x', '<C-w>+', [[:lua vim.fn["manageEditorHeight"](vim.fn["v:count"], 'increase')<CR>]], opts)
	-- keymap('n', '<C-w>-', [[:lua vim.fn["manageEditorHeight"](vim.fn["v:count"], 'decrease')<CR>]], opts)
	-- keymap('x', '<C-w>-', [[:lua vim.fn["manageEditorHeight"](vim.fn["v:count"], 'decrease')<CR>]], opts)

	-- Editor width management key mappings
	-- keymap('n', '<C-w>>', [[:lua vim.fn["manageEditorWidth"](vim.fn["v:count"], 'increase')<CR>]], opts)
	-- keymap('x', '<C-w>>', [[:lua vim.fn["manageEditorWidth"](vim.fn["v:count"], 'increase')<CR>]], opts)
	-- keymap('n', '<C-w><', [[:lua vim.fn["manageEditorWidth"](vim.fn["v:count"], 'decrease')<CR>]], opts)
	-- keymap('x', '<C-w><', [[:lua vim.fn["manageEditorWidth"](vim.fn["v:count"], 'decrease')<CR>]], opts)

	-- Window navigation key mappings
	-- keymap('n', '<C-w>j', [[:lua vim.fn["VSCodeNotify"]('workbench.action.navigateDown')<CR>]], opts)
	-- keymap('x', '<C-w>j', [[:lua vim.fn["VSCodeNotify"]('workbench.action.navigateDown')<CR>]], opts)
	-- keymap('n', '<C-w>k', [[:lua vim.fn["VSCodeNotify"]('workbench.action.navigateUp')<CR>]], opts)
	-- keymap('x', '<C-w>k', [[:lua vim.fn["VSCodeNotify"]('workbench.action.navigateUp')<CR>]], opts)
	-- keymap('n', '<C-w>h', [[:lua vim.fn["VSCodeNotify"]('workbench.action.navigateLeft')<CR>]], opts)
	-- keymap('x', '<C-w>h', [[:lua vim.fn["VSCodeNotify"]('workbench.action.navigateLeft')<CR>]], opts)
	-- keymap('n', '<C-w>l', [[:lua vim.fn["VSCodeNotify"]('workbench.action.navigateRight')<CR>]], opts)
	-- keymap('x', '<C-w>l', [[:lua vim.fn["VSCodeNotify"]('workbench.action.navigateRight')<CR>]], opts)

	-- keymap('n', '<C-w><Down>', [[:lua vim.fn["VSCodeNotify"]('workbench.action.navigateDown')<CR>]], opts)
	-- keymap('x', '<C-w><Down>', [[:lua vim.fn["VSCodeNotify"]('workbench.action.navigateDown')<CR>]], opts)
	-- keymap('n', '<C-w><Up>', [[:lua vim.fn["VSCodeNotify"]('workbench.action.navigateUp')<CR>]], opts)
	-- keymap('x', '<C-w><Up>', [[:lua vim.fn["VSCodeNotify"]('workbench.action.navigateUp')<CR>]], opts)
	-- keymap('n', '<C-w><Left>', [[:lua vim.fn["VSCodeNotify"]('workbench.action.navigateLeft')<CR>]], opts)
	-- keymap('x', '<C-w><Left>', [[:lua vim.fn["VSCodeNotify"]('workbench.action.navigateLeft')<CR>]], opts)
	-- keymap('n', '<C-w><Right>', [[:lua vim.fn["VSCodeNotify"]('workbench.action.navigateRight')<CR>]], opts)
	-- keymap('x', '<C-w><Right>', [[:lua vim.fn["VSCodeNotify"]('workbench.action.navigateRight')<CR>]], opts)

	-- Move editor to group key mappings
	-- keymap('n', '<C-w><C-j>',
	-- 	[[:lua vim.fn["VSCodeNotify"]('workbench.action.moveEditorToBelowGroup')<CR>]], opts)
	-- keymap('x', '<C-w><C-j>',
	-- 	[[:lua vim.fn["VSCodeNotify"]('workbench.action.moveEditorToBelowGroup')<CR>]], opts)
	-- keymap('n', '<C-w><C-k>',
	-- 	[[:lua vim.fn["VSCodeNotify"]('workbench.action.moveEditorToAboveGroup')<CR>]], opts)
	-- keymap('x', '<C-w><C-k>',
	-- 	[[:lua vim.fn["VSCodeNotify"]('workbench.action.moveEditorToAboveGroup')<CR>]], opts)
	-- keymap('n', '<C-w><C-h>',
	-- 	[[:lua vim.fn["VSCodeNotify"]('workbench.action.moveEditorToLeftGroup')<CR>]], opts)
	-- keymap('x', '<C-w><C-h>',
	-- 	[[:lua vim.fn["VSCodeNotify"]('workbench.action.moveEditorToLeftGroup')<CR>]], opts)
	-- keymap('n', '<C-w><C-l>',
	-- 	[[:lua vim.fn["VSCodeNotify"]('workbench.action.moveEditorToRightGroup')<CR>]], opts)
	-- keymap('x', '<C-w><C-l>',
	-- 	[[:lua vim.fn["VSCodeNotify"]('workbench.action.moveEditorToRightGroup')<CR>]], opts)

	-- keymap('n', '<C-w><C-Down>',
	-- 	[[:lua vim.fn["VSCodeNotify"]('workbench.action.moveEditorToBelowGroup')<CR>]], opts)
	-- keymap('x', '<C-w><C-Down>',
	-- 	[[:lua vim.fn["VSCodeNotify"]('workbench.action.moveEditorToBelowGroup')<CR>]], opts)
	-- keymap('n', '<C-w><C-Up>',
	-- 	[[:lua vim.fn["VSCodeNotify"]('workbench.action.moveEditorToAboveGroup')<CR>]], opts)
	-- keymap('x', '<C-w><C-Up>',
	-- 	[[:lua vim.fn["VSCodeNotify"]('workbench.action.moveEditorToAboveGroup')<CR>]], opts)
	-- keymap('n', '<C-w><C-Left>',
	-- 	[[:lua vim.fn["VSCodeNotify"]('workbench.action.moveEditorToLeftGroup')<CR>]], opts)
	-- keymap('x', '<C-w><C-Left>',
	-- 	[[:lua vim.fn["VSCodeNotify"]('workbench.action.moveEditorToLeftGroup')<CR>]], opts)
	-- keymap('n', '<C-w><C-Right>',
	-- 	[[:lua vim.fn["VSCodeNotify"]('workbench.action.moveEditorToRightGroup')<CR>]], opts)
	-- keymap('x', '<C-w><C-Right>',
	-- 	[[:lua vim.fn["VSCodeNotify"]('workbench.action.moveEditorToRightGroup')<CR>]], opts)

	-- Move active editor group key mappings
	-- keymap('n', '<C-w><S-j>',
	-- 	[[:lua vim.fn["VSCodeNotify"]('workbench.action.moveActiveEditorGroupDown')<CR>]], opts)
	-- keymap('x', '<C-w><S-j>',
	-- 	[[:lua vim.fn["VSCodeNotify"]('workbench.action.moveActiveEditorGroupDown')<CR>]], opts)
	-- keymap('n', '<C-w><S-k>',
	-- 	[[:lua vim.fn["VSCodeNotify"]('workbench.action.moveActiveEditorGroupUp')<CR>]], opts)
	-- keymap('x', '<C-w><S-k>',
	-- 	[[:lua vim.fn["VSCodeNotify"]('workbench.action.moveActiveEditorGroupUp')<CR>]], opts)
	-- keymap('n', '<C-w><S-h>',
	-- 	[[:lua vim.fn["VSCodeNotify"]('workbench.action.moveActiveEditorGroupLeft')<CR>]], opts)
	-- keymap('x', '<C-w><S-h>',
	-- 	[[:lua vim.fn["VSCodeNotify"]('workbench.action.moveActiveEditorGroupLeft')<CR>]], opts)
	-- keymap('n', '<C-w><S-l>',
	-- 	[[:lua vim.fn["VSCodeNotify"]('workbench.action.moveActiveEditorGroupRight')<CR>]], opts)
	-- keymap('x', '<C-w><S-l>',
	-- 	[[:lua vim.fn["VSCodeNotify"]('workbench.action.moveActiveEditorGroupRight')<CR>]], opts)

	-- keymap('n', '<C-w><S-Down>',
	-- 	[[:lua vim.fn["VSCodeNotify"]('workbench.action.moveActiveEditorGroupDown')<CR>]], opts)
	-- keymap('x', '<C-w><S-Down>',
	-- 	[[:lua vim.fn["VSCodeNotify"]('workbench.action.moveActiveEditorGroupDown')<CR>]], opts)
	-- keymap('n', '<C-w><S-Up>',
	-- 	[[:lua vim.fn["VSCodeNotify"]('workbench.action.moveActiveEditorGroupUp')<CR>]], opts)
	-- keymap('x', '<C-w><S-Up>',
	-- 	[[:lua vim.fn["VSCodeNotify"]('workbench.action.moveActiveEditorGroupUp')<CR>]], opts)
	-- keymap('n', '<C-w><S-Left>',
	-- 	[[:lua vim.fn["VSCodeNotify"]('workbench.action.moveActiveEditorGroupLeft')<CR>]], opts)
	-- keymap('x', '<C-w><S-Left>',
	-- 	[[:lua vim.fn["VSCodeNotify"]('workbench.action.moveActiveEditorGroupLeft')<CR>]], opts)
	-- keymap('n', '<C-w><S-Right>',
	-- 	[[:lua vim.fn["VSCodeNotify"]('workbench.action.moveActiveEditorGroupRight')<CR>]], opts)
	-- keymap('x', '<C-w><S-Right>',
	-- 	[[:lua vim.fn["VSCodeNotify"]('workbench.action.moveActiveEditorGroupRight')<CR>]], opts)

	-- Window focus key mappings
	-- keymap('n', '<C-w>w', [[:lua vim.fn["VSCodeNotify"]('workbench.action.focusNextGroup')<CR>]], opts)
	-- keymap('x', '<C-w>w', [[:lua vim.fn["VSCodeNotify"]('workbench.action.focusNextGroup')<CR>]], opts)
	-- keymap('n', '<C-w><C-w>', [[:lua vim.fn["VSCodeNotify"]('workbench.action.focusNextGroup')<CR>]], opts)
	-- keymap('x', '<C-w><C-w>', [[:lua vim.fn["VSCodeNotify"]('workbench.action.focusNextGroup')<CR>]], opts)
	-- keymap('n', '<C-w>W', [[:lua vim.fn["VSCodeNotify"]('workbench.action.focusPreviousGroup')<CR>]], opts)
	-- keymap('x', '<C-w>W', [[:lua vim.fn["VSCodeNotify"]('workbench.action.focusPreviousGroup')<CR>]], opts)
	-- keymap('n', '<C-w>p', [[:lua vim.fn["VSCodeNotify"]('workbench.action.focusPreviousGroup')<CR>]], opts)
	-- keymap('x', '<C-w>p', [[:lua vim.fn["VSCodeNotify"]('workbench.action.focusPreviousGroup')<CR>]], opts)

	-- Window focus key mappings
	keymap('n', '<C-w>t', [[:lua vim.fn["VSCodeNotify"]('workbench.action.focusFirstEditorGroup')<CR>]], opts)
	keymap('x', '<C-w>t', [[:lua vim.fn["VSCodeNotify"]('workbench.action.focusFirstEditorGroup')<CR>]], opts)
	keymap('n', '<C-w>b', [[:lua vim.fn["VSCodeNotify"]('workbench.action.focusLastEditorGroup')<CR>]], opts)
	keymap('x', '<C-w>b', [[:lua vim.fn["VSCodeNotify"]('workbench.action.focusLastEditorGroup')<CR>]], opts)
end

function vscode_keybindings()
	keymap('n', '<leader>y', "\"+y", opts)
	keymap('n', '<leader>p', "\"+p", opts)
	keymap('n', '<C-u>', "18k", opts)
	keymap('n', '<C-d>', "18j", opts)
	keymap('n', 'H', "^", opts)
	keymap('n', 'L', "$", opts)
	keymap('n', 'J', "}", opts)
	keymap('n', 'K', "{", opts)

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

	keymap('v', '<leader>y', "\"+y", opts)
	keymap('v', '<leader>p', "\"+p", opts)
	keymap('v', '<C-u>', "18k", opts)
	keymap('v', '<C-d>', "18j", opts)
	keymap('v', 'H', "^", opts)
	keymap('v', 'L', "$", opts)
	keymap('v', 'J', "}", opts)
	keymap('v', 'K', "{", opts)

	keymap('x', '<leader>y', "\"+y", opts)
	keymap('x', '<leader>p', "\"+p", opts)
	keymap('x', '<C-u>', "18k", opts)
	keymap('x', '<C-d>', "18j", opts)
	keymap('x', 'H', "^", opts)
	keymap('x', 'L', "$", opts)
	keymap('x', 'J', "}", opts)
	keymap('x', 'K', "{", opts)

	-- g layer Keybindings
	keymap('n', '<leader>.l',
		[[ viw<Cmd>call VSCodeNotify('extension.generateConsoleLog', { 'query': expand('<cword>')})<CR><ESC> ]], opts)
	keymap('v', '<leader>.l',
		[[ <Cmd>call VSCodeNotify('extension.generateConsoleLog', { 'query': expand('<cword>')})<CR><ESC> ]], opts)

	-- g layer Keybindings
	keymap('n', 'gc', [[ :call VSCodeCall("editor.action.addCommentLine")<CR> ]], opts)
	keymap('n', 'gq', [[ :call VSCodeCall("editor.action.quickFix")<CR> ]], opts)
	keymap('n', 'gen', [[ :call VSCodeCall("editor.action.marker.next")<CR> ]], opts)
	keymap('n', 'gee', [[ :call VSCodeCall("workbench.actions.view.problems")<CR> ]], opts)
	keymap('v', 'gq', [[ :call VSCodeCall("editor.action.quickFix")<CR> ]], opts)
	keymap('x', 'gq', [[ :call VSCodeCall("editor.action.quickFix")<CR> ]], opts)


	keymap('n', '<leader>rr', [[ :call VSCodeCall("editor.action.rename")<CR> ]], opts)

	-- F layer Keybindings
	keymap('n', '<leader>fr', [[ :call VSCodeCall("fileutils.renameFile")<CR> ]], opts)
	keymap('n', '<leader>fs', [[ :call VSCodeCall("workbench.action.files.save")<CR> ]], opts)
	keymap('n', '<leader>fS', [[ :call VSCodeCall("workbench.action.files.saveAll")<CR> ]], opts)
	keymap('n', '<leader>f=', [[ :call VSCodeCall("editor.action.formatDocument")<CR> ]], opts)
	keymap('n', '<leader>fo', [[ :call VSCodeCall("editor.action.organizeImports")<CR> ]], opts)
	keymap('n', '<leader>ff', [[ :call VSCodeCall("workbench.action.quickOpen")<CR> ]], opts)
	keymap('n', '<leader>ft',
		[[ <Cmd>call VSCodeNotify('workbench.action.findInFiles', { 'query': expand('<cword>')})<CR> ]], opts)
	keymap('n', '<leader>fT', [[ :call VSCodeCall("searchEverywhere.search")<CR> ]], opts)


	-- ; layer Keybindings
	keymap('n', ';e', [[ :call VSCodeCall("revealInExplorer")<CR> ]], opts)

	-- W layer Keybindings
	keymap('n', '<leader>wp', [[ :call VSCodeCall("workbench.action.quickOpenPreviousRecentlyUsedEditorInGroup")<CR> ]],
		opts)
	keymap('n', '<leader>ws', '<C-w>s', opts)
	keymap('n', '<leader>wv', '<C-w>v', opts)
	keymap('n', '<leader>wc', ':q', opts)
	keymap('n', '<leader>wh', '<C-w>h', opts)
	keymap('n', '<leader>wj', '<C-w>j', opts)
	keymap('n', '<leader>wk', '<C-w>k', opts)
	keymap('n', '<leader>wl', '<C-w>l', opts)
end

code_actions()
file_commands()
jumplist()
motion()
scrolling()
tab_commands()
window_commands()
vscode_keybindings()
