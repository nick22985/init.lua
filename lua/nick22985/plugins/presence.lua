return {
	{
		"jiriks74/presence.nvim",
		dev = true,
		config = function()
			local status, presence = pcall(require, "presence")
			if not status then
				return
			end

			local file =
				io.open(os.getenv("HOME") .. "/.config/.nickInstall/install/configs/private/excludednames", "r")
			if file == nil then
				return
			end
			local blacklist = {}
			for line in file:lines() do
				table.insert(blacklist, line)
			end

			local blacklistText = "[REDACTED]"
			function FilterText(fileName)
				for _, v in ipairs(blacklist) do
					if string.find(string.lower(fileName), string.lower(v)) then
						return blacklistText
					end
				end
				return fileName
			end

			function HandleEdditing(filename)
				return string.format("Editing %s", FilterText(filename))
			end

			function HandleFileExpolorer(file_explorer_name)
				return string.format("Browsing %s", FilterText(file_explorer_name))
			end

			function HandleGitCommit(filename)
				return string.format("Committing changes to %s", FilterText(filename))
			end

			function HandlePluginManger(plugin_manager_name)
				return string.format("Managing %s", FilterText(plugin_manager_name))
			end

			function HandleReading(filename)
				return string.format("Reading %s", FilterText(filename))
			end

			function HandleLineNumbers(line_number, line_count)
				return string.format("Line %s out of %s", line_number, line_count)
			end

			presence.setup({
				-- General options
				auto_update = true, -- Update activity based on autocmd events (if `false`, map or manually execute `:lua package.loaded.presence:update()`)
				neovim_image_text = "The One True Text Editor", -- Text displayed when hovered over the Neovim image
				main_image = "file", -- Main image display (either "neovim" or "file")
				client_id = "793271441293967371", -- Use your own Discord application client id (not recommended)
				log_level = nil, -- Log messages at or above this level (one of the following: "debug", "info", "warn", "error")
				debounce_timeout = 10, -- Number of seconds to debounce events (or calls to `:lua package.loaded.presence:update(<filename>, true)`)
				enable_line_number = true, -- Displays the current line number instead of the current project
				-- blacklist = blacklist,
				-- A list of strings or Lua patterns that disable Rich Presence if the current file name, path, or workspace matches
				-- buttons             = true,                         -- Configure Rich Presence button(s), either a boolean to enable/disable, a static table (`{{ label = "<label>", url = "<url>" }, ...}`, or a function(buffer: string, repo_url: string|nil): table)
				-- buttons							= {{ label = "GitHub", url = "https://test.com"}, { label = "Discord", url = "https://discord.gg"}},
				buttons = function(buffer, repo_url)
					local github = { label = "GitHub", url = "https://github.com/nick22985" }
					local website = { label = "Website", url = "https://nick22985.com" }
					if repo_url then
						for _, v in ipairs(blacklist) do
							if string.find(string.lower(repo_url), string.lower(v)) then
								return {
									github,
								}
							end
						end
						local repo = { label = "View Repository", url = nil }
						-- Check if repo url uses short ssh syntax
						local domain, project = repo_url:match("^git@(.+):(.+)$")
						if domain and project then
							repo_url = string.format("https://%s/%s", domain, project)
						end

						-- Check if repo url uses a valid protocol
						local protocols = {
							"ftp",
							"git",
							"http",
							"https",
							"ssh",
						}
						local protocol, relative = repo_url:match("^(.+)://(.+)$")
						if not vim.tbl_contains(protocols, protocol) or not relative then
							return nil
						end

						-- Check if repo url has the user specified
						local user, path = relative:match("^(.+)@(.+)$")
						if user and path then
							repo.url = string.format("https://%s", path)
						else
							repo.url = string.format("https://%s", relative)
						end

						return {
							repo,
							github,
						}
					end
					return {
						github,
					}
				end,
				file_assets = {}, -- Custom file asset definitions keyed by file names and extensions (see default config at `lua/presence/file_assets.lua` for reference)
				show_time = true, -- Show the timer

				-- Rich Presence text options
				editing_text = HandleEdditing, -- Format string rendered when an editable file is loaded in the buffer (either string or function(filename: string): string)
				file_explorer_text = HandleFileExpolorer, -- Format string rendered when browsing a file explorer (either string or function(file_explorer_name: string): string)
				git_commit_text = HandleGitCommit, -- Format string rendered when committing changes in git (either string or function(filename: string): string)
				plugin_manager_text = HandlePluginManger, -- Format string rendered when managing plugins (either string or function(plugin_manager_name: string): string)
				reading_text = HandleReading, -- Format string rendered when a read-only or unmodifiable file is loaded in the buffer (either string or function(filename: string): string) workspace_text = "Working on %s", -- Format string rendered when in a git repository (either string or function(project_name: string|nil, filename: string): string)
				line_number_text = HandleLineNumbers, -- Format string rendered when `enable_line_number` is set to true (either string or function(line_number: number, line_count: number): string)
			})
		end,
	},
}
