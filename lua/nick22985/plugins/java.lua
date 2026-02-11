return {
	"nvim-java/nvim-java",
	-- { "mfussenegger/nvim-jdtls" }, -- Java LSPlsp.lu
	config = function()
		require("java").setup({})
		vim.lsp.enable("jdtls")
	end,
}
