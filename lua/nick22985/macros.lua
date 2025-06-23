vim.api.nvim_create_augroup("JSLogMacro", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	group = "JSLogMacro",
	pattern = {
		"javascript",
		"typescript",
		"javascriptreact",
		"typescriptreact",
	},
	callback = function()
		local function js_log()
			local mode = vim.fn.mode()
			local text

			if mode == "v" or mode == "V" or mode == "" then
				vim.cmd('normal! "zy')
				text = vim.fn.getreg("z")
			else
				text = vim.fn.expand("<cword>")
			end

			local line = "console.log('" .. text .. ":', " .. text .. ")"
			vim.fn.append(vim.fn.line(".") - 1, line)
		end

		vim.keymap.set({ "n", "v" }, "<leader>l", js_log, { buffer = true })
	end,
})
