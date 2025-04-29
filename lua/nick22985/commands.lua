-- Function to convert to tabs
local function convert_to_tabs()
	-- Save cursor position
	local saved_view = vim.fn.winsaveview()

	-- Set to tabs and convert
	vim.bo.expandtab = false
	vim.cmd("%retab!")

	-- Restore cursor position
	vim.fn.winrestview(saved_view)

	vim.api.nvim_echo({ { "Converted to tabs", "Normal" } }, false, {})
end

-- Function to convert to spaces
local function convert_to_spaces()
	-- Save cursor position
	local saved_view = vim.fn.winsaveview()

	-- Set to spaces and convert
	vim.bo.expandtab = true
	vim.cmd("%retab")

	-- Restore cursor position
	vim.fn.winrestview(saved_view)

	vim.api.nvim_echo({ { "Converted to spaces", "Normal" } }, false, {})
end

-- Function to toggle between tabs and spaces
local function toggle_tabs_spaces()
	-- Check current state
	local uses_spaces = vim.bo.expandtab

	if uses_spaces then
		convert_to_tabs()
	else
		convert_to_spaces()
	end
end

-- Create user commands for these functions
vim.api.nvim_create_user_command("ConvertToTabs", function()
	convert_to_tabs()
end, { desc = "Convert indentation to tabs" })

vim.api.nvim_create_user_command("ConvertToSpaces", function()
	convert_to_spaces()
end, { desc = "Convert indentation to spaces" })

vim.api.nvim_create_user_command("ToggleTabsSpaces", function()
	toggle_tabs_spaces()
end, { desc = "Toggle between tabs and spaces" })

-- Optional: Create key mappings
-- vim.keymap.set('n', '<Leader>tt', convert_to_tabs, { desc = 'Convert to tabs' })
-- vim.keymap.set('n', '<Leader>ts', convert_to_spaces, { desc = 'Convert to spaces' })
-- vim.keymap.set('n', '<Leader>tg', toggle_tabs_spaces, { desc = 'Toggle tabs/spaces' })
