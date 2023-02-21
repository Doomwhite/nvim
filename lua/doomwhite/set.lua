local api = vim.api
local opt = vim.opt

api.nvim_exec('language en_US', true)
opt.nu = true
opt.relativenumber = true

opt.tabstop = 4

opt.hlsearch = false
opt.incsearch = true

opt.termguicolors = true

opt.scrolloff = 8
opt.signcolumn = "yes"
opt.isfname:append("@-@")

opt.updatetime = 50

api.nvim_set_option("clipboard", "unnamed")

local file_to_compile = ""
local output_file = ""

function SetCompileVars()
    file_to_compile = vim.fn.input("Enter the file to compile: ")
    output_file = vim.fn.input("Enter the output file name: ")
end

function RunCompiler()
    local cmd = "g++ " .. file_to_compile .. " -o " .. output_file .. " & " .. output_file
    vim.cmd(":ToggleTerm<CR>")
    vim.cmd("startinsert!")
    vim.api.nvim_feedkeys(cmd, "n", true)
    -- vim.api.nvim_feedkeys("<CR>", "n", true)
end
