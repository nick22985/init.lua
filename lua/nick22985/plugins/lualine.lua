local batteryNotify = false
return {
	{
		"nvim-lualine/lualine.nvim",
		event = "UIEnter",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			local status, lualine = pcall(require, "lualine")
			if not status then
				return
			end
			-- Color table for highlights
			-- stylua: ignore
			local colors = {
				bg       = '#202328',
				fg       = '#bbc2cf',
				yellow   = '#ECBE7B',
				cyan     = '#008080',
				darkblue = '#081633',
				green    = '#98be65',
				orange   = '#FF8800',
				violet   = '#a9a1e1',
				magenta  = '#c678dd',
				blue     = '#51afef',
				red      = '#ec5f67',
			}

			local conditions = {
				buffer_not_empty = function()
					return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
				end,
				hide_in_width = function()
					return vim.fn.winwidth(0) > 80
				end,
				check_git_workspace = function()
					local filepath = vim.fn.expand("%:p:h")
					local gitdir = vim.fn.finddir(".git", filepath .. ";")
					return gitdir and #gitdir > 0 and #gitdir < #filepath
				end,
			}

			-- Config
			local config = {
				options = {
					disabled_filetypes = { "AvanteInput", "Avante" },
					-- Disable sections and component separators
					component_separators = "",
					section_separators = "",
					theme = "catppuccin",
					-- theme = {
					-- 	-- We are going to use lualine_c an lualine_x as left and
					-- 	-- right section. Both are highlighted by c theme .  So we
					-- 	-- are just setting default looks o statusline
					-- normal = { c = { fg = colors.fg, bg = colors.bg } },
					-- inactive = { c = { fg = colors.fg, bg = colors.bg } },
					-- },
				},
				sections = {
					-- these are to remove the defaults
					lualine_a = {},
					lualine_b = {},
					lualine_y = {},
					lualine_z = {},
					-- These will be filled later
					lualine_c = {},
					lualine_x = {},
				},
				inactive_sections = {
					-- these are to remove the defaults
					lualine_a = {},
					lualine_b = {},
					lualine_y = {},
					lualine_z = {},
					lualine_c = {},
					lualine_x = {},
				},
			}

			-- Inserts a component in lualine_c at left section
			local function ins_left(component, isActive, isInactive)
				if isActive == nil then
					isActive = true
				end
				if isActive == true then
					table.insert(config.sections.lualine_c, component)
				end
				if isInactive == true then
					table.insert(config.inactive_sections.lualine_c, component)
				end
			end

			-- Inserts a component in lualine_x at right section
			-- add isActive, isInactive both enum
			-- isActive is default true if no value
			--

			local function ins_right(component, isActive, isInactive)
				if isActive == nil then
					isActive = true
				end
				if isActive == true then
					table.insert(config.sections.lualine_x, component)
				end
				if isInactive == true then
					table.insert(config.inactive_sections.lualine_x, component)
				end
			end

			ins_left({
				function()
					return "▊"
				end,
				color = { fg = colors.blue }, -- Sets highlighting of component
				padding = { left = 0, right = 1 }, -- We don't need space before this
			}, true, true)

			ins_left({
				-- mode component
				function()
					return ""
				end,
				color = function()
					-- auto change color according to neovims mode
					local mode_color = {
						n = colors.red,
						i = colors.green,
						v = colors.blue,
						[""] = colors.blue,
						V = colors.blue,
						c = colors.magenta,
						no = colors.red,
						s = colors.orange,
						S = colors.orange,
						[""] = colors.orange,
						ic = colors.yellow,
						R = colors.violet,
						Rv = colors.violet,
						cv = colors.red,
						ce = colors.red,
						r = colors.cyan,
						rm = colors.cyan,
						["r?"] = colors.cyan,
						["!"] = colors.red,
						t = colors.red,
					}
					return { fg = mode_color[vim.fn.mode()] }
				end,
				padding = { right = 1 },
			}, true, true)

			ins_left({
				-- filesize component
				"filesize",
				cond = conditions.buffer_not_empty,
			}, true, true)

			ins_left({
				"filename",
				path = 1,
				cond = conditions.buffer_not_empty,
				color = { fg = colors.magenta, gui = "bold" },
			}, true, true)

			ins_left({ "location" }, true, true)

			ins_left({ "progress", color = { fg = colors.fg, gui = "bold" } }, true, true)

			ins_left({
				"diagnostics",
				sources = { "nvim_diagnostic" },
				symbols = { error = " ", warn = " ", info = " " },
				diagnostics_color = {
					color_error = { fg = colors.red },
					color_warn = { fg = colors.yellow },
					color_info = { fg = colors.cyan },
				},
			}, true, true)
			-- ins_left({
			-- 	symbols.get,
			-- 	cond = symbols.has,
			-- })

			ins_left({
				function()
					-- return require("noice").api.status.mode.get()
					local mode = require("noice").api.statusline.mode.get()
					if mode then
						return string.match(mode, "^recording @.*") or ""
					end
					return ""
				end,
				cond = function()
					return package.loaded["noice"] and require("noice").api.status.mode.has()
				end,
			}, true, false)

			-- Insert mid section. You can make any number of sections in neovim :)
			-- for lualine it's any number greater then 2
			ins_left({
				function()
					return "%="
				end,
			}, true, true)

			ins_left({
				-- Lsp server name .
				function()
					local msg = "No Active Lsp"
					local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
					local clients = vim.lsp.get_clients()

					if next(clients) == nil then
						return msg
					end
					local seen = {}
					local names = {}
					for _, client in ipairs(clients) do
						local filetypes = client.config.filetypes
						if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
							if not seen[client.name] then
								table.insert(names, client.name)
								seen[client.name] = true
							end
						end
					end
					if #names == 0 then
						return msg
					end
					msg = table.concat(names, ", ")
					return msg
				end,
				icon = " LSP:",
				color = { fg = colors.cyan, gui = "bold" },
			}, true, true)

			-- Add components to right sections
			ins_right({
				function()
					local resession = require("resession")
					local session = resession.get_current()
					if session == nil then
						return ""
					end
					-- shorten it to the current dir
					session = session:gsub(".*/", "")
					return " " .. session
				end,
				color = { fg = colors.blue }, -- Sets highlighting of component
				padding = { left = 0, right = 1 }, -- We don't need space before this
			}, true, false)

			ins_right({
				"o:encoding", -- option component same as &encoding in viml
				fmt = string.upper, -- I'm not sure why it's upper case either ;)
				cond = conditions.hide_in_width,
				color = { fg = colors.green, gui = "bold" },
			}, true, true)

			ins_right({
				"fileformat",
				fmt = string.upper,
				icons_enabled = true, -- I think icons are cool but Eviline doesn't have them. sigh
				color = { fg = colors.green, gui = "bold" },
			}, true, true)

			ins_right({
				"branch",
				icon = "",
				color = { fg = colors.violet, gui = "bold" },
			}, true, true)

			ins_right({
				"diff",
				-- Is it me or the symbol for modified us really weird
				symbols = { added = " ", modified = "󰝤 ", removed = " " },
				diff_color = {
					added = { fg = colors.green },
					modified = { fg = colors.orange },
					removed = { fg = colors.red },
				},
				cond = conditions.hide_in_width,
			}, true, true)

			ins_right({
				function()
					-- does not display just for battery notification when below 35%
					local battery = require("battery").get_status_line()
					--  if battery is below 10% change color to red
					if battery:find("%%") then
						local level = tonumber(battery:match("%d+"))
						if level and level < 35 then
							if batteryNotify == false then
								batteryNotify = true
								local batteryString = "Battery Low: " .. battery
								require("notify")(batteryString, "error", {
									title = "Battery Low",
									timeout = 10000,
								})
							end
							return ""
						end
					else
						batteryNotify = false
					end
					return ""
				end,
				color = { fg = colors.violet, bg = colors.bg },
			}, true, true)
			ins_right({
				function()
					return "▊"
				end,
				color = { fg = colors.blue },
				padding = { left = 1 },
			}, true, true)
			-- Now don't forget to initialize lualine
			lualine.setup(config)
			require("lualine").hide({ place = { "tabline" } })
		end,
	},
}
