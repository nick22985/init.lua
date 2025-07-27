return {
	"nick22985/presence.nvim",
	dev = true,
	config = function()
		local status, presence = pcall(require, "presence")
		if not status then
			return
		end

		local file = io.open(os.getenv("HOME") .. "/.config/.nickInstall/install/configs/private/excludednames", "r")
		if file == nil then
			return
		end
		local blacklist = {}
		for line in file:lines() do
			table.insert(blacklist, line)
		end

		local blacklistText = "[REDACTED]"
		function FilterText(fileName)
			if fileName == nil then
				return ""
			end
			for _, v in ipairs(blacklist) do
				if string.find(string.lower(fileName), string.lower(v)) then
					return blacklistText
				end
			end
			return fileName
		end

		local function GetLocationText(config)
			if config.project_name and config.project_name ~= "" then
				return FilterText(config.project_name)
			elseif config.parent_dirpath and config.parent_dirpath ~= "" then
				local dir_name = config.parent_dirpath:match("([^/\\]+)[/\\]*$")
				return FilterText(dir_name or config.parent_dirpath)
			else
				return "unknown"
			end
		end

		function HandleEditing(config)
			return {
				details = string.format(
					"Working on %s in %s",
					FilterText(config.filename),
					FilterText(config.project_name)
				),
				state = string.format(
					"Currently at line %s of %s - %s problems found",
					FilterText(config.line_number),
					FilterText(config.line_count),
					config.problems_total
				),
			}
		end

		function HandleFileExplorer(config)
			return {
				state = string.format("Browsing %s", FilterText(config.file_explorer)),
				details = string.format("In %s", GetLocationText(config)),
			}
		end

		function HandleGitCommit(config)
			return {
				state = "Committing changes",
				details = string.format("To %s", FilterText(config.filename)),
			}
		end

		function HandlePluginManager(config)
			return {
				state = string.format("Managing %s", FilterText(config.plugin_manager)),
				details = string.format("In %s", GetLocationText(config)),
			}
		end

		function HandleReading(config)
			return {
				state = string.format("Reading %s", FilterText(config.filename)),
				details = string.format("In %s", GetLocationText(config)),
			}
		end

		function HandleIdle(config)
			local idle_minutes = math.floor(config.idle_time / 60)
			local idle_seconds = config.idle_time % 60

			local time_text = idle_minutes > 0 and string.format("%dm %ds", idle_minutes, idle_seconds)
				or string.format("%ds", idle_seconds)

			return {
				state = nil,
				details = nil,
				-- state = string.format("Idle for %s", time_text),
				-- details = string.format(
				-- 	"Was on %s:%s in %s (%d problems)",
				-- 	FilterText(config.filename or "file"),
				-- 	config.line_number or 1,
				-- 	FilterText(config.project_name or GetLocationText(config)),
				-- 	config.problems_total or 0
				-- ),
				-- Custom idle images and text
				small_image = "idle",
				small_text = "Idling",
			}
		end

		presence.setup({
			-- General options
			auto_update = true,
			neovim_image_text = "The One True Text Editor",
			main_image = "file",
			client_id = "793271441293967371",
			log_level = nil,
			debounce_timeout = 10,
			use_session_time = true,
			idle_timeout = 500,
			file_asset_url_template = "https://raw.githubusercontent.com/xhayper/catppuccin-vscord/main/images/mocha/{lang}.png",
			file_assets = {
				-- File explorers (detected by filetype)
				oil = {
					"Oil",
					"https://raw.githubusercontent.com/xhayper/catppuccin-vscord/main/images/mocha/file.png",
				},
				netrw = { "Netrw", "code" },
				fern = { "Fern", "code" },

				-- Plugin managers (detected by filetype)
				packer = { "Packer", "code" },
				lazy = { "Lazy", "code" },
				["NeogitStatus"] = {
					"Neogit",
					"https://raw.githubusercontent.com/xhayper/catppuccin-vscord/main/images/mocha/git.png",
				},
				["TelescopePrompt"] = {
					"Telescope",
					"https://raw.githubusercontent.com/xhayper/catppuccin-vscord/main/images/mocha/search.png",
				},

				-- File explorers detected by buffer name patterns
				["NvimTree"] = { "NvimTree", "code" },
				["NERD_tree_"] = { "NERDTree", "code" },
				["[defx] default-"] = { "Defx", "code" },
				["neo-tree"] = { "Neotree", "code" },
				["vim-plug"] = { "vim-plug", "code" },
				idle = {
					"Away",
					"https://raw.githubusercontent.com/leonardssh/vscord/refs/heads/main/assets/icons/idle-vscode.png",
				},
			},
			buttons = function(buffer, repo_url)
				local github = { label = "GitHub", url = "https://github.com/nick22985" }
				local website = { label = "Website", url = "https://nick22985.com" }
				if repo_url then
					for _, v in ipairs(blacklist) do
						if string.find(string.lower(repo_url), string.lower(v)) then
							return {
								website,
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
						website,
					}
				end
				return {
					website,
				}
			end,
			show_time = true,

			-- Rich Presence text options - now return objects with state and details
			editing_text = HandleEditing,
			file_explorer_text = HandleFileExplorer,
			git_commit_text = HandleGitCommit,
			plugin_manager_text = HandlePluginManager,
			reading_text = HandleReading,
			idle_text = HandleIdle,
		})
	end,
}
