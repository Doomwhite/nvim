function enable_cursorline()
	local loaded, reticle = pcall(require, 'reticle')
	if loaded then
		reticle.enable_cursorline()
	else
		vim.o.cursorline = true
	end
end

function disable_cursorline()
	local loaded, reticle = pcall(require, 'reticle')
	if loaded then
		reticle.disable_cursorline()
	else
		vim.o.cursorline = false
	end
end

function toggle_cursorline()
	local loaded, reticle = pcall(require, 'reticle')
	if loaded then
		reticle.toggle_cursorline()
	else
		vim.o.cursorline = not vim.o.cursorline
	end
end

function enable_diff() vim.cmd('diffthis') end

function disable_diff() vim.cmd('diffoff') end

function toggle_diff()
	if vim.o.diff then
		disable_diff()
	else
		enable_diff()
	end
end

function enable_hlsearch() vim.o.hlsearch = true end

function disable_hlsearch() vim.o.hlsearch = false end

function toggle_hlsearch() vim.o.hlsearch = not vim.o.hlsearch end

function enable_ignorecase() vim.o.ignorecase = true end

function disable_ignorecase() vim.o.ignorecase = false end

function toggle_ignorecase() vim.o.ignorecase = not vim.o.ignorecase end

function enable_list() vim.o.list = true end

function disable_list() vim.o.list = false end

function toggle_list() vim.o.list = not vim.o.list end

function enable_number() vim.o.number = true end

function disable_number() vim.o.number = false end

function toggle_number() vim.o.number = not vim.o.number end

function enable_relativenumber() vim.o.relativenumber = true end

function disable_relativenumber() vim.o.relativenumber = false end

function toggle_relativenumber() vim.o.relativenumber = not vim.o.relativenumber end

function enable_spell() vim.o.spell = true end

function disable_spell() vim.o.spell = false end

function toggle_spell() vim.o.spell = not vim.o.spell end

function enable_colorcolumn() vim.o.colorcolumn = '+1' end

function disable_colorcolumn() vim.o.colorcolumn = '' end

function toggle_colorcolumn()
	if vim.o.colorcolumn == '' then
		enable_colorcolumn()
	else
		disable_colorcolumn()
	end
end

function tnext()
	vim.cmd('silent! ' .. vim.v.count1 .. 'tnext')
end

function enable_cursorcolumn() vim.o.cursorcolumn = true end

function disable_cursorcolumn() vim.o.cursorcolumn = false end

function toggle_cursorcolumn() vim.o.cursorcolumn = not vim.o.cursorcolumn end

function enable_virtualedit() vim.o.virtualedit = 'all' end

function disable_virtualedit() vim.o.virtualedit = '' end

function toggle_virtualedit()
	if vim.o.virtualedit == '' then
		enable_virtualedit()
	else
		disable_virtualedit()
	end
end

function enable_wrap() vim.o.wrap = true end

function disable_wrap() vim.o.wrap = false end

function toggle_wrap() vim.o.wrap = not vim.o.wrap end

function enable_cursorcross()
	enable_cursorline()
	enable_cursorcolumn()
end

function disable_cursorcross()
	disable_cursorline()
	disable_cursorcolumn()
end

function toggle_cursorcross()
	local cursorline = vim.o.cursorline
	local loaded, reticle = pcall(require, 'reticle')
	if loaded then cursorline = reticle.is_cursorline() end
	if cursorline and vim.o.cursorcolumn then
		disable_cursorcross()
	else
		enable_cursorcross()
	end
end
