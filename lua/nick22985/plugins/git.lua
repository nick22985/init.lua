return {
	{
		"akinsho/git-conflict.nvim",
		event = "BufReadPre",
		version = "*",
		config = true,
	},
	{
		"ruifm/gitlinker.nvim",
		requires = "nvim-lua/plenary.nvim",
		event = "BufReadPre",
		config = function()
			require("gitlinker").setup({
				opts = {
					remote = nil, -- force the use of a specific remote
					-- adds current line nr in the url for normal mode
					add_current_line_on_normal_mode = true,
					-- callback for what to do with the url
					-- action_callback = function(url)
					-- 	P(url)
					-- 	-- local copyToClipBoard = j
					-- 	return require("gitlinker.actions").copy_to_clipboard(url)
					-- end,
					action_callback = require("gitlinker.actions").copy_to_clipboard, -- print the url after performing the action
					print_url = false,
				},
				callbacks = {
					-- ["github.com"] = require("gitlinker.hosts").get_github_type_url,
					-- ["github.com"] = function(test)
					-- 	P(test)
					-- 	return require("gitlinker.hosts").get_github_type_url(test)
					-- end,
					["gitlab.com"] = require("gitlinker.hosts").get_gitlab_type_url,
					["try.gitea.io"] = require("gitlinker.hosts").get_gitea_type_url,
					["codeberg.org"] = require("gitlinker.hosts").get_gitea_type_url,
					["bitbucket.org"] = require("gitlinker.hosts").get_bitbucket_type_url,
					["try.gogs.io"] = require("gitlinker.hosts").get_gogs_type_url,
					["git.sr.ht"] = require("gitlinker.hosts").get_srht_type_url,
					["git.launchpad.net"] = require("gitlinker.hosts").get_launchpad_type_url,
					["repo.or.cz"] = require("gitlinker.hosts").get_repoorcz_type_url,
					["git.kernel.org"] = require("gitlinker.hosts").get_cgit_type_url,
					["git.savannah.gnu.org"] = require("gitlinker.hosts").get_cgit_type_url,
				},
				-- default mapping to call url generation with action_callback
				mappings = "<leader>gy",
			})
		end,
	},
	{
		"NeogitOrg/neogit",
		branch = "master",
		event = "BufReadPre",
		dependencies = {
			"nvim-lua/plenary.nvim", -- required
			"nvim-telescope/telescope.nvim", -- optional
			"sindrets/diffview.nvim", -- optional
			"ibhagwan/fzf-lua", -- optional
		},
		config = function()
			local neogit = require("neogit")

			neogit.setup({
				-- Hides the hints at the top of the status buffer
				disable_hint = false,
				-- Disables changing the buffer highlights based on where the cursor is.
				disable_context_highlighting = false,
				-- Disables signs for sections/items/hunks
				disable_signs = false,
				-- Changes what mode the Commit Editor starts in. `true` will leave nvim in normal mode, `false` will change nvim to
				-- insert mode, and `"auto"` will change nvim to insert mode IF the commit message is empty, otherwise leaving it in
				-- normal mode.
				disable_insert_on_commit = true,
				-- When enabled, will watch the `.git/` directory for changes and refresh the status buffer in response to filesystem
				-- events.
				filewatcher = {
					interval = 1000,
					enabled = true,
				},
				-- "ascii"   is the graph the git CLI generates
				-- "unicode" is the graph like https://github.com/rbong/vim-flog
				graph_style = "ascii",
				-- Used to generate URL's for branch popup action "pull request".
				git_services = {
					["github.com"] = "https://github.com/${owner}/${repository}/compare/${branch_name}?expand=1",
					["bitbucket.org"] = "https://bitbucket.org/${owner}/${repository}/pull-requests/new?source=${branch_name}&t=1",
					["gitlab.com"] = "https://gitlab.com/${owner}/${repository}/merge_requests/new?merge_request[source_branch]=${branch_name}",
				},
				-- Allows a different telescope sorter. Defaults to 'fuzzy_with_index_bias'. The example below will use the native fzf
				-- sorter instead. By default, this function returns `nil`.
				telescope_sorter = function()
					return require("telescope").extensions.fzf.native_fzf_sorter()
				end,
				-- Persist the values of switches/options within and across sessions
				remember_settings = true,
				-- Scope persisted settings on a per-project basis
				use_per_project_settings = true,
				-- Table of settings to never persist. Uses format "Filetype--cli-value"
				ignored_settings = {
					"NeogitPushPopup--force-with-lease",
					"NeogitPushPopup--force",
					"NeogitPullPopup--rebase",
					"NeogitCommitPopup--allow-empty",
					"NeogitRevertPopup--no-edit",
				},
				-- Set to false if you want to be responsible for creating _ALL_ keymappings
				use_default_keymaps = true,
				-- Neogit refreshes its internal state after specific events, which can be expensive depending on the repository size.
				-- Disabling `auto_refresh` will make it so you have to manually refresh the status after you open it.
				auto_refresh = true,
				-- Value used for `--sort` option for `git branch` command
				-- By default, branches will be sorted by commit date descending
				-- Flag description: https://git-scm.com/docs/git-branch#Documentation/git-branch.txt---sortltkeygt
				-- Sorting keys: https://git-scm.com/docs/git-for-each-ref#_options
				sort_branches = "-committerdate",
				-- Change the default way of opening neogit
				kind = "tab",
				-- Disable line numbers and relative line numbers
				disable_line_numbers = false,
				-- The time after which an output console is shown for slow running commands
				console_timeout = 2000,
				-- Automatically show console if a command takes more than console_timeout milliseconds
				auto_show_console = true,
				status = {
					recent_commit_count = 10,
				},
				commit_editor = {
					kind = "tab",
				},
				commit_select_view = {
					kind = "tab",
				},
				commit_view = {
					kind = "vsplit",
					verify_commit = true, -- Can be set to true or false, otherwise we try to find the binary
				},
				log_view = {
					kind = "tab",
				},
				rebase_editor = {
					kind = "auto",
				},
				reflog_view = {
					kind = "tab",
				},
				merge_editor = {
					kind = "auto",
				},
				tag_editor = {
					kind = "auto",
				},
				preview_buffer = {
					kind = "floating",
				},
				popup = {
					kind = "split",
				},
				signs = {
					-- { CLOSED, OPENED }
					hunk = { "", "" },
					item = { "", "" },
					section = { "", "" },
				},
				-- Each Integration is auto-detected through plugin presence, however, it can be disabled by setting to `false`
				integrations = {
					-- If enabled, use telescope for menu selection rather than vim.ui.select.
					-- Allows multi-select and some things that vim.ui.select doesn't.
					telescope = true,
					-- Neogit only provides inline diffs. If you want a more traditional way to look at diffs, you can use `diffview`.
					-- The diffview integration enables the diff popup.
					--
					-- Requires you to have `sindrets/diffview.nvim` installed.
					diffview = true,

					-- If enabled, uses fzf-lua for menu selection. If the telescope integration
					-- is also selected then telescope is used instead
					-- Requires you to have `ibhagwan/fzf-lua` installed.
					fzf_lua = true,
				},
				sections = {
					-- Reverting/Cherry Picking
					sequencer = {
						folded = false,
						hidden = false,
					},
					untracked = {
						folded = false,
						hidden = false,
					},
					unstaged = {
						folded = false,
						hidden = false,
					},
					staged = {
						folded = false,
						hidden = false,
					},
					stashes = {
						folded = true,
						hidden = false,
					},
					unpulled_upstream = {
						folded = true,
						hidden = false,
					},
					unmerged_upstream = {
						folded = false,
						hidden = false,
					},
					unpulled_pushRemote = {
						folded = true,
						hidden = false,
					},
					unmerged_pushRemote = {
						folded = false,
						hidden = false,
					},
					recent = {
						folded = true,
						hidden = false,
					},
					rebase = {
						folded = true,
						hidden = false,
					},
				},
				mappings = {
					commit_editor = {
						["q"] = "Close",
						["<c-c><c-c>"] = "Submit",
						["<c-c><c-k>"] = "Abort",
					},
					rebase_editor = {
						["p"] = "Pick",
						["r"] = "Reword",
						["e"] = "Edit",
						["s"] = "Squash",
						["f"] = "Fixup",
						["x"] = "Execute",
						["d"] = "Drop",
						["b"] = "Break",
						["q"] = "Close",
						["<cr>"] = "OpenCommit",
						["gk"] = "MoveUp",
						["gj"] = "MoveDown",
						["<c-c><c-c>"] = "Submit",
						["<c-c><c-k>"] = "Abort",
					},
					finder = {
						["<cr>"] = "Select",
						["<c-c>"] = "Close",
						["<esc>"] = "Close",
						["<c-n>"] = "Next",
						["<c-p>"] = "Previous",
						["<down>"] = "Next",
						["<up>"] = "Previous",
						["<tab>"] = "MultiselectToggleNext",
						["<s-tab>"] = "MultiselectTogglePrevious",
						["<c-j>"] = "NOP",
					},
					-- Setting any of these to `false` will disable the mapping.
					popup = {
						["?"] = "HelpPopup",
						["A"] = "CherryPickPopup",
						["D"] = "DiffPopup",
						["M"] = "RemotePopup",
						["P"] = "PushPopup",
						["X"] = "ResetPopup",
						["Z"] = "StashPopup",
						["b"] = "BranchPopup",
						["c"] = "CommitPopup",
						["f"] = "FetchPopup",
						["l"] = "LogPopup",
						["m"] = "MergePopup",
						["p"] = "PullPopup",
						["r"] = "RebasePopup",
						["v"] = "RevertPopup",
					},
					status = {
						["q"] = "Close",
						["I"] = "InitRepo",
						["1"] = "Depth1",
						["2"] = "Depth2",
						["3"] = "Depth3",
						["4"] = "Depth4",
						["<tab>"] = "Toggle",
						["x"] = "Discard",
						["s"] = "Stage",
						["S"] = "StageUnstaged",
						["<c-s>"] = "StageAll",
						["u"] = "Unstage",
						["U"] = "UnstageStaged",
						["$"] = "CommandHistory",
						["Y"] = "YankSelected",
						["<c-r>"] = "RefreshBuffer",
						["<enter>"] = "GoToFile",
						["<c-v>"] = "VSplitOpen",
						["<c-x>"] = "SplitOpen",
						["<c-t>"] = "TabOpen",
						["{"] = "GoToPreviousHunkHeader",
						["}"] = "GoToNextHunkHeader",
					},
				},
			})
			vim.keymap.set("n", "<leader>gs", neogit.open)
		end,
	},
	{
		"polarmutex/git-worktree.nvim",
		version = "^2",
		event = "BufReadPre",
		config = function()
			vim.g.git_worktree = {
				change_directory_command = "cd",
				update_on_change = true,
				update_on_change_command = "e .",
				clearjumps_on_change = true,
				confirm_telescope_deletions = true,
				autopush = false,
			}
			local Hooks = require("git-worktree.hooks")
			local function on_tree_switch(op, path)
				-- vim.cmd("%bd|e#")
			end

			Hooks.register(Hooks.type.SWITCH, Hooks.builtins.update_current_buffer_on_switch)
			Hooks.register(Hooks.type.SWITCH, on_tree_switch)
			-- local Worktree = require("git-worktree")
			--
			-- local HOME = os.getenv("HOME")
			--
			-- local function resolve_home_directory(path)
			-- 	if HOME and path:sub(1, 1) == "~" then
			-- 		return HOME .. path:sub(2)
			-- 	else
			-- 		return path
			-- 	end
			-- end
			--
			-- local function read_project_paths(file)
			-- 	file = resolve_home_directory(file)
			-- 	local f, err = io.open(file, "r")
			-- 	if not f then
			-- 		print("Error opening file:", err)
			-- 		return {}
			-- 	end
			--
			-- 	local patterns = {}
			-- 	for line in f:lines() do
			-- 		table.insert(patterns, line)
			-- 	end
			-- 	f:close()
			-- 	return patterns
			-- end
			--
			-- local function path_matches_any_pattern(path, patterns)
			-- 	for _, pattern in ipairs(patterns) do
			-- 		if path:find(pattern, 1, true) then
			-- 			return pattern
			-- 		end
			-- 	end
			-- 	return nil
			-- end
			--
			-- local function extract_basename_from_pattern(pattern)
			-- 	return pattern:match("^.+/(.+)/?$")
			-- end
			--
			-- local function on_tree_change(op, path, upstream)
			-- 	if op == "switch" then
			-- 		local project_paths =
			-- 			read_project_paths("~/.config/.nickInstall//install/configs/private/.tmux-commands.txt")
			-- 		local current_path = path.path
			-- 		local prev_path = path.prev_path
			--
			-- 		local matched_pattern = path_matches_any_pattern(current_path, project_paths)
			-- 			or path_matches_any_pattern(prev_path, project_paths)
			-- 		if not current_path:find("/") then
			-- 			current_path = matched_pattern .. "/" .. current_path
			-- 		end
			-- 		if matched_pattern then
			-- 			local basename = extract_basename_from_pattern(matched_pattern)
			--
			-- 			local command = string.format(":silent !tmux-run tmux %s %s", basename, current_path)
			-- 			vim.cmd(command)
			-- 		end
			-- 	end
			-- end
			--
			-- Worktree.on_tree_change(on_tree_change)
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		event = "BufReadPre",
		config = function()
			require("gitsigns").setup({
				signs = {
					add = { text = "│" },
					change = { text = "│" },
					delete = { text = "_" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
					untracked = { text = "┆" },
				},
				signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
				numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
				linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
				word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
				watch_gitdir = {
					interval = 1000,
					follow_files = true,
				},
				attach_to_untracked = true,
				current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
				current_line_blame_opts = {
					virt_text = true,
					virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
					delay = 1000,
					ignore_whitespace = false,
				},
				current_line_blame_formatter = "󰜘 <author>, <abbrev_sha> <author_time:%Y-%m-%d> - <summary>",
				sign_priority = 6,
				update_debounce = 100,
				status_formatter = nil, -- Use default
				max_file_length = 40000, -- Disable if file is longer than this (in lines)
				preview_config = {
					-- Options passed to nvim_open_win
					border = "single",
					style = "minimal",
					relative = "cursor",
					row = 0,
					col = 1,
				},
			})
		end,
	},
}
