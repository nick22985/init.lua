-- Save current folds on vim leave and load on vim enter
local function remember(mode)
	-- avoid complications with some special filetypes
	local ignoredFts = {
		"TelescopePrompt",
		"DressingSelect",
		"DressingInput",
		"toggleterm",
		"gitcommit",
		"replacer",
		"harpoon",
		"help",
		"qf",
		"NeogitStatus",
		"",
	}
	-- P({ "remember", vim.bo.filetype, vim.bo.buftype, vim.bo.modifiable })
	if vim.tbl_contains(ignoredFts, vim.bo.filetype) or vim.bo.buftype ~= "" or not vim.bo.modifiable then
		return
	end

	if mode == "save" then
		vim.cmd.mkview(1)
	else
		pcall(function()
			vim.cmd.loadview(1)
		end) -- pcall, since new files have no view yet
	end
end
vim.api.nvim_create_autocmd("BufWinLeave", {
	pattern = "?*",
	callback = function()
		remember("save")
	end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
	pattern = "?*",
	callback = function()
		remember("load")
	end,
})

-- vim.api.nvim_create_autocmd("BufWritePre", {
-- 	pattern = "?*",
-- 	callback = function()
-- 		P("save on write")
-- 		remember("save")
-- 	end,
-- })

vim.opt.foldopen:remove({ "search" }) -- no auto-open when searching, since the following snippet does that better

vim.keymap.set("n", "/", "zn/", { desc = "Search & Pause Folds" })
vim.on_key(function(char)
	local key = vim.fn.keytrans(char)
	local searchKeys = { "n", "N", "*", "#", "/", "?" }
	local searchConfirmed = (key == "<CR>" and vim.fn.getcmdtype():find("[/?]") ~= nil)
	if not (searchConfirmed or vim.fn.mode() == "n") then
		return
	end
	local searchKeyUsed = searchConfirmed or (vim.tbl_contains(searchKeys, key))

	local pauseFold = vim.opt.foldenable and searchKeyUsed
	local unpauseFold = not vim.opt.foldenable and not searchKeyUsed
	if pauseFold then
		vim.opt.foldenable = false
	elseif unpauseFold then
		vim.opt.foldenable = true
		vim.cmd.normal("zv") -- after closing folds, keep the *current* fold open
	end
end, vim.api.nvim_create_namespace("auto_pause_folds"))

-- Yank highlight
vim.cmd([[au TextYankPost * silent! lua vim.highlight.on_yank()]])

-- vim.api.nvim_create_autocmd("TextYankPost", {
-- 	group = "bufcheck",
-- 	pattern = "*",
--
-- 	callback = function()
-- 		vim.highlight.on_yank({ timeout = 500 })
-- 	end,
-- })
local esc = vim.api.nvim_replace_termcodes("<Esc>", true, true, true)

-- NOTE: Idk if i like this yet
vim.api.nvim_create_augroup("JSLogMacro", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	group = "JSLogMacro",
	pattern = {
		"javascript",
		"typescript",
		"javascriptreact", -- JSX files
		"typescriptreact", -- TSX files
	},
	callback = function()
		local function js_log()
			local mode = vim.fn.mode()
			local text

			if mode == "v" or mode == "V" or mode == "" then
				-- Visual mode - get selected text
				vim.cmd('normal! "zy')
				text = vim.fn.getreg("z")
			else
				-- Normal mode - get word under cursor
				text = vim.fn.expand("<cword>")
			end

			-- Insert console.log statement below current line
			local line = "console.log('" .. text .. ":', " .. text .. ")"
			vim.fn.append(vim.fn.line("."), line)
		end

		vim.keymap.set({ "n", "v" }, "<leader>l", js_log, { buffer = true })
	end,
})
