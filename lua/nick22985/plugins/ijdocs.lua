return {
	{
		"nick22985/ijdocs.nvim",
		dev = true,
		ft = "java",
		build = "cargo build --release",
		config = function()
			require("ijdocs").setup({
				url = "http://127.0.0.1:63343",
			})
		end,
	},
}
