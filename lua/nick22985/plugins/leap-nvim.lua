return {
	url = "https://codeberg.org/andyg/leap.nvim",
	event = "BufReadPre",
	dependencies = {
		"tpope/vim-repeat",
	},
	config = function()
		vim.keymap.set({ "n", "x", "o" }, "<leader>s", "<Plug>(leap)", { desc = "Leap" })
		vim.keymap.set("n", "<leader>S", "<Plug>(leap-from-window)", { desc = "Leap from window" })
		-- vim.keymap.set({ "x", "o" }, "<leader>r", function()
		-- 	require("leap.treesitter").select({
		-- 		opts = require("leap.user").with_traversal_keys("<leader>r", "<leader>R"),
		-- 	})
		-- end, { desc = "Leap TS select" })

		-- ===== Remote Leap =====
		-- vim.keymap.set({ "n", "o" }, "<leader>gs", function()
		-- 	require("leap.remote").action({
		-- 		-- enter visual automatically from normal mode
		-- 		input = vim.fn.mode(true):match("o") and "" or "v",
		-- 	})
		-- end, { desc = "Leap remote" })

		-- ===== Visual polish =====
		require("leap").opts.preview = function(ch0, ch1, ch2)
			return not (ch1:match("%s") or (ch0:match("%a") and ch1:match("%a") and ch2:match("%a")))
		end

		require("leap").opts.equivalence_classes = {
			" \t\r\n",
			"([{",
			")]}",
			"'\"`",
		}

		-- Repeat last leap with Enter / Backspace
		-- require("leap.user").set_repeat_keys("<enter>", "<backspace>")

		-- Auto-paste after remote yank
		-- vim.api.nvim_create_autocmd("User", {
		-- 	pattern = "RemoteOperationDone",
		-- 	group = vim.api.nvim_create_augroup("LeapRemote", {}),
		-- 	callback = function(event)
		-- 		if vim.v.operator == "y" and event.data.register == '"' then
		-- 			vim.cmd("normal! p")
		-- 		end
		-- 	end,
		-- })
	end,
}
