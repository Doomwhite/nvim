-- Define the vim config folder
local config_dir = vim.fn.stdpath('config')

-- Define the URL of the file to download
local url = "https://github.com/microsoft/vscode-cpptools/releases/download/v1.14.5/cpptools-win64.vsix"

-- Define the name of the file to download
local filename = "cpptools-win64.vsix"

-- Define the name of the directory of the language
local language_dir = config_dir .. "/after/plugin/dap-debuggers"

-- Define the name of the directory to extract the downloaded file to
local cpp_tools_dir = config_dir .. "/after/plugin/dap-debuggers/cpp/cpptools-win64"

-- Check if the extract directory already exists
if vim.fn.isdirectory(cpp_tools_dir) == 0 then
	-- Define the command to download the file
	local download_cmd = "wget -q " .. url .. " -O " .. filename

	-- Define the command to make the language directory
	local make_language_dir_cmd = "mkdir cpp"

	-- Define the command to extract the downloaded file
	local extract_cmd = "unzip -q " .. filename .. " -d " .. cpp_tools_dir

	-- Define the command to delete the downloaded file
	local delete_cmd = "del " .. filename

	-- Check if `wget` and `unzip` are available in the system
	if vim.fn.executable("wget") == 0 or vim.fn.executable("unzip") == 0 then
		print("Error: wget and/or unzip not found on the system.")
	else
		-- Execute the commands using the `:!` command in neovim
		vim.api.nvim_command("!cd " .. config_dir .. " && " .. download_cmd)
		vim.api.nvim_command("!cd " .. language_dir .. " && " .. make_language_dir_cmd)
		vim.api.nvim_command("!cd " .. config_dir .. " && " .. extract_cmd)
		vim.api.nvim_command("!cd " .. config_dir .. " && " .. delete_cmd)

		print("Successfully downloaded and extracted " .. filename .. " to " .. cpp_tools_dir)
	end
end
