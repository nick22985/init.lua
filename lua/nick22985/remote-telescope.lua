local M = {}

local function shell_quote(value)
	value = tostring(value)
	return "'" .. value:gsub("'", "'\\''") .. "'"
end

local function remote_context(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	local bufname = vim.api.nvim_buf_get_name(bufnr)
	if not bufname:match("^oil%-ssh://") then
		return nil
	end

	local ok, url = pcall(require("oil.adapters.ssh").parse_url, bufname)
	if not ok then
		vim.notify("Could not parse remote Oil URL: " .. url, vim.log.levels.ERROR)
		return nil
	end

	local root = url.path
	if vim.bo[bufnr].filetype ~= "oil" then
		root = vim.fs.dirname(root)
	end
	if not root or root == "" then
		root = "."
	end

	local target = url.host
	if url.user then
		target = url.user .. "@" .. target
	end

	return {
		root = root,
		target = target,
		url = url,
	}
end

local function ssh_command(ctx, script)
	local control_path = vim.fn.stdpath("cache") .. "/telescope-ssh-%C"
	local command = {
		"ssh",
		"-o",
		"ControlMaster=auto",
		"-o",
		"ControlPersist=2m",
		"-o",
		"ControlPath=" .. control_path,
	}
	if ctx.url.port then
		vim.list_extend(command, { "-p", tostring(ctx.url.port) })
	end
	vim.list_extend(command, { ctx.target, script })
	return command
end

local function join_path(root, path)
	path = path:gsub("^%./", "")
	if root == "." or root == "" then
		return path
	elseif root == "/" then
		return "/" .. path
	end
	return root:gsub("/$", "") .. "/" .. path
end

local function remote_url(ctx, path)
	local authority = ctx.url.host
	if ctx.url.user then
		authority = ctx.url.user .. "@" .. authority
	end
	if ctx.url.port then
		authority = authority .. ":" .. ctx.url.port
	end
	return ctx.url.scheme .. authority .. "/" .. join_path(ctx.root, path)
end

local function previewer(ctx)
	local previewers = require("telescope.previewers")
	return previewers.new_termopen_previewer({
		title = "Remote Preview",
		dyn_title = function(_, entry)
			return ctx.target .. ":" .. entry.relative_path
		end,
		get_command = function(entry)
			local first = entry.lnum and math.max(1, entry.lnum - 100) or 1
			local last = entry.lnum and (entry.lnum + 100) or 300
			local line_range = first .. ":" .. last
			local highlight = entry.lnum and (" --highlight-line " .. entry.lnum) or ""
			local path = shell_quote(entry.remote_path)
			local script = table.concat({
				"if command -v bat >/dev/null 2>&1; then",
				"bat --color=always --style=numbers --line-range " .. line_range .. highlight .. " -- " .. path,
				"elif command -v batcat >/dev/null 2>&1; then",
				"batcat --color=always --style=numbers --line-range " .. line_range .. highlight .. " -- " .. path,
				"else",
				"nl -ba " .. path .. " | sed -n " .. shell_quote(first .. "," .. last .. "p"),
				"fi",
			}, "\n")
			return ssh_command(ctx, script)
		end,
	})
end

local function jump_to_entry(bufnr, entry)
	if not entry.lnum then
		return
	end

	local function jump()
		if not vim.api.nvim_buf_is_valid(bufnr) then
			return
		end
		local winid = vim.fn.bufwinid(bufnr)
		if winid == -1 then
			return
		end
		local line_count = vim.api.nvim_buf_line_count(bufnr)
		local line = math.min(entry.lnum, line_count)
		local col = math.max((entry.col or 1) - 1, 0)
		vim.api.nvim_win_set_cursor(winid, { line, col })
		vim.api.nvim_win_call(winid, function()
			vim.cmd("normal! zz")
		end)
	end

	if require("oil.loading").is_loading(bufnr) then
		vim.api.nvim_create_autocmd("BufReadPost", {
			buffer = bufnr,
			once = true,
			callback = vim.schedule_wrap(jump),
		})
	else
		jump()
	end
end

local function attach_open_mappings()
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")
	local oil_util = require("oil.util")

	local function replace(action, command)
		action:replace(function(prompt_bufnr)
			local entry = action_state.get_selected_entry()
			if not entry then
				return
			end
			actions.close(prompt_bufnr)
			vim.cmd[command]({ args = { oil_util.escape_filename(entry.remote_url) } })
			jump_to_entry(vim.api.nvim_get_current_buf(), entry)
		end)
	end

	replace(actions.select_default, "edit")
	replace(actions.select_horizontal, "split")
	replace(actions.select_vertical, "vsplit")
	replace(actions.select_tab, "tabedit")
end

local function file_entry(ctx, line)
	local relative_path = line:gsub("^%./", "")
	return {
		value = relative_path,
		display = relative_path,
		ordinal = relative_path,
		relative_path = relative_path,
		remote_path = join_path(ctx.root, relative_path),
		remote_url = remote_url(ctx, relative_path),
	}
end

local function remote_find_files(ctx, opts)
	opts = vim.tbl_deep_extend("force", {}, opts or {})
	local finders = require("telescope.finders")
	local pickers = require("telescope.pickers")
	local conf = require("telescope.config").values

	local script = table.concat({
		"cd " .. shell_quote(ctx.root) .. " || exit",
		"if command -v rg >/dev/null 2>&1; then",
		"rg --files --no-ignore --hidden"
			.. " --glob '!**/.git/**'"
			.. " --glob '!**/node_modules/**'"
			.. " --glob '!**/dist/**'"
			.. " --glob '!**/build/**'"
			.. " --glob '!**/.next/**'"
			.. " --glob '!**/target/**'",
		"else",
		"find . -type d \\( -name .git -o -name node_modules -o -name dist"
			.. " -o -name build -o -name .next -o -name target \\) -prune"
			.. " -o -type f -print | sed 's#^\\./##'",
		"fi",
	}, "\n")

	pickers
		.new(opts, {
			prompt_title = "Remote Files " .. ctx.target .. ":" .. ctx.root,
			finder = finders.new_oneshot_job(ssh_command(ctx, script), {
				entry_maker = function(line)
					return file_entry(ctx, line)
				end,
			}),
			previewer = previewer(ctx),
			sorter = conf.file_sorter(opts),
			attach_mappings = function()
				attach_open_mappings()
				return true
			end,
		})
		:find()
end

local function grep_entry(ctx, line)
	local filename, lnum, col, text = line:match("^(.*):(%d+):(%d+):(.*)$")
	if not filename then
		filename, lnum, text = line:match("^(.*):(%d+):(.*)$")
		col = 1
	end
	if not filename then
		return nil
	end

	local relative_path = filename:gsub("^%./", "")
	lnum = tonumber(lnum)
	col = tonumber(col)
	return {
		value = line,
		display = string.format("%s:%d:%d:%s", relative_path, lnum, col, text),
		ordinal = relative_path .. " " .. text,
		filename = relative_path,
		lnum = lnum,
		col = col,
		text = text,
		relative_path = relative_path,
		remote_path = join_path(ctx.root, relative_path),
		remote_url = remote_url(ctx, relative_path),
	}
end

local function grep_script(ctx, prompt)
	local grep_flags = prompt:find("%u") and "-RIn" or "-RIni"
	return table.concat({
		"cd " .. shell_quote(ctx.root) .. " || exit",
		"if command -v rg >/dev/null 2>&1; then",
		"rg --color=never --no-heading --with-filename --line-number --column"
			.. " --smart-case --hidden --glob '!**/.git/*' -- "
			.. shell_quote(prompt)
			.. " .",
		"else",
		"grep " .. grep_flags .. " --exclude-dir=.git -- " .. shell_quote(prompt) .. " .",
		"fi",
	}, "\n")
end

local function remote_live_grep(ctx, opts)
	opts = vim.tbl_deep_extend("force", {}, opts or {})
	local actions = require("telescope.actions")
	local finders = require("telescope.finders")
	local pickers = require("telescope.pickers")
	local sorters = require("telescope.sorters")

	pickers
		.new(opts, {
			prompt_title = "Remote Grep " .. ctx.target .. ":" .. ctx.root,
			finder = finders.new_job(function(prompt)
				if not prompt or prompt == "" then
					return nil
				end
				return ssh_command(ctx, grep_script(ctx, prompt))
			end, function(line)
				return grep_entry(ctx, line)
			end),
			previewer = previewer(ctx),
			sorter = sorters.highlighter_only(opts),
			attach_mappings = function(_, map)
				attach_open_mappings()
				map("i", "<C-Space>", actions.to_fuzzy_refine)
				return true
			end,
			push_cursor_on_edit = true,
		})
		:find()
end

M.context = remote_context

function M.find_files(opts)
	local ctx = remote_context()
	if ctx then
		return remote_find_files(ctx, opts)
	end
	return require("telescope.builtin").find_files(opts)
end

function M.live_grep(opts)
	local ctx = remote_context()
	if ctx then
		return remote_live_grep(ctx, opts)
	end
	return require("telescope.builtin").live_grep(opts)
end

function M.grep_string(opts)
	local ctx = remote_context()
	if not ctx then
		return require("telescope.builtin").grep_string(opts)
	end

	opts = vim.tbl_deep_extend("force", {}, opts or {})
	opts.default_text = opts.search or vim.fn.expand("<cword>")
	return remote_live_grep(ctx, opts)
end

return M
