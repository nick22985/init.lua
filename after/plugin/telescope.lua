local status, telescope = pcall(require, "telescope")
if not status then
	return
end



telescope.setup {
	defaults = {
		path_display = { "smart" },
	},
	pickers = {
		find_files = {
			-- Search for files using rg (searches for sys link files etc)
			find_command = { "rg", "--ignore", "-L", "--files", "--hidden" },
		}
	},
	extensions = {
		file_browser = {
			--theme = "ivy",
			-- disables netrw and use telescope-file-browser in its place
			hijack_netrw = false,
			-- mappings = {
			--   ["i"] = {
			--     -- your custom insert mode mappings
			--   },
			--   ["n"] = {
			--     -- your custom normal mode mappings
			--   },
			-- },
		},
		fzf = {
			fuzzy = true,
			override_generic_sorter = false,
			case_mode = "smart_case",
		}
	},
}

telescope.load_extension('fzf')
telescope.load_extension("file_browser")
telescope.load_extension("harpoon")
telescope.load_extension('projects')
telescope.load_extension('harpoon')

-- telescope.extensions.project.project{ display_type = 'full' }

local builtin = require('telescope.builtin')
-- vim.keymap.set('n', '<C-p>', builtin.git_files, {}) -- laggy use ff
vim.keymap.set('n', '<C-p>', "<cmd>Telescope projects<cr>")
vim.keymap.set("n", "<leader>fr", builtin.oldfiles, {})
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fe", "<cmd>Telescope file_browser<cr>")
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
-- Needs ripgrep https://github.com/BurntSushi/ripgrep#installation
vim.keymap.set("n", "<leader>fg", "<CMD>Telescope live_grep<CR>")
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set("n", "<leader>fc", builtin.keymaps, {})
-- vim.keymap.set("n", "<leader>fs", builtin.buffers, {})
vim.keymap.set('n', '<leader>hm', "<cmd>Telescope harpoon marks<cr>")
