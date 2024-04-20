return {
	'nvim-telescope/telescope.nvim',
	build = 'make',
	cond = function()
		return vim.fn.executable 'make' == 1
	end,
	dependencies = {
		'nvim-telescope/telescope-file-browser.nvim',
		'nvim-telescope/telescope-hop.nvim', -- NEEDS SETUP
		'nvim-telescope/telescope-ui-select.nvim',
		{ 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
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
				},
				['ui-select'] = {
					require('telescope.themes').get_dropdown(),
				},
			},
		}
		pcall(require('telescope').load_extension, 'fzf')
		pcall(require('telescope').load_extension, 'ui-select')
		telescope.load_extension("file_browser")
		telescope.load_extension("harpoon")
		-- telescope.load_extension("git_wortree")


		local builtin = require('telescope.builtin')
		vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
		vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
		vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
		vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
		vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
		vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
		vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
		vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
		vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
		vim.keymap.set('n', '<leader>sb', builtin.buffers, { desc = '[ ] Find existing buffers' })

		-- Slightly advanced example of overriding default behavior and theme
		vim.keymap.set('n', '<leader>/', function()
			-- You can pass additional configuration to Telescope to change the theme, layout, etc.
			builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
				winblend = 10,
				previewer = false,
			})
		end, { desc = '[/] Fuzzily search in current buffer' })

		-- It's also possible to pass additional configuration options.
		--  See `:help telescope.builtin.live_grep()` for information about particular keys
		vim.keymap.set('n', '<leader>s/', function()
			builtin.live_grep {
				grep_open_files = true,
				prompt_title = 'Live Grep in Open Files',
			}
		end, { desc = '[S]earch [/] in Open Files' })

		-- Shortcut for searching your Neovim configuration files
		vim.keymap.set('n', '<leader>sn', function()
			builtin.find_files { cwd = vim.fn.stdpath 'config' }
		end, { desc = '[S]earch [N]eovim files' })

		-- vim.keymap.set('n', '<leader>fw', builtin.git_files, {})
		-- vim.keymap.set("n", "<leader>fr", builtin.oldfiles, {})
		-- vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
		-- vim.keymap.set("n", "<leader>fe", "<cmd>Telescope file_browser<cr>")
		-- vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
		-- -- Needs ripgrep https://github.com/BurntSushi/ripgrep#installation
		-- vim.keymap.set("n", "<leader>fg", "<CMD>Telescope live_grep<CR>")
		-- vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
		-- vim.keymap.set("n", "<leader>fk", builtin.keymaps, {})
		-- vim.keymap.set('n', '<leader>hm', "<cmd>Telescope harpoon marks<cr>")
		-- vim.keymap.set("n", "<leader>fs", builtin.current_buffer_fuzzy_find, {})
		-- vim.keymap.set("n", "<leader>ws", "<cmd>Telescope git_worktree git_worktree<cr>")
		-- vim.keymap.set("n", "<leader>wc", "<cmd>Telescope git_worktree create_git_worktree<cr>")
	end
}
