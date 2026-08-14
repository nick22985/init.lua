local term = vim.env.TERM or ""

if vim.env.SBX_PROJECT_DIR then
	vim.env.SNACKS_SSH = "true"
end

if vim.env.SBX_PROJECT_DIR and not vim.env.TMUX and (term:match("^screen") or term:match("^tmux")) then
	vim.env.TMUX = "sbx"
end

return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		event = "BufReadPre",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" },
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' },
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {
			code = { disable = { "mermaid" } },
		},
	},
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		config = function(_, opts)
			local terminal = require("snacks.image.terminal")
			local terminal_size = terminal.size

			terminal.size = function()
				local size = terminal_size()
				if size.width > 0 and size.height > 0 and size.cell_width > 0 and size.cell_height > 0 then
					return size
				end

				local cell_width, cell_height = 9, 18
				return {
					width = vim.o.columns * cell_width,
					height = vim.o.lines * cell_height,
					columns = vim.o.columns,
					rows = vim.o.lines,
					cell_width = cell_width,
					cell_height = cell_height,
					scale = cell_width / 8,
				}
			end

			require("snacks").setup(opts)
		end,
		---@type snacks.Config
		opts = {
			image = {
				enabled = true,
				convert = {
					notify = true,
					mermaid = function()
						local theme = vim.o.background == "light" and "neutral" or "dark"
						local args = {
							"-i",
							"{src}",
							"-o",
							"{file}",
							"-b",
							"transparent",
							"-t",
							theme,
							"-s",
							"{scale}",
						}
						local puppeteer_config = "/etc/sbx-puppeteer.json"
						if vim.fn.filereadable(puppeteer_config) == 1 then
							vim.list_extend(args, { "-p", puppeteer_config })
						end
						return args
					end,
				},
				doc = {
					enabled = true,
					inline = true,
					float = true,
				},
			},
		},
	},
}
