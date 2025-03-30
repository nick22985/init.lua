return {
	{
		"toppair/peek.nvim",
		event = { "BufReadPre" },
		build = "deno task --quiet build:fast",
		config = function()
			require("peek").setup({
				filetype = { "markdown", "conf" },
				update_on_cahnge = true,
				app = { "brave", "--new-window" },
			})
			vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
			vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
		end,
	},
}
