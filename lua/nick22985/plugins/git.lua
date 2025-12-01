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

			neogit.setup({})
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
				local branch = vim.fn.system("git branch --show-current"):gsub("\n", "")
				if branch ~= "" then
					local upstream = vim.fn.system("git rev-parse --abbrev-ref @{u} 2>/dev/null"):gsub("\n", "")
					if upstream == "" then
						vim.fn.system("git branch --set-upstream-to=origin/" .. branch .. " " .. branch)
					end
				end
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
