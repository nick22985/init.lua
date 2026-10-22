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
		keys = {
			{
				"<leader>gs",
				function()
					-- Neogit only sees local repos; in oil-ssh buffers use a git UI on the remote
					local ctx = require("nick22985.remote-telescope").context()
					if ctx then
						return require("nick22985.remote-git").open(ctx)
					end
					require("neogit").open()
				end,
				desc = "[G]it [S]tatus (local or remote)",
			},
		},
		dependencies = {
			"nvim-lua/plenary.nvim", -- required
			"nvim-telescope/telescope.nvim", -- optional
			"sindrets/diffview.nvim", -- optional
			"ibhagwan/fzf-lua", -- optional
			{
				"m00qek/baleia.nvim",
				config = function()
					vim.g.baleia = require("baleia").setup({})
				end,
			},
		},
		config = function()
			local neogit = require("neogit")

			local opts = {}

			neogit.setup(opts)
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
			local git_worktree = require("git-worktree")
			local create_worktree = git_worktree.create_worktree
			git_worktree.create_worktree = function(path, branch, upstream)
				if path and not vim.startswith(path, "/") then
					local common_dir = vim.fn.systemlist({
						"git",
						"rev-parse",
						"--path-format=absolute",
						"--git-common-dir",
					})[1]

					if vim.v.shell_error == 0 and common_dir and vim.fs.basename(common_dir) == ".bare" then
						path = vim.fs.joinpath(vim.fs.dirname(common_dir), vim.fs.basename(path))
					elseif vim.v.shell_error == 0 and common_dir and vim.fs.basename(common_dir) ~= ".git" then
						path = vim.fs.joinpath(common_dir, vim.fs.basename(path))
					end
				end

				return create_worktree(path, branch, upstream)
			end

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
	{
		"pwntester/octo.nvim",
		cmd = "Octo",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		init = function()
			local pr_review = require("nick22985.utils.pr-review")
			vim.api.nvim_create_user_command("PRReview", function(args)
				if args.args == "" then
					pr_review.pick()
				elseif tonumber(args.args) then
					pr_review.open(tonumber(args.args))
				else
					vim.notify("Usage: :PRReview [number]", vim.log.levels.ERROR)
				end
			end, { nargs = "?" })
			vim.api.nvim_create_user_command("PRReviewRemove", function(args)
				pr_review.remove(tonumber(args.args))
			end, { nargs = 1 })
		end,
		opts = {
			picker = "telescope",
			enable_builtin = true,
			use_local_fs = true,
		},
	},
	{
		"ldelossa/gh.nvim",
		dependencies = {
			{
				"ldelossa/litee.nvim",
				config = function()
					require("litee.lib").setup()
				end,
			},
		},
		config = function()
			require("litee.gh").setup()
		end,
	},
}
