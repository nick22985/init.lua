return {
	{
		"prichrd/netrw.nvim",
		event = "UIEnter",
		config = function()
			local status, netrw = pcall(require, "netrw")
			if not status then
				return
			end

			netrw.setup({
				-- Put your configuration here, or leave the object empty to take the default
				-- configuration.
				icons = {
					symlink = "", -- Symlink icon (directory and file)
					directory = "", -- Directory icon
					file = "", -- File icon
				},
				use_devicons = true, -- Uses nvim-web-devicons if true, otherwise use the file icon specified above
				mappings = {}, -- Custom key mappings
			})
		end,
	},
}
