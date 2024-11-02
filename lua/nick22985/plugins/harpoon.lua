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
					key = function()
						return vim.loop.cwd()
					end
				}
			})
			vim.keymap.set("n", "<leader>a", function()
				harpoon:list():add()
			end)
			vim.keymap.set("n", "<C-e>", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end)

			vim.keymap.set("n", "<C-h>", function()
				harpoon:list():select(1)
			end)
			vim.keymap.set("n", "<C-t>", function()
				harpoon:list():select(2)
			end)
			vim.keymap.set("n", "<C-n>", function()
				harpoon:list():select(3)
			end)
			vim.keymap.set("n", "<C-s>", function()
				harpoon:list():select(4)
			end)

			-- Toggle previous & next buffers stored within Harpoon list
			vim.keymap.set("n", "<C-S-P>", function()
				harpoon:list():prev()
			end)
			vim.keymap.set("n", "<C-S-N>", function()
				harpoon:list():next()
			end)
		end,
	},
}
