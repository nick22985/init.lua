function ColorMyPencils(color)
	color = color or "rose-pine" --"onedark"
	vim.cmd.colorscheme(color)
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "TreeSitterContext", { bg = "none" })
	vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { bg = "none" })
	vim.api.nvim_set_hl(0, "TreesitterContextBottom", { bg = "none" })
	vim.api.nvim_set_hl(0, "TroubleNormal", { bg = "none" })
	vim.api.nvim_set_hl(0, "TroubleCount", { bg = "none" })
	vim.api.nvim_set_hl(0, "ToubleText", { bg = "none" })
	vim.api.nvim_set_hl(0, "TreesitterContextBottom", { bg = "none" })
end

return {
	{
		"rose-pine/neovim",
		name = "rose-pine",
		priority = 1000, -- Make sure to load this before all the other start plugins.
		config = function()
			require("rose-pine").setup({
				variant = "auto", -- auto, main, moon, or dawn
				dark_variant = "main", -- main, moon, or dawn
				dim_inactive_windows = false,
				extend_background_behind_borders = true,

				enable = {
					terminal = false,
					legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
					migrations = true, -- Handle deprecated options automatically
				},

				styles = {
					bold = true,
					italic = true,
					transparency = true,
				},

				groups = {
					border = "muted",
					link = "iris",
					panel = "surface",

					error = "love",
					hint = "iris",
					info = "foam",
					note = "pine",
					todo = "rose",
					warn = "gold",

					git_add = "foam",
					git_change = "rose",
					git_delete = "love",
					git_dirty = "rose",
					git_ignore = "muted",
					git_merge = "iris",
					git_rename = "pine",
					git_stage = "iris",
					git_text = "rose",
					git_untracked = "subtle",

					h1 = "iris",
					h2 = "foam",
					h3 = "rose",
					h4 = "gold",
					h5 = "pine",
					h6 = "foam",
				},

				highlight_groups = {
					-- Comment = { fg = "foam" },
					-- VertSplit = { fg = "muted", bg = "muted" },
					-- Normal = { fg = "base", bg = "none" },
					-- NormalFloat = { fg = "base", bg = "none" },
				},

				before_highlight = function(group, highlight, palette)
					-- P(group)
					-- P(highlight)
					-- P(palette)
					-- Disable all undercurls
					-- if highlight.undercurl then
					--     highlight.undercurl = false
					-- end
					--
					-- Change palette colour
					-- if highlight.fg == palette.pine then
					--     highlight.fg = palette.foam
					-- end
				end,
			})

			-- ColorMyPencils("rose-pine")
			-- vim.cmd("colorscheme rose-pine-main")
			-- vim.cmd("colorscheme rose-pine-moon")
			-- vim.cmd("colorscheme rose-pine-dawn")
		end,
	},
	{
		"olimorris/onedarkpro.nvim",
		priority = 1000, -- Make sure to load this before all the other start plugins.
		config = function()
			require("onedarkpro").setup({
				options = {
					transparency = true,
					terminal_colors = false,
				},
			})
			-- ColorMyPencils('onedark')
		end,
	},
	{
		"folke/tokyonight.nvim",
		priority = 1000, -- Make sure to load this before all the other start plugins.
		config = function()
			require("tokyonight").setup({
				transparent = true,
				styles = {
					sidebars = "transparent",
					floats = "transparent",
				},
			})

			-- ColorMyPencils('tokyonight')
		end,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		config = function()
			require("catppuccin").setup({
				flavour = "auto", -- latte, frappe, macchiato, mocha
				background = { -- :h background
					light = "latte",
					dark = "mocha",
				},
				transparent_background = true, -- disables setting the background color.
				show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
				term_colors = true, -- sets terminal colors (e.g. `g:terminal_color_0`)
				dim_inactive = {
					enabled = true, -- dims the background color of inactive window
					shade = "dark",
					percentage = 0.15, -- percentage of the shade to apply to the inactive window
				},
				no_italic = false, -- Force no italic
				no_bold = false, -- Force no bold
				no_underline = false, -- Force no underline
				styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
					comments = { "italic" }, -- Change the style of comments
					conditionals = { "italic" },
					loops = {},
					functions = {},
					keywords = {},
					strings = {},
					variables = {},
					numbers = {},
					booleans = {},
					properties = {},
					types = {},
					operators = {},
					-- miscs = {}, -- Uncomment to turn off hard-coded styles
				},
				color_overrides = {},
				custom_highlights = {},
				default_integrations = true,
				integrations = {
					cmp = true,
					gitsigns = true,
					rainbow_delimiters = true,
					treesitter = true,
					notify = true,
					treesitter_context = true,
					dashboard = true,
					diffview = true,
					fidget = true,
					harpoon = true,
					indent_blankline = {
						enabled = true,
						colored_indent_levels = true,
					},
					mason = true,
					neogit = true,
					noice = true,
					dap = true,
					dap_ui = true,
					ufo = true,
					leap = true,
					-- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
				},
			})

			local pmenuSel_highlight = vim.api.nvim_get_hl(0, {
				name = "TreesitterContextBottom",
			})
			P(pmenuSel_highlight)
			-- setup must be called before loading
			-- vim.cmd.colorscheme("catppuccin")
			ColorMyPencils("catppuccin")
		end,
	},
}
