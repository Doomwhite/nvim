local options = {
	cmdheight = 4,
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
