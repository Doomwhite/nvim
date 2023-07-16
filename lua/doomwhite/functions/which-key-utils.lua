function KB(action, description, isCommand, isRepeatable, usesCount)
	if isRepeatable then
		if isCommand then
			return { function() RepeteableCommand(action, usesCount) end, description }
		else
			return { function() RepeteableBinding(action, usesCount) end, description }
		end
	end
	if usesCount then
		return { vim.v.count1 .. action, description }
	end
	return { action, description }
end

function RepeteableBinding(action, usesCount)
	if usesCount then
		local actionWithCount = vim.v.count1 .. action
		local actionReplaced = vim.api.nvim_replace_termcodes(actionWithCount, true, true, true)
		vim.api.nvim_input(actionReplaced)
		vim.fn['repeat#set'](actionReplaced, vim.v.count) -- the vim-repeat magic
	else
		local actionReplaced = vim.api.nvim_replace_termcodes(action, true, true, true)
		vim.api.nvim_input(actionReplaced)
		vim.fn['repeat#set'](actionReplaced, vim.v.count) -- the vim-repeat magic
	end
end

function RepeteableCommand(action, usesCount)
	local actionReplaced = vim.api.nvim_replace_termcodes(action, true, true, true)
	vim.cmd(RemoveTermCodes(action))
	if usesCount then
		vim.fn['repeat#set'](actionReplaced, vim.v.count) -- the vim-repeat magic
	else
		vim.fn['repeat#set'](actionReplaced, 0)         -- the vim-repeat magic
	end
end

function RemoveTermCodes(str)
	local tempStr = str
	tempStr = string.gsub(tempStr, "<CR>", "")
	tempStr = string.gsub(tempStr, "<Cr>", "")
	tempStr = string.gsub(tempStr, "<Esc>", "")
	tempStr = string.gsub(tempStr, "<Tab>", "")
	tempStr = string.gsub(tempStr, "<C%-[a-zA-Z]>", "")
	return tempStr
end

function LogSelectedText(lang_name)
	local mode = vim.fn.mode()
	local selected_text = GetSelectedText()

	local log_function_tokens;
	if lang_name == 'zig' then
		log_function_tokens = "std.log.info(\"{any}\", .{" .. selected_text .. "});"
	elseif lang_name == 'tsserver' then
		log_function_tokens = "console.log(\'" .. selected_text .. "\'" .. ", " .. selected_text .. ");"
	elseif lang_name == 'lua_ls' then
		log_function_tokens = "print(" .. selected_text .. ")"
	else
		ThrowNotImplemented("LogSelectedText", lang_name)
		return
	end

	vim.api.nvim_command('normal! o' .. log_function_tokens)
end

function PrintSelectedText(lang_name)
	local mode = vim.fn.mode()
	local selected_text = GetSelectedText()

	local print_function_tokens = "";
	if lang_name == 'zig' then
		print_function_tokens = "std.debug.print(\"{any}\", .{" .. selected_text .. "});"
	elseif lang_name == 'tsserver' then
		print_function_tokens = "console.log(\'" .. selected_text .. "\'" .. ", " .. selected_text .. ");"
	elseif lang_name == 'lua_ls' then
		print_function_tokens = "print(" .. selected_text .. ")"
	else
		ThrowNotImplemented("PrintSelectedText", lang_name)
		return
	end

	vim.api.nvim_command('normal! o' .. print_function_tokens)
end

function GetSelectedText()
	if mode == 'v' or mode == 'V' then
		return vim.fn.getreg('"')
	else
		return vim.fn.expand("<cword>")
	end
end

function ThrowNotImplemented(function_name, lang_name)
	print("The function '" .. function_name .. "' isn't implemented for the LSP '" .. lang_name .. "'.")
end

return {
	KB = KB,
	RepeteableBinding = RepeteableBinding,
	RepeteableCommand = RepeteableCommand,
	RemoveTermCodes = RemoveTermCodes,
	LogSelectedText = LogSelectedText,
	PrintSelectedText = PrintSelectedText,
}
