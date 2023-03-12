local cmp = require('cmp')

require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
		mapping = cmp.mapping.preset.insert({
				['<C-b>'] = cmp.mapping.scroll_docs( -4),
				['<C-f>'] = cmp.mapping.scroll_docs(4),
				['<C-n>'] = cmp.mapping.select_next_item(),
				['<C-p>'] = cmp.mapping.select_prev_item(),
				['<C-e>'] = cmp.mapping.abort(4),
				['<C-o>'] = cmp.mapping.confirm({ select = true }),
				['<CR>'] = cmp.mapping.confirm({ select = true }),
		}),
		snippet = {
				expand = function(args)
					require('luasnip').lsp_expand(args.body)
				end,
		},
		sources = cmp.config.sources({
				{ name = 'nvim_lsp' },
				{ name = 'luasnip' },

		}, {
				{ name = 'buffer' }
		}
		)
})

-- local cmp_select = { behavior = cmp.SelectBehavior.Select }
-- local cmp_mappings = lsp.defaults.cmp_mappings({
-- 				['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
-- 				['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
-- 				['<C-y>'] = cmp.mapping.confirm({ select = true }),
-- 				["<C-Space>"] = cmp.mapping.complete(),
-- 		})
