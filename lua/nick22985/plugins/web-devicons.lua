return {
	{
		"nvim-tree/nvim-web-devicons",
		event = "VeryLazy",
		config = function()
			local status, nvim_web_devicons = pcall(require, "nvim-web-devicons")
			if not status then
				return
			end
			nvim_web_devicons.setup({
				-- your personnal icons can go here (to override)
				-- you can specify color or cterm_color instead of specifying both of them
				-- DevIcon will be appended to `name`
				override = {
					zsh = {
						icon = "",
						color = "#428850",
						cterm_color = "65",
						name = "Zsh",
					},
				},
				-- globally enable different highlight colors per icon (default to true)
				-- if set to false all icons will have the default icon's color
				color_icons = true,
				-- globally enable default icons (default to false)
				-- will get overriden by `get_icons` option
				default = false,
				-- globally enable "strict" selection of icons - icon will be looked up in
				-- different tables, first by filename, and if not found by extension; this
				-- prevents cases when file doesn't have any extension but still gets some icon
				-- because its name happened to match some extension (default to false)
				strict = false,
				-- same as `override` but specifically for overrides by filename
				-- takes effect when `strict` is true
				override_by_filename = {
					[".gitignore"] = {
						icon = "",
						color = "#f1502f",
						name = "Gitignore",
					},
					["vite.config.js"] = {
						icon = "󰹭",
						color = "#b043ff",
						name = "Vite",
					},
				},
				-- same as `override` but specifically for overrides by extension
				-- takes effect when `strict` is true
				override_by_extension = {
					["log"] = {
						icon = "",
						color = "#81e043",
						name = "Log",
					},
					[".env"] = {
						icon = "",
						color = "#f1502f",
						name = "Env",
					},
					[".env.development"] = {
						icon = "",
						color = "#f1502f",
						name = "Env",
					},
					[".env.production"] = {
						icon = "",
						color = "#f1502f",
						name = "Env",
					},
				},
			})
		end,
	},
}
