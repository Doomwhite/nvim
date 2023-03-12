require('refactoring').setup({})

require('refactoring').setup({
		prompt_func_return_type = {
				go = true,
				java = true,
				cpp = true,
				c = true,
				h = true,
				hpp = true,
				cxx = true,
		},
		prompt_func_param_type = {
				go = true,
				java = true,
				cpp = true,
				c = true,
				h = true,
				hpp = true,
				cxx = true,
		},
		printf_statements = {
				cpp = {
						'std::cout << "%s" << std::endl;'
				},
		},
		print_var_statements = {
				cpp = {
						'printf("a custom statement %%s %s", %s)'
				}
		},
})
