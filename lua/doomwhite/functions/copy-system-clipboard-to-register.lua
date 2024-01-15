function CopySystemClipboardToRegister(register)
	local system_clipboard = vim.fn.getreg('+')
	vim.fn.setreg(register, system_clipboard)
end
