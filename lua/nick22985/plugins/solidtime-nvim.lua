return {
	"nick22985/solidtime.nvim",
	dev = true,
	opts = {},
	config = function(_, opts)
		require("solidtime").setup({
			idle_warn_timeout = 0, -- no warning
			idle_stop_timeout = 0, -- never auto-stop
			autotrack = {
				auto_setup_project = true,
				grace_period = 300,
				auto_setup_defaults = {
					auto_start = true,
					billable = true,
					color = "random",
					description = "",
					infer_client = true,
				},
			},
		})
	end,
}

-- return {}
