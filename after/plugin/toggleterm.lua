function setup()
	require("toggleterm").setup {
		direction = 'float',
		float_opts = {
			border = 'curved'
		}
	}
end

if vim.g.vscode then
else
	setup()
end
