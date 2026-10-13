local M = {}

local function git(args, cwd)
	local result = vim.system(vim.list_extend({ "git" }, args), { cwd = cwd, text = true }):wait()
	if result.code ~= 0 then
		return nil
	end
	return vim.trim(result.stdout)
end

local function worktree_path(number)
	local common_dir = git({ "rev-parse", "--path-format=absolute", "--git-common-dir" })
	if not common_dir then
		return nil
	end
	if vim.fs.basename(common_dir) ~= ".git" then
		return vim.fs.joinpath(common_dir, "pr-" .. number)
	end
	local toplevel = vim.fs.dirname(common_dir)
	return toplevel .. "-pr-" .. number
end

local function start_review(path)
	require("git-worktree").switch_worktree(path)
	vim.schedule(function()
		vim.cmd("Octo review start")
	end)
end

function M.open(number)
	local path = worktree_path(number)
	if not path then
		vim.notify("Not in a git repository", vim.log.levels.ERROR)
		return
	end

	if not vim.uv.fs_stat(path) and not git({ "worktree", "add", "--detach", path }) then
		vim.notify("Failed to create worktree at " .. path, vim.log.levels.ERROR)
		return
	end

	vim.notify("Checking out PR #" .. number .. " in " .. path)
	vim.system(
		{ "gh", "pr", "checkout", tostring(number), "--branch", "pr-" .. number, "--force" },
		{ cwd = path, text = true },
		function(result)
			vim.schedule(function()
				if result.code ~= 0 then
					vim.notify("gh pr checkout failed: " .. vim.trim(result.stderr), vim.log.levels.ERROR)
					return
				end
				start_review(path)
			end)
		end
	)
end

function M.pick()
	vim.system({ "gh", "pr", "list", "--json", "number,title,author" }, { text = true }, function(result)
		vim.schedule(function()
			if result.code ~= 0 then
				vim.notify("gh pr list failed: " .. vim.trim(result.stderr), vim.log.levels.ERROR)
				return
			end
			local prs = vim.json.decode(result.stdout)
			if #prs == 0 then
				vim.notify("No open PRs")
				return
			end
			vim.ui.select(prs, {
				prompt = "Review PR",
				format_item = function(pr)
					return string.format("#%d %s (%s)", pr.number, pr.title, pr.author.login)
				end,
			}, function(pr)
				if pr then
					M.open(pr.number)
				end
			end)
		end)
	end)
end

function M.remove(number)
	if not number then
		vim.notify("Usage: :PRReviewRemove <number>", vim.log.levels.ERROR)
		return
	end
	local path = worktree_path(number)
	if not path or not vim.uv.fs_stat(path) then
		vim.notify("No worktree for PR #" .. number, vim.log.levels.WARN)
		return
	end
	if vim.startswith(vim.uv.cwd(), path) then
		vim.notify("Switch out of the PR worktree before removing it", vim.log.levels.WARN)
		return
	end
	if not git({ "worktree", "remove", "--force", path }) then
		vim.notify("Failed to remove worktree at " .. path, vim.log.levels.ERROR)
		return
	end
	git({ "branch", "-D", "pr-" .. number })
	vim.notify("Removed PR #" .. number .. " worktree")
end

return M
