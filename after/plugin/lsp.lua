local keymap = vim.keymap.set

-- function set_registers_to_deattached(wk, opts)
-- 	local title = "Deattached (No binding set)"
-- 	wk.register({
-- 		["<leader>.l"] = { "", title },
-- 		["<leader>.p"] = { "", title }
-- 	}, opts)
-- end
--
local servers = {
	zls = {
		on_attach = function(client, bufnr)
			local lang_name = "zls"
			local opts = { buffer = bufnr, remap = true }
			set_default_keymaps(opts)
			set_code_action_keymaps(lang_name, bufnr)
		end
	},
	clangd = {
		on_attach = function(client, bufnr)
			local lang_name = "clangd"
			local opts = { buffer = bufnr, remap = true }
			set_default_keymaps(opts)
			set_code_action_keymaps(lang_name, bufnr)
		end
	},
	cmake = {
		on_attach = function(client, bufnr)
			local lang_name = "cmake"
			local opts = { buffer = bufnr, remap = true }
			set_default_keymaps(opts)
			set_code_action_keymaps(lang_name, bufnr)
		end
	},
	eslint = {
		on_attach = function(client, bufnr)
			local lang_name = "eslint"
			local opts = { buffer = bufnr, remap = true }
			set_default_keymaps(opts)
			set_code_action_keymaps(lang_name, bufnr)
		end
	},
	lua_ls = {
		on_attach = function(client, bufnr)
			local lang_name = "lua_ls"
			local opts = { buffer = bufnr, remap = true }
			set_default_keymaps(opts)
			set_code_action_keymaps(lang_name, bufnr)
		end
	},
	tsserver = {
		on_attach = function(client, bufnr)
			local lang_name = "tsserver"
			local opts = { buffer = bufnr, remap = true }
			set_default_keymaps(opts)
			set_code_action_keymaps(lang_name, bufnr)
		end
	},
}

function set_code_action_keymaps(lang_name, bufnr)
	local wk = require("which-key")
	local wk_normal_opts = { mode = "n", buffer = bufnr, remap = true }
	local wk_visual_opts = { mode = "v", buffer = bufnr, remap = true }
	wk.register({
		["<leader>.l"] = { string.format(":lua LogSelectedText(\"%s\", 'n')<CR>", lang_name), "LogSelectedText" },
		["<leader>.p"] = { string.format(":lua PrintSelectedText(\"%s\", 'n')<CR>", lang_name), "PrintSelectedText" }
	}, wk_normal_opts)
	wk.register({
		["<leader>.l"] = { string.format(":lua LogSelectedText(\"%s\", 'v')<CR>", lang_name), "LogSelectedText" },
		["<leader>.p"] = { string.format(":lua PrintSelectedText(\"%s\", 'v')<CR>", lang_name), "PrintSelectedText" }
	}, wk_visual_opts)
end

