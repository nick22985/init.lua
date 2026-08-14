local function remember(mode)
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
	if vim.tbl_contains(ignoredFts, vim.bo.filetype) or vim.bo.buftype ~= "" or not vim.bo.modifiable then
		return
	end

	if mode == "save" then
		vim.cmd.mkview(1)
	else
		pcall(function()
			-- this breaks shit on load (randomly switch cwd)
			vim.cmd.loadview(1)
		end)
	end
end
vim.api.nvim_create_autocmd("BufWinLeave", {
	pattern = "?*",
	callback = function()
		if vim.v.exiting ~= vim.NIL then
			return
		end
		remember("save")
	end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
	pattern = "?*",
	callback = function()
		remember("load")
	end,
})

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

vim.api.nvim_create_autocmd("FileType", {
	pattern = "gitcommit",
	callback = function()
		vim.opt_local.textwidth = 72
		vim.opt_local.colorcolumn = "50"
		vim.opt_local.spell = true

		vim.cmd([[
      highlight CommitTitleOverflow ctermbg=red guibg=red
      match CommitTitleOverflow '^\([^#].\{51\}\)'
    ]])
	end,
})

vim.o.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
	callback = function()
		if vim.fn.mode() == "c" or vim.fn.getcmdwintype() ~= "" then
			return
		end
		if vim.bo.buftype == "" and vim.api.nvim_buf_get_name(0) ~= "" then
			vim.cmd("checktime")
		end
	end,
})
vim.api.nvim_create_autocmd("FileChangedShellPost", {
	callback = function()
		vim.notify("File changed on disk — buffer reloaded", vim.log.levels.WARN)
	end,
})

local ARG_NODES = {
	argument_list = true,
	arguments = true,
	formal_parameters = true,
	parameters = true,
}

local STOP_NODES = {
	block = true,
	statement_block = true,
	class_body = true,
	constructor_body = true,
}

vim.api.nvim_create_autocmd("InsertEnter", {
	callback = function()
		vim.schedule(function()
			if require("blink.cmp").is_signature_visible() then
				return
			end

			local ok, node = pcall(vim.treesitter.get_node)
			if not ok or not node then
				return
			end

			while node do
				if STOP_NODES[node:type()] then
					return
				end
				if ARG_NODES[node:type()] then
					require("blink.cmp.signature.trigger").show()
					return
				end
				node = node:parent()
			end
		end)
	end,
})

vim.keymap.set({ "n", "i" }, "<C-s>", function()
	local signatureClient = vim.lsp.get_clients({ bufnr = 0, method = "textDocument/signatureHelp" })[1]
	local params = vim.lsp.util.make_position_params(0, signatureClient.offset_encoding)
	vim.lsp.buf_request(0, "textDocument/signatureHelp", params, function(err, result)
		if err then
			vim.notify("Error getting signature help: " .. err.message)
			return
		end
		if not result then
			vim.notify("No signature help available.")
			return
		end
		local firstSig = result.signatures[1].label
		vim.notify(firstSig)
	end)
end)
