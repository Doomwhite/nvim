-- vim.o.updatetime = 250;
-- vim.cmd [[autocmd! CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false, scope="cursor"})]]

local lsp = require('lsp-zero').preset({
	name = 'minimal',
	set_lsp_keymaps = { omit = { 'K' } },
	manage_nvim_cmp = true,
	suggest_lsp_servers = false,
})

-- local mlsp = require('mason-lspconfig')
--
-- mlsp.setup{
--   ensure_installed = { 'lua-language-server', 'bash-language-server', 'json-lsp' }
-- }
--
-- mlsp.setup_handlers {
--   function(server)
--     require('lspconfig')[server].setup()
--   end
-- }

lsp.ensure_installed({
	'clangd',
	'tsserver',
	'eslint',
	'rust_analyzer',
	'lua_ls',
})

-- Keybindings
lsp.on_attach(function(client, bufnr)
	local opts = { buffer = bufnr, remap = false }

	vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
	vim.keymap.set("n", "gh", function() vim.lsp.buf.hover() end, opts)
	vim.keymap.set("n", "gq", function() vim.lsp.buf.code_action() end, opts)
	vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, opts)
	vim.keymap.set("n", "<leader>=", function() vim.lsp.buf.format() end, opts)
	vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
	vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
	vim.keymap.set("n", "(d", function() vim.diagnostic.goto_next() end, opts)
	vim.keymap.set("n", ")d", function() vim.diagnostic.goto_prev() end, opts)
	vim.keymap.set("n", "<leader>rr", function() vim.lsp.buf.rename() end, opts)
	vim.keymap.set("n", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

-- vim.api.nvim_create_autocmd("CursorHold", {
--   buffer = bufnr,
--   callback = function()
--     local opts = {
--       focusable = false,
--       close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
--       border = 'rounded',
--       source = 'always',
--       prefix = ' ',
--       scope = 'cursor',
--     }
--     vim.diagnostic.open_float(nil, opts)
--   end
-- })

-- (Optional) Configure lua language server for neovim
-- lsp.nvim_workspace()

lsp.setup()
