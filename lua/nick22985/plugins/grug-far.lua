return {
	"MagicDuck/grug-far.nvim",
	cmd = "GrugFar",
	opts = {
		headerMaxWidth = 80,
	},
	keys = {
		{
			"<leader>sR",
			function()
				require("grug-far").open()
			end,
			mode = "n",
			desc = "[S]earch and [R]eplace (project-wide)",
		},
		{
			"<leader>sR",
			function()
				require("grug-far").with_visual_selection()
			end,
			mode = "x",
			desc = "[S]earch and [R]eplace selection",
		},
		{
			"<leader>sW",
			function()
				require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
			end,
			mode = "n",
			desc = "[S]earch and replace [W]ord under cursor",
		},
	},
}
