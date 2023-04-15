function setup_lsp()
	local lsp = require('lsp-zero').preset({
		name = 'minimal',
		set_lsp_keymaps = { omit = { 'K' } },
		manage_nvim_cmp = true,
		suggest_lsp_servers = false,
	})
	lsp.ensure_installed({
		'clangd',
		'cmake',
		'eslint',
		'lua_ls',
		'rust_analyzer',
		'tsserver',
		'zls'
	})

	-- Keybindings
	lsp.on_attach(function(client, bufnr)
		local opts = { buffer = bufnr, remap = false }
		local keymap = vim.keymap.set

		-- vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
		keymap("n", "gd", "<cmd>Lspsaga goto_definition<CR>", opts)
		keymap("n", "gp", "<cmd>Lspsaga peek_definition<CR>", opts)
		keymap("n", "gr", "<cmd>Lspsaga lsp_finder<CR>", opts)
		keymap({ "n", "v" }, "gq", "<cmd>Lspsaga code_action<CR>", opts)
		keymap("n", "<leader>rr", "<cmd>Lspsaga rename<CR>", opts)
		keymap("n", "gh", "<cmd>Lspsaga hover_doc<CR>", opts)
		keymap("n", "gq", function() vim.lsp.buf.code_action() end, opts)
		keymap("n", "<leader>=", function() vim.lsp.buf.format() end, opts)
		-- keymap("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
		-- keymap("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
		keymap("n", "(d", function() vim.diagnostic.goto_next() end, opts)
		keymap("n", ")d", function() vim.diagnostic.goto_prev() end, opts)
		keymap("n", "<leader>rr", function() vim.lsp.buf.rename() end, opts)
		-- keymap("n", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
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
end

function setup_dap()
	local dap = require('dap')
	local dapui = require('dapui')
	dapui.setup({
		controls = {
			element = "repl",
			enabled = true,
			icons = {
				disconnect = "",
				pause = "",
				play = "",
				run_last = "",
				step_back = "",
				step_into = "",
				step_out = "",
				step_over = "",
				terminate = ""
			}
		},
		element_mappings = {},
		expand_lines = true,
		floating = {
			border = "single",
			mappings = {
				close = { "q", "<Esc>" }
			}
		},
		force_buffers = true,
		icons = {
			collapsed = "",
			current_frame = "",
			expanded = ""
		},
		layouts = {
			{
				elements = {
					{
						id = "scopes",
						size = 0.25
					},
					{
						id = "breakpoints",
						size = 0.25
					},
					{
						id = "stacks",
						size = 0.25
					},
					{
						id = "watches",
						size = 0.25
					}
				},
				position = "left",
				size = 40
			},
			{
				elements = {
					{
						id = "repl",
						size = 0.5
					},
					{
						id = "console",
						size = 0.5
					}
				},
				position = "bottom",
				size = 10
			}
		},
		mappings = {
			edit = "e",
			expand = { "<CR>", "<2-LeftMouse>" },
			open = "o",
			remove = "d",
			repl = "r",
			toggle = "t"
		},
		render = {
			indent = 1,
			max_value_lines = 100
		}
	})

	dap.listeners.after.event_initialized["dapui_config"] = function()
		dapui.open()
	end
end

function setup_mason_dap()
	local mason = require("mason")
	mason.setup()
	local mason_dap = require("mason-nvim-dap")
	mason_dap.setup({
		ensure_installed = {
			"chrome-debug-adapter",
			"firefox-debug-adapter",
			"codelldb",
			"cpptools",
			"js-debug-adapter",
			'stylua',
			'jq'
		},
		automatic_installation = true,
		automatic_setup = true,
		handlers = {
			function(config)
				mason_dap.default_setup(config)
			end,
		},
	})
end

setup_lsp()
setup_dap()
setup_mason_dap()
