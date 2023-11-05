local resession = require('resession')

resession.setup({
	autosave = {
		enabled = true,
		interval = 60,
		notify = false,
	},
})

local function has_value(tab, val)
	for index, value in ipairs(tab) do
        value = value:gsub(".*_", "")
		if value == val then
			return true
		end
	end
	return false
end

local function doesSessionExists()
	local sessions = resession.list()
	local dirName = vim.fn.getcwd():gsub(".*/", "")
	return has_value(sessions, dirName)
end

vim.api.nvim_create_autocmd("VimLeavePre", {
	callback = function()
		-- Always save a special session named "last"
		local session_name = resession.get_current()
		if session_name ~= nil then
			resession.save(session_name)
		else
			resession.save("last")
		end
	end,
})

vim.api.nvim_create_autocmd("DirChangedPre", {
	callback = function()
		local session_name = resession.get_current()
		if session_name ~= nil then
			resession.save(session_name)
			resession.detach()
			vim.cmd "%bd!"
			vim.cmd "clearjumps"
		end
	end,
	pattern = "global"
})


vim.api.nvim_create_autocmd("DirChanged", {
	callback = function()
	    local dirName = vim.fn.getcwd():gsub(".*/", "")
		local scope = vim.v.event.scope
		local target = tostring(vim.v.event.changed_window)
		local exists = doesSessionExists()
		if exists ~= false then
			resession.load(dirName)
		end
	end,
	pattern = "global"
})

-- Resession does NOTHING automagically, so we have to set up some keymaps
vim.keymap.set('n', '<leader>ss', resession.save)
vim.keymap.set('n', '<leader>sl', resession.load)
vim.keymap.set('n', '<leader>sd', resession.delete)
