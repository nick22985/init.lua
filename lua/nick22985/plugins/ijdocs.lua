return {
	"nick22985/ijdoc.nvim",
	dev = true,
	ft = "java",
	config = function()
		require("ijdocs").setup({
			url = "http://127.0.0.1:63343",
		})
	end,
}
