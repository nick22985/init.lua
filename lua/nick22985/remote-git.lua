local M = {}

local remote_ui = [[
if command -v lazygit >/dev/null 2>&1; then exec lazygit; fi
if command -v tig >/dev/null 2>&1; then exec tig status; fi
git status
printf '\n(no lazygit or tig on this host) press enter '
read -r _
]]

function M.open(ctx)
	if not vim.env.TMUX then
		vim.notify("remote git status needs tmux", vim.log.levels.WARN)
		return
	end

	local connect = vim.fn.exepath("tmux-ssh-connect")
	if connect == "" then
		connect = vim.uv.os_homedir() .. "/.local/bin/tmux-ssh-connect"
	end
	local args = { connect, "-d", ctx.root, "-c", remote_ui, "--", ctx.target }
	if ctx.url.port then
		vim.list_extend(args, { "-p", tostring(ctx.url.port) })
	end

	local command = table.concat(vim.tbl_map(vim.fn.shellescape, args), " ")
	vim.system({ "tmux", "display-popup", "-E", "-w", "90%", "-h", "90%", "-d", vim.uv.os_homedir(), command })
end

return M
