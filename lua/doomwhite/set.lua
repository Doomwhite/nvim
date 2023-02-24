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