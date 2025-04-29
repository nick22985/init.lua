-- https://github.com/sharkdp/fd
-- https://github.com/BurntSushi/ripgrep
local opts = {}
return {
	"nvim-telescope/telescope.nvim",
	event = "UIEnter",
	build = "make",
	cond = function()
		return vim.fn.executable("make") == 1
	end,
	dependencies = {
		"nvim-telescope/telescope-file-browser.nvim",
		"nvim-telescope/telescope-hop.nvim", -- NEEDS SETUP
		"nvim-telescope/telescope-ui-select.nvim",
		"polarmutex/git-worktree.nvim",
		{ "danielvolchek/tailiscope.nvim" },
		{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
		},
	},
	keys = {
		{ mode = "n", "<leader>sh", "<cmd>Telescope help_tags<CR>", { desc = "[S]earch [H]elp" } },
		{ mode = "n", "<leader>sk", "<cmd>Telescope keymaps<CR>", { desc = "[S]earch [K]eymaps" } },
		{ mode = "n", "<leader>sf", "<cmd>Telescope find_files<CR>", { desc = "[S]earch [F]iles" } },
		{ mode = "n", "<leader>ss", "<cmd>Telescope builtin<CR>", { desc = "[S]Earch [S]elect Telescope" } },
		{ mode = "n", "<leader>sw", "<cmd>Telescope grep_string<CR>", { desc = "[S]earch current [W]ord" } },
		{ mode = "n", "<leader>sg", "<cmd>Telescope live_grep<CR>", { desc = "[S]earch by [G]rep" } },
		{ mode = "n", "<leader>sd", "<cmd>Telescope diagnostics<CR>", { desc = "[S]earch [D]iagnostics" } },
		{ mode = "n", "<leader>sr", "<cmd>Telescope resume<CR>", { desc = "[S]earch [R]esume" } },
		{ mode = "n", "<leader>st", "<cmd>TodoTelescope<CR>", { desc = "[S]earch [R]esume" } },
		{
			mode = "n",
			"<leader>s.",
			"<cmd>Telescope oldfiles<CR>",
			{ desc = '[S]earch Recent Files ("." for repeat)' },
		},
		{
			mode = "n",
			"<leader>sb",
			function()
				require("telescope.builtin").buffers(require("telescope.themes").get_dropdown(opts))
			end,

			{ desc = "[S]earch existing [B]uffers" },
		},
		{ mode = "n", "<leader>sc", "<cmd>Telescope neoclip<CR>", { desc = "[S]earch [C]lipboard" } },
		-- Slightly advanced example of overriding default behavior and theme
		{
			mode = "n",
			"<leader>/",
			function()
				local builtin = require("telescope.builtin")
				-- You can pass additional configuration to Telescope to change the theme, layout, etc.
				builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
				}))
			end,
			{ desc = "[/] Fuzzily search in current buffer" },
		},
		-- It's also possible to pass additional configuration options.
		--  See `:help telescope.builtin.live_grep()` for information about particular keys
		{
			mode = "n",
			"<leader>s/",
			function()
				local builtin = require("telescope.builtin")
				builtin.live_grep({
					grep_open_files = true,
					prompt_title = "Live Grep in Open Files",
				})
			end,
			{ desc = "[S]earch [/] in Open Files" },
		},
		-- Shortcut for searching your Neovim configuration files
		{
			mode = "n",
			"<leader>sn",
			function()
				local builtin = require("telescope.builtin")
				builtin.find_files({ cwd = vim.fn.stdpath("config") })
			end,
			{ desc = "[S]earch [N]eovim files" },
		},
		-- Git
		{ mode = "n", "<leader>gc", "<cmd>Telescope git_commits<CR>", { desc = "[G]it [C]ommits" } },
		{ mode = "n", "<leader>gbc", "<cmd>Telescope git_bcommits_range<CR>", { desc = "[G]it [B]uffer [C]ommits" } },
		{ mode = "n", "<leader>gb", "<cmd>Telescope git_branches<CR>", { desc = "[G]it [B]ranches" } },
		{
			mode = "n",
			"<leader>gw",
			function()
				require("telescope").extensions.git_worktree.git_worktree()
			end,
			{ desc = "[g]it [w]orktree" },
		},
		{
			mode = "n",
			"<leader>cgw",
			function()
				require("telescope").extensions.git_worktree.create_git_worktree()
			end,
			{ desc = "[g]it [w]orktree" },
		},
		-- { mode = "n", "<leader>gs", "<cmd>Telescope git_status<CR>", { desc = "[G]it [S]tatus" } },
		-- { mode = "n", "<leader>gs", "<cmd>Telescope git_stash<CR>", { desc = "[G]it [ST]ash" } },
	},
	config = function()
		local status, telescope = pcall(require, "telescope")
		if not status then
			return
		end

		local action_state = require("telescope.actions.state")
		local actions = require("telescope.actions")
		opts.attach_mappings = function(prompt_bufnr, map)
			-- local delete_buf = function()
			-- 	local selection = action_state.get_selected_entry()
			-- 	actions.close(prompt_bufnr)
			-- 	vim.api.nvim_buf_delete(selection.bufnr, { force = true })
			-- end
			-- map("n", "d", delete_buf)
			return true
		end
		-- opts.previewer = false

		telescope.setup({
			defaults = {
				path_display = { "truncate" },
			},
			pickers = {
				find_files = {
					hidden = true,
					-- Search for files using rg (searches for sys link files etc)
					find_command = { "rg", "--files", "--no-ignore", "--hidden", "--glob", "!**/.git/*" },
					file_ignore_patterns = {
						"node_modules/",
						"dist/",
						"build/",
						".git/",
						".next/",
					},
				},
				live_grep = {
					additional_args = function(opts)
						return { "--hidden", "--glob", "!**/.git/*" }
					end,
					-- file_ignore_patterns = {
					-- 	"node_modules/",
					-- 	"dist/",
					-- 	"build/",
					-- 	".git/",
					-- 	".next/",
					-- 	"%.chunk.js",
					-- },
				},
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
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},
				["ui-select"] = {
					require("telescope.themes").get_dropdown(),
				},
			},
		})
		pcall(require("telescope").load_extension, "fzf")
		pcall(require("telescope").load_extension, "ui-select")
		telescope.load_extension("file_browser")
		telescope.load_extension("harpoon")
		require("telescope").load_extension("git_worktree")
	end,
}