function setup_lsp()
	local lsp = require('lsp-zero').preset({
		name = 'minimal',
		set_lsp_keymaps = { omit = { 'K' } },
		manage_nvim_cmp = true,
		suggest_lsp_servers = false,
	})
	lsp.ensure_installed(vim.tbl_keys(servers))

	-- Keybindings
	lsp.on_attach(function(client, bufnr)
		-- local opts = { buffer = bufnr, remap = false }
		-- keymap("n", "gd", "<cmd>Lspsaga goto_definition<CR>", opts)
		-- keymap("n", "gp", "<cmd>Lspsaga peek_definition<CR>", opts)
		-- keymap("n", "gr", "<cmd>Lspsaga lsp_finder<CR>", opts)
		-- keymap({ "n", "v" }, "gq", "<cmd>Lspsaga code_action<CR>", opts)
		-- keymap("n", "<leader>rr", "<cmd>Lspsaga rename<CR>", opts)
		-- keymap("n", "gh", "<cmd>Lspsaga hover_doc<CR>", opts)
		-- keymap("n", "gq", function() vim.lsp.buf.code_action() end, opts)
		-- keymap("n", "<leader>f=", function() vim.lsp.buf.format() end, opts)
		-- keymap("n", "(d", function() vim.diagnostic.goto_next() end, opts)
		-- keymap("n", ")d", function() vim.diagnostic.goto_prev() end, opts)
		-- keymap("n", "<leader>rr", function() vim.lsp.buf.rename() end, opts)
		-- -- vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
		-- -- keymap("n", "<leader>=", function() vim.lsp.buf.format() end, opts)
		-- -- keymap("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
		-- -- keymap("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
		-- -- keymap("n", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
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

function setup_lsp_config_servers()
	local lsp_config = require('lspconfig')
	for k, v in pairs(servers) do
		lsp_config[k].setup(v)
	end
end

function set_default_keymaps(opts)
	keymap("n", "gd", "<cmd>Lspsaga goto_definition<CR>", opts)
	keymap("n", "gp", "<cmd>Lspsaga peek_definition<CR>", opts)
	keymap("n", "gr", "<cmd>Lspsaga lsp_finder<CR>", opts)
	keymap({ "n", "v" }, "gq", "<cmd>Lspsaga code_action<CR>", opts)
	keymap("n", "<leader>rr", "<cmd>Lspsaga rename<CR>", opts)
	keymap("n", "gh", "<cmd>Lspsaga hover_doc<CR>", opts)
	keymap("n", "gq", function() vim.lsp.buf.code_action() end, opts)
	keymap("n", "<leader>f=", function() vim.lsp.buf.format() end, opts)
	keymap("n", "(d", function() vim.diagnostic.goto_next() end, opts)
	keymap("n", ")d", function() vim.diagnostic.goto_prev() end, opts)
	keymap("n", "<leader>rr", function() vim.lsp.buf.rename() end, opts)
	-- vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
	-- keymap("n", "<leader>=", function() vim.lsp.buf.format() end, opts)
	-- keymap("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
	-- keymap("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
	-- keymap("n", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
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

function setup_rust_tools()
	local rt = require("rust-tools")

	local opts = {
		tools = {
			-- rust-tools options

			-- how to execute terminal commands
			-- options right now: termopen / quickfix
			executor = require("rust-tools.executors").termopen,

			-- callback to execute once rust-analyzer is done initializing the workspace
			-- The callback receives one parameter indicating the `health` of the server: "ok" | "warning" | "error"
			on_initialized = nil,

			-- automatically call RustReloadWorkspace when writing to a Cargo.toml file.
			reload_workspace_from_cargo_toml = true,

			-- These apply to the default RustSetInlayHints command
			inlay_hints = {
				-- automatically set inlay hints (type hints)
				-- default: true
				auto = true,

				-- Only show inlay hints for the current line
				only_current_line = false,

				-- whether to show parameter hints with the inlay hints or not
				-- default: true
				show_parameter_hints = true,

				-- prefix for parameter hints
				-- default: "<-"
				parameter_hints_prefix = "<- ",

				-- prefix for all the other hints (type, chaining)
				-- default: "=>"
				other_hints_prefix = "=> ",

				-- whether to align to the length of the longest line in the file
				max_len_align = false,

				-- padding from the left if max_len_align is true
				max_len_align_padding = 1,

				-- whether to align to the extreme right or not
				right_align = false,

				-- padding from the right if right_align is true
				right_align_padding = 7,

				-- The color of the hints
				highlight = "Comment",
			},

			-- options same as lsp hover / vim.lsp.util.open_floating_preview()
			hover_actions = {
				-- the border that is used for the hover window
				-- see vim.api.nvim_open_win()
				border = {
					{ "╭", "FloatBorder" },
					{ "─", "FloatBorder" },
					{ "╮", "FloatBorder" },
					{ "│", "FloatBorder" },
					{ "╯", "FloatBorder" },
					{ "─", "FloatBorder" },
					{ "╰", "FloatBorder" },
					{ "│", "FloatBorder" },
				},

				-- Maximal width of the hover window. Nil means no max.
				max_width = nil,

				-- Maximal height of the hover window. Nil means no max.
				max_height = nil,

				-- whether the hover action window gets automatically focused
				-- default: false
				auto_focus = false,
			},

			-- settings for showing the crate graph based on graphviz and the dot
			-- command
			crate_graph = {
				-- Backend used for displaying the graph
				-- see: https://graphviz.org/docs/outputs/
				-- default: x11
				backend = "x11",
				-- where to store the output, nil for no output stored (relative
				-- path from pwd)
				-- default: nil
				output = nil,
				-- true for all crates.io and external crates, false only the local
				-- crates
				-- default: true
				full = true,

				-- List of backends found on: https://graphviz.org/docs/outputs/
				-- Is used for input validation and autocompletion
				-- Last updated: 2021-08-26
				enabled_graphviz_backends = {
					"bmp",
					"cgimage",
					"canon",
					"dot",
					"gv",
					"xdot",
					"xdot1.2",
					"xdot1.4",
					"eps",
					"exr",
					"fig",
					"gd",
					"gd2",
					"gif",
					"gtk",
					"ico",
					"cmap",
					"ismap",
					"imap",
					"cmapx",
					"imap_np",
					"cmapx_np",
					"jpg",
					"jpeg",
					"jpe",
					"jp2",
					"json",
					"json0",
					"dot_json",
					"xdot_json",
					"pdf",
					"pic",
					"pct",
					"pict",
					"plain",
					"plain-ext",
					"png",
					"pov",
					"ps",
					"ps2",
					"psd",
					"sgi",
					"svg",
					"svgz",
					"tga",
					"tiff",
					"tif",
					"tk",
					"vml",
					"vmlz",
					"wbmp",
					"webp",
					"xlib",
					"x11",
				},
			},
		},

		-- all the opts to send to nvim-lspconfig
		-- these override the defaults set by rust-tools.nvim
		-- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
		server = {
			on_attach = function(_, bufnr)
				local opts = { buffer = bufnr, remap = false }
				keymap("n", "gh", rt.hover_actions.hover_actions, opts)
				keymap("n", "gq", rt.code_action_group.code_action_group, opts)
				-- keymap("n", "<leader>=", function() vim.lsp.buf.format() end, opts)
				keymap("n", "<leader>f=", function() vim.lsp.buf.format() end, opts)
				keymap("n", "g;i", rt.require('rust-tools').inlay_hints.enable, opts)
				keymap("n", "g;I", rt.require('rust-tools').inlay_hints.disable, opts)
				keymap("n", "g;h", rt.hover_actions.hover_actions, opts)
				keymap("n", "g;r", rt.runnables.runnables, opts)
				keymap("n", "g;c", rt.open_cargo_toml.open_cargo_toml, opts)
				keymap("n", "g;p", rt.open_cargo_toml.open_cargo_toml, opts)
				keymap("n", "g;v", rt.open_cargo_toml.open_cargo_toml, opts)
			end,
		}, -- rust-analyzer options

		-- debugging stuff
		dap = {
			adapter = {
				type = "executable",
				command = "lldb-vscode",
				name = "rt_lldb",
			},
		},
	}

	rt.setup(opts)
end

setup_lsp()
setup_lsp_config_servers()
setup_dap()
setup_mason_dap()
setup_rust_tools()
