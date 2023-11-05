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
		if value == val then
			return true
		end
	end
	return false
end

local function doesSessionExists()
	local sessions = resession.list()
	local cwd = vim.fn.getcwd():gsub("/", "_")
	return has_value(sessions, cwd)
end

vim.api.nvim_create_autocmd("VimLeavePre", {
	callback = function()
		-- Always save a special session named "last"
		local cwd = vim.fn.getcwd()
		local session_name = resession.get_current()
		if session_name ~= nil then
			resession.save(cwd)
		else
			resession.save("last")
		end
	end,
})

vim.api.nvim_create_autocmd("DirChangedPre", {
	callback = function()
		print('dir change pre')
		local cwd = vim.fn.getcwd()
		local session_name = resession.get_current()
		if session_name ~= nil then
			resession.save(cwd)
			resession.detach()
			vim.cmd "%bd!"
			vim.cmd "clearjumps"
		end
	end,
	pattern = "global"
})


vim.api.nvim_create_autocmd("DirChanged", {
	callback = function()
		local cwd = vim.fn.getcwd()
		local scope = vim.v.event.scope
		local target = tostring(vim.v.event.changed_window)
		print("DirChanged: " .. cwd .. " " .. scope .. "" .. target)
		local exists = doesSessionExists()
		print('exists', exists)
		if exists ~= false then
			print('load session')
			resession.load(cwd)
			print('loaded')
		end
	end,
	pattern = "global"
})

-- Resession does NOTHING automagically, so we have to set up some keymaps
vim.keymap.set('n', '<leader>ss', resession.save)
vim.keymap.set('n', '<leader>sl', resession.load)
vim.keymap.set('n', '<leader>sd', resession.delete)
