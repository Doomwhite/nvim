local api = vim.api
api.nvim_exec('language en_US', true)
-- api.nvim_set_option("clipboard", "unnamed")

-- vim.g.coc_node_path = 'C:/Users/Cliente/scoop/persist/nvm/nodejs/v19.7.0/node'

local python3_host_prog = vim.fn.getenv('python3_neovim')
if python3_host_prog then
	vim.g.python3_host_prog = python3_host_prog
end

local python_host_prog = vim.fn.getenv('python_neovim')
if python_host_prog then
	vim.g.python_host_prog = python_host_prog
end

local options = {
	cmdheight = 2,
	fileencoding = "utf-8",
	hlsearch = false,
	ignorecase = true,
	incsearch = true,
	mouse = "a",
	nu = true,
	relativenumber = true,
	ruler = true,
	-- scrolloff = 8,
	shiftwidth = 2,
	signcolumn = "yes",
	smartcase = true,
	smartindent = true,
	splitbelow = true,
	splitright = true,
	tabstop = 2,
	termguicolors = true,
	updatetime = 50,
	foldmethod = "manual",
	foldlevel = 1
}

vim.opt.isfname:append("@-@")

for k, v in pairs(options) do
	vim.opt[k] = v
end
