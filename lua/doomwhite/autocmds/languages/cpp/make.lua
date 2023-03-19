local make_var_file = vim.fn.stdpath('config') .. '/variables/cpp/make_var.lua'

-- Create the folder if it doesn't exist
local make_var_dir = vim.fn.fnamemodify(make_var_file, ':h')
if vim.fn.isdirectory(make_var_dir) == 0 then
	vim.fn.mkdir(make_var_dir, 'p')
end

function SetMakeVar()
	vim.g.cpp_make_file = vim.fn.input("Enter the file to make(without extension): ")
	SaveMakeVar()
end

function RunMakeAndExecute()
	local cmd = "make " .. vim.g.cpp_make_file .. " & " .. vim.g.cpp_make_file
	vim.cmd(":ToggleTerm<CR>")
	vim.cmd("startinsert!")
	vim.api.nvim_feedkeys(cmd, "n", true)
end

function LoadMakeVar()
	if vim.fn.filereadable(make_var_file) == 1 then
		local vars = vim.fn.readfile(make_var_file)
		vim.g.cpp_make_file = vars[1]
	else
		vim.g.cpp_make_file = ""
		SaveMakeVar() -- Create the file if it doesn't exist
	end
end

function SaveMakeVar()
	local vars = { vim.g.cpp_make_file }
	vim.fn.writefile(vars, make_var_file)
end

-- Load the make variable when Vim starts
vim.cmd([[
    augroup myplugin_load_make_var
        autocmd!
        autocmd VimEnter * lua LoadMakeVar()
    augroup END
]])

-- Save the make variable when Vim exits
vim.cmd([[
    augroup myplugin_save_make_var
        autocmd!
        autocmd VimLeave * lua SaveMakeVar()
    augroup END
]])
