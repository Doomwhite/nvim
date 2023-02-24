local compile_vars_file = vim.fn.stdpath('config') .. '/variables/cpp/compile_vars.lua'

-- Create the folder if it doesn't exist
local compile_vars_dir = vim.fn.fnamemodify(compile_vars_file, ':h')
if vim.fn.isdirectory(compile_vars_dir) == 0 then
	vim.fn.mkdir(compile_vars_dir, 'p')
end

function SetCompileVars()
	vim.g.file_to_compile = vim.fn.input("Enter the file to compile: ")
	vim.g.output_file = vim.fn.input("Enter the output file name: ")
	SaveCompileVars()
end

function RunCompiler()
	local cmd = "g++ " .. vim.g.file_to_compile .. " -o " .. vim.g.output_file .. " & " .. vim.g.output_file
	vim.cmd(":ToggleTerm<CR>")
	vim.cmd("startinsert!")
	vim.api.nvim_feedkeys(cmd, "n", true)
end

function LoadCompileVars()
	if vim.fn.filereadable(compile_vars_file) == 1 then
		local vars = vim.fn.readfile(compile_vars_file)
		vim.g.file_to_compile = vars[1]
		vim.g.output_file = vars[2]
	else
		vim.g.file_to_compile = ""
		vim.g.output_file = ""
		SaveCompileVars() -- Create the file if it doesn't exist
	end
end

function SaveCompileVars()
	local vars = { vim.g.file_to_compile, vim.g.output_file }
	vim.fn.writefile(vars, compile_vars_file)
end

-- Load the compile variables when Vim starts
vim.cmd([[
    augroup myplugin_load_vars
        autocmd!
        autocmd VimEnter * lua LoadCompileVars()
    augroup END
]])

-- Save the compile variables when Vim exits
vim.cmd([[
    augroup myplugin_save_vars
        autocmd!
        autocmd VimLeave * lua SaveCompileVars()
    augroup END
]])
