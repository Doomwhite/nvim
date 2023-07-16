-- function scroll_one_quarter(value)
-- 	local height = vim.api.nvim_win_get_height(0)
-- 	local scroll_amount = math.ceil(height / 3.5)
-- 	if value == 'up' then
-- 		vim.api.nvim_command('normal! ' .. scroll_amount .. 'k')
-- 	else
-- 		vim.api.nvim_command('normal! ' .. scroll_amount .. 'j')
-- 	end
-- end

-- vim.api.nvim_command([[
--   augroup ScrollOneQuarter
--     autocmd!
--     autocmd WinEnter * let &scroll = math.ceil(vim.api.nvim_win_get_height(0) / 3.5)
--   augroup END
-- ]])

function set_scroll_bindings()
	vim.keymap.set({ 'n', 'v', 'x' }, '<C-u>', math.ceil(vim.api.nvim_win_get_height(0) / 3.5) .. "k")
	vim.keymap.set({ 'n', 'v', 'x' }, '<C-d>', math.ceil(vim.api.nvim_win_get_height(0) / 3.5) .. "j")
	vim.opt.scrolloff = math.ceil(vim.api.nvim_win_get_height(0) / (3.5 * 1.2))
end

vim.api.nvim_create_autocmd("BufEnter", {
	callback = function(tbl)
		set_scroll_bindings()
	end
})

vim.api.nvim_create_autocmd("WinResized", {
	callback = function(tbl)
		set_scroll_bindings()
	end
})

vim.api.nvim_create_autocmd('VimEnter', {
	callback = function(tbl)
		set_scroll_bindings()
	end
})
