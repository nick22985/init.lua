vim.g.mapleader = " "
vim.g.localmapLeader = " "
-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>pv", vim.cmd.Oil)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { silent = true })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { silent = true })

vim.keymap.set("n", "J", "mzJ`z", { silent = true })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { silent = true })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { silent = true })
vim.keymap.set("n", "n", "nzzzv", { silent = true })
vim.keymap.set("n", "N", "Nzzzv", { silent = true })

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]], { silent = true })

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { silent = true })
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { silent = true })

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz", { silent = true })
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz", { silent = true })
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz", { silent = true })

vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz", { silent = true })

vim.keymap.set("n", "<leader>r", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

local search_term = ""

vim.keymap.set("n", "<leader>rg", function()
	-- Get word under cursor
	local default_word = vim.fn.expand("<cword>")
	-- Prompt the user, pre-fill with the word under the cursor
	search_term = vim.fn.input("Ripgrep for: ", default_word)
	if search_term ~= "" then
		vim.cmd('silent! grep! "' .. search_term .. '" .')
		vim.cmd("copen")
		vim.cmd("wincmd p")
	end
end, { desc = "Ripgrep with editable word" })

vim.keymap.set("n", "<leader>rn", function()
	-- Get the word under the cursor
	-- local old_word = vim.fn.expand("<cword>")
	local old_word = search_term
	if old_word == "" then
		old_word = vim.fn.expand("<cword>")
	end

	local new_word = vim.fn.input('Rename "' .. old_word .. '" to: ')

	if new_word ~= "" then
		if #vim.fn.getqflist() == 0 then
			vim.cmd('silent! grep! "' .. old_word .. '" .')
			vim.cmd("copen")
		end

		vim.cmd("cdo s/" .. old_word .. "/" .. new_word .. "/gc | update")

		-- vim.cmd('silent! grep! "' .. new_word .. '" .')
		search_term = ""
	end
end, { desc = "Rename word with preview and confirmation" })

vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>")

vim.keymap.set("n", "<leader><leader>s", function()
	vim.cmd("so")
end)

-- disable
for _, mode in pairs({ "n", "i", "v", "x" }) do
	for _, key in pairs({ "<Up>", "<Down>", "<Left>", "<Right>" }) do
		vim.keymap.set(mode, key, "<nop>")
	end
end

vim.keymap.set("i", "<C-p>", "<nop>")

vim.opt.mouse = ""
