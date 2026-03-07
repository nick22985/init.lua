return {
	"nick22985/solidtime.nvim",
	dev = true,
	opts = {},
	config = function(_, opts)
		require("solidtime").setup({
			idle_warn_timeout = 0, -- no warning
			idle_stop_timeout = 0, -- never auto-stop
		})
	end,
}

-- return {}
