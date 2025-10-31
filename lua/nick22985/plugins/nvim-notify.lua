return {
	{
		"rcarriga/nvim-notify",
		event = "VeryLazy",
		config = function()
			local notify = require("notify")

			local filtered_notify = function(msg, level, opts)
				local suppress_patterns = {
					"Cannot find provider for documentHighlight",
					"get_completions failed",
				}

				for _, pattern in ipairs(suppress_patterns) do
					if type(msg) == "string" and msg:match(pattern) then
						return
					end
				end

				notify(msg, level, opts)
			end

			vim.notify = filtered_notify

			notify.setup({
				background_colour = "#000000",
			})
		end,
	},
}
