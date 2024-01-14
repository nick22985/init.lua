return {
	'nvim-telescope/telescope.nvim',
	dependencies = {
		'nvim-telescope/telescope-file-browser.nvim',
		'nvim-telescope/telescope-hop.nvim', -- NEEDS SETUP
		'nvim-telescope/telescope-ui-select.nvim',
		'nvim-lua/plenary.nvim',
		{
			'nvim-telescope/telescope-fzf-native.nvim',
			build =
			'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
		}
	},
	config = function()
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
					hidden = true,
					-- Search for files using rg (searches for sys link files etc)
					find_command = { "rg", "--ignore", "--no-ignore", "-L", "--files", "--hidden", "--ignore-case" },
					file_ignore_patterns = {
						"node_modules/",
						"dist/",
						"build/",
						".git/"
					}
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
		telescope.load_extension('harpoon')
		telescope.load_extension("git_worktree")


		local builtin = require('telescope.builtin')
		vim.keymap.set('n', '<leader>fw', builtin.git_files, {})
		vim.keymap.set("n", "<leader>fr", builtin.oldfiles, {})
		vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
		vim.keymap.set("n", "<leader>fe", "<cmd>Telescope file_browser<cr>")
		vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
		-- Needs ripgrep https://github.com/BurntSushi/ripgrep#installation
		vim.keymap.set("n", "<leader>fg", "<CMD>Telescope live_grep<CR>")
		vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
		vim.keymap.set("n", "<leader>fk", builtin.keymaps, {})
		vim.keymap.set('n', '<leader>hm', "<cmd>Telescope harpoon marks<cr>")
		vim.keymap.set("n", "<leader>fs", builtin.current_buffer_fuzzy_find, {})
		vim.keymap.set("n", "<leader>ws", "<cmd>Telescope git_worktree git_worktree<cr>")
		vim.keymap.set("n", "<leader>wc", "<cmd>Telescope git_worktree create_git_worktree<cr>")
	end
}
