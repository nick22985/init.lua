return {
	{
		"mbbill/undotree",
		event = "BufReadPre",
		keys = {
			{ mode = "n", "<leader>u", vim.cmd.UndotreeToggle },
		},
		config = function() end,
	},
}
