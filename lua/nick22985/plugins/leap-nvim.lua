return {
	"ggandor/leap.nvim",
	event = "BufReadPre",
	dependencies = {
		"tpope/vim-repeat",
	},
	config = function()
		-- vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap)")
		-- vim.keymap.set("n", "S", "<Plug>(leap-from-window)")
	end,
}
