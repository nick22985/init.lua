return {
	{
		"theprimeagen/harpoon",
		branch = "harpoon2",
		event = "VeryLazy",
		config = function()
			local harpoon = require("harpoon")
			harpoon:setup({
				menu = {
					width = vim.api.nvim_win_get_width(0) - 4,
				},
				settings = {
					save_on_toggle = false,
					sync_on_ui_close = false,
					save_on_change = true,
					enter_on_sendcmd = false,
					tmux_autoclose_windows = false,
					excluded_filetypes = { "harpoon", "alpha", "dashboard", "gitcommit" },
					mark_branch = false,
					-- key = function()
					-- 	return vim.loop.cwd()
					-- end,
				},
			})
			vim.keymap.set("n", "<leader>A", function()
				harpoon:list():prepend()
			end)
			vim.keymap.set("n", "<leader>a", function()
				harpoon:list():add()
			end)
			vim.keymap.set("n", "<C-e>", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end)

			vim.keymap.set("n", "<C-h>", function()
				harpoon:list():select(1)
			end)
			vim.keymap.set("n", "<C-j>", function()
				harpoon:list():select(2)
			end)
			vim.keymap.set("n", "<C-k>", function()
				harpoon:list():select(3)
			end)
			vim.keymap.set("n", "<C-l>", function()
				harpoon:list():select(4)
			end)

			vim.keymap.set("n", "<leader><C-h>", function()
				harpoon:list():replace_at(1)
			end)
			vim.keymap.set("n", "<leader><C-t>", function()
				harpoon:list():replace_at(2)
			end)
			vim.keymap.set("n", "<leader><C-n>", function()
				harpoon:list():replace_at(3)
			end)
			vim.keymap.set("n", "<leader><C-s>", function()
				harpoon:list():replace_at(4)
			end)
		end,
	},
}
