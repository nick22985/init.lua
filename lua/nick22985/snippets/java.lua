local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local f = ls.function_node

local function git(dir, args)
	local cmd = { "git", "-C", dir }
	vim.list_extend(cmd, args)
	local out = vim.fn.systemlist(cmd)
	if vim.v.shell_error ~= 0 or not out[1] or out[1] == "" then
		return nil
	end
	return out[1]
end

local function is_ancestor(directory, path)
	directory = vim.fs.normalize(directory)
	path = vim.fs.normalize(path)
	return path == directory or vim.startswith(path, directory .. "/")
end

local function non_git_root(dir)
	local buffer_name = vim.api.nvim_buf_get_name(0)
	local best_workspace

	for _, workspace in ipairs(vim.lsp.buf.list_workspace_folders()) do
		if is_ancestor(workspace, buffer_name) and (not best_workspace or #workspace > #best_workspace) then
			best_workspace = workspace
		end
	end

	if best_workspace then
		return best_workspace
	end

	local cwd = vim.uv.cwd()
	if cwd and is_ancestor(cwd, dir) then
		return cwd
	end

	return dir
end

local function project_name()
	local dir = vim.fn.expand("%:p:h")
	if dir == "" then
		dir = vim.fn.getcwd()
	end

	local top_level = git(dir, { "rev-parse", "--path-format=absolute", "--show-toplevel" })
	local git_dir = git(dir, { "rev-parse", "--path-format=absolute", "--git-dir" })
	local common = git(dir, { "rev-parse", "--path-format=absolute", "--git-common-dir" })
	if top_level then
		if git_dir and common and git_dir ~= common then
			if vim.fs.basename(common) == ".git" or vim.fs.basename(common) == ".bare" then
				return vim.fs.basename(vim.fs.dirname(common))
			end
			return vim.fs.basename(common)
		end

		return vim.fs.basename(top_level)
	end

	return vim.fs.basename(non_git_root(dir))
end

ls.add_snippets("java", {
	s("@author", {
		t({ "/**", " * @author nick22985 Created on " }),
		f(function()
			return os.date("%m/%d/%y")
		end),
		t(" for "),
		f(project_name),
		t({ "", " */" }),
	}),
})
