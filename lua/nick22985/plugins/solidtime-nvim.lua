return {
	"nick22985/solidtime.nvim",
	dev = true,
	opts = {},
	config = function(_, opts)
		require("solidtime").setup({
			-- api_url = "https://app.solidtime.io/api/v1",
		})
	end,
}

-- return {}
