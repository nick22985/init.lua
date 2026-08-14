return {
	{
		"refractalize/oil-git-status.nvim",
		dependencies = {
			"stevearc/oil.nvim",
		},

		config = function()
			require("oil-git-status").setup({
				restore_cwd = false,
				show_ignored = true,
				symbols = {
					index = {
						["!"] = "!",
						["?"] = "?",
						["A"] = "A",
						["C"] = "C",
						["D"] = "D",
						["M"] = "M",
						["R"] = "R",
						["T"] = "T",
						["U"] = "U",
						[" "] = " ",
					},
					working_tree = {
						["!"] = "!",
						["?"] = "?",
						["A"] = "A",
						["C"] = "C",
						["D"] = "D",
						["M"] = "M",
						["R"] = "R",
						["T"] = "T",
						["U"] = "U",
						[" "] = " ",
					},
				},
			})
		end,
	},
	{
		"stevearc/oil.nvim",
		event = "VeryLazy",
		-- Optional dependencies
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("oil").setup({
				-- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
				-- Set to false if you still want to use netrw.
				default_file_explorer = true,
				-- Id is automatically added at the beginning, and name at the end
				-- See :help oil-columns
				columns = {
					"icon",
					-- "permissions",
					-- "size",
					-- "mtime",
				},
				-- Buffer-local options to use for oil buffers
				buf_options = {
					buflisted = false,
					bufhidden = "hide",
				},
				-- Window-local options to use for oil buffers
				win_options = {
					wrap = false,
					signcolumn = "yes:2",
					cursorcolumn = false,
					foldcolumn = "0",
					spell = false,
					list = false,
					conceallevel = 3,
					concealcursor = "nvic",
				},
				-- Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
				delete_to_trash = true,
				-- Skip the confirmation popup for simple operations (:help oil.skip_confirm_for_simple_edits)
				skip_confirm_for_simple_edits = false,
				-- Selecting a new/moved/renamed file or directory will prompt you to save changes first
				-- (:help prompt_save_on_select_new_entry)
				prompt_save_on_select_new_entry = true,
				-- Oil will automatically delete hidden buffers after this delay
				-- You can set the delay to false to disable cleanup entirely
				-- Note that the cleanup process only starts when none of the oil buffers are currently displayed
				cleanup_delay_ms = 2000,
				lsp_file_methods = {
					-- Time to wait for LSP file operations to complete before skipping
					timeout_ms = 1000,
					-- Set to true to autosave buffers that are updated with LSP willRenameFiles
					-- Set to "unmodified" to only save unmodified buffers
					autosave_changes = false,
				},
				-- Constrain the cursor to the editable parts of the oil buffer
				-- Set to `false` to disable, or "name" to keep it on the file names
				constrain_cursor = "editable",
				-- Set to true to watch the filesystem for changes and reload oil
				experimental_watch_for_changes = false,
				-- Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
				-- options with a `callback` (e.g. { callback = function() ... end, desc = "", mode = "n" })
				-- Additionally, if it is a string that matches "actions.<name>",
				-- it will use the mapping at require("oil.actions").<name>
				-- Set to `false` to remove a keymap
				-- See :help oil-actions for a list of all available actions
				keymaps = {
					["g?"] = "actions.show_help",
					["<CR>"] = "actions.select",
					["<C-s>"] = "actions.select_vsplit",
					["<C-h>"] = "actions.select_split",
					["<C-t>"] = "actions.select_tab",
					["<C-p>"] = "actions.preview",
					["<C-c>"] = "actions.close",
					["<C-l>"] = "actions.refresh",
					["-"] = "actions.parent",
					["_"] = "actions.open_cwd",
					["`"] = "actions.cd",
					["~"] = "actions.tcd",
					["gs"] = "actions.change_sort",
					["gx"] = "actions.open_external",
					["g."] = "actions.toggle_hidden",
					["g\\"] = "actions.toggle_trash",
				},
				-- Configuration for the floating keymaps help window
				keymaps_help = {
					border = "rounded",
				},
				-- Set to false to disable all of the above keymaps
				use_default_keymaps = true,
				view_options = {
					-- Show files and directories that start with "."
					show_hidden = true,
					-- This function defines what is considered a "hidden" file
					is_hidden_file = function(name, bufnr)
						return vim.startswith(name, ".")
					end,
					-- This function defines what will never be shown, even when `show_hidden` is set
					is_always_hidden = function(name, bufnr)
						return false
					end,
					-- Sort file names in a more intuitive order for humans. Is less performant,
					-- so you may want to set to false if you work with large directories.
					natural_order = true,
					sort = {
						-- sort order can be "asc" or "desc"
						-- see :help oil-columns to see which columns are sortable
						{ "type", "asc" },
						{ "name", "asc" },
					},
				},
				-- EXPERIMENTAL support for performing file operations with git
				git = {
					-- Return true to automatically git add/mv/rm files
					add = function(path)
						return false
					end,
					mv = function(src_path, dest_path)
						return false
					end,
					rm = function(path)
						return false
					end,
				},
				-- Configuration for the floating window in oil.open_float
				float = {
					-- Padding around the floating window
					padding = 2,
					max_width = 0,
					max_height = 0,
					border = "rounded",
					win_options = {
						winblend = 0,
					},
					-- This is the config that will be passed to nvim_open_win.
					-- Change values here to customize the layout
					override = function(conf)
						return conf
					end,
				},
				-- Configuration for the actions floating preview window
				preview = {
					-- Width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
					-- min_width and max_width can be a single value or a list of mixed integer/float types.
					-- max_width = {100, 0.8} means "the lesser of 100 columns or 80% of total"
					max_width = 0.9,
					-- min_width = {40, 0.4} means "the greater of 40 columns or 40% of total"
					min_width = { 40, 0.4 },
					-- optionally define an integer/float for the exact width of the preview window
					width = nil,
					-- Height dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
					-- min_height and max_height can be a single value or a list of mixed integer/float types.
					-- max_height = {80, 0.9} means "the lesser of 80 columns or 90% of total"
					max_height = 0.9,
					-- min_height = {5, 0.1} means "the greater of 5 columns or 10% of total"
					min_height = { 5, 0.1 },
					-- optionally define an integer/float for the exact height of the preview window
					height = nil,
					border = "rounded",
					win_options = {
						winblend = 0,
					},
					-- Whether the preview window is automatically updated when the cursor is moved
					update_on_cursor_moved = true,
				},
				-- Configuration for the floating progress window
				progress = {
					max_width = 0.9,
					min_width = { 40, 0.4 },
					width = nil,
					max_height = { 10, 0.9 },
					min_height = { 5, 0.1 },
					height = nil,
					border = "rounded",
					minimized_border = "none",
					win_options = {
						winblend = 0,
					},
				},
				-- Configuration for the floating SSH window
				ssh = {
					border = "rounded",
				},
			})

			do
				local ssh = require("oil.adapters.ssh")
				if not ssh.__remote_read_patched then
					ssh.__remote_read_patched = true
					local loading = require("oil.loading")
					local orig_read_file = ssh.read_file
					local function shquote(s)
						return "'" .. s:gsub("'", "'\\''") .. "'"
					end
					local archive_exts = { jar = true, zip = true, war = true, ear = true, apk = true }

					local function ssh_cmd_for(url)
						local host = url.user and (url.user .. "@" .. url.host) or url.host
						local cmd = { "ssh" }
						if url.port then
							vim.list_extend(cmd, { "-p", tostring(url.port) })
						end
						table.insert(cmd, host)
						return cmd
					end

					local function read_archive(bufnr, bufname)
						local url = ssh.parse_url(bufname)
						local cmd = ssh_cmd_for(url)
						table.insert(cmd, "cat -- " .. shquote(url.path))

						loading.set_loading(bufnr, true)
						vim.system(cmd, { text = false }, function(obj)
							vim.schedule(function()
								if not vim.api.nvim_buf_is_valid(bufnr) then
									return
								end
								loading.set_loading(bufnr, false)
								if obj.code ~= 0 then
									vim.bo[bufnr].modifiable = true
									local msg = "ssh cat failed (exit " .. obj.code .. ")\n" .. (obj.stderr or "")
									vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, vim.split(msg, "\n"))
									vim.bo[bufnr].modified = false
									return
								end
								local tmpdir = vim.fn.tempname()
								vim.fn.mkdir(tmpdir, "p")
								local tmpfile = tmpdir .. "/" .. vim.fs.basename(url.path)
								local f, err = io.open(tmpfile, "wb")
								if not f then
									vim.notify("oil-ssh archive: " .. tostring(err), vim.log.levels.ERROR)
									return
								end
								f:write(obj.stdout or "")
								f:close()
								local wins = vim.fn.win_findbuf(bufnr)
								if #wins == 0 then
									return
								end
								vim.api.nvim_win_call(wins[1], function()
									vim.cmd("keepalt edit " .. vim.fn.fnameescape(tmpfile))
								end)
								pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
							end)
						end)
					end

					ssh.read_file = function(bufnr)
						local bufname = vim.api.nvim_buf_get_name(bufnr)
						local ext = bufname:match("%.(%w+)$")
						if ext and archive_exts[ext:lower()] then
							return read_archive(bufnr, bufname)
						end
						if not bufname:match("%.gz$") then
							return orig_read_file(bufnr)
						end
						local url = ssh.parse_url(bufname)
						local read_name = (bufname:gsub("%.gz$", ""))
						local cmd = ssh_cmd_for(url)
						table.insert(cmd, "gzip -dc -- " .. shquote(url.path))

						loading.set_loading(bufnr, true)
						vim.bo[bufnr].modifiable = true
						vim.cmd.doautocmd({ args = { "BufReadPre", read_name }, mods = { silent = true } })

						vim.system(cmd, { text = false }, function(obj)
							vim.schedule(function()
								if not vim.api.nvim_buf_is_valid(bufnr) then
									return
								end
								loading.set_loading(bufnr, false)
								vim.bo[bufnr].modifiable = true
								if obj.code ~= 0 then
									local msg = "gzip -dc failed (exit " .. obj.code .. ")\n" .. (obj.stderr or "")
									vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, vim.split(msg, "\n"))
									vim.bo[bufnr].modified = false
									return
								end
								local data = obj.stdout or ""
								local lines = vim.split(data:gsub("\r\n", "\n"), "\n", { plain = true })
								if lines[#lines] == "" then
									table.remove(lines)
								end
								vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, lines)
								local ft = vim.filetype.match({ filename = vim.fs.basename(read_name), buf = bufnr })
								if ft then
									vim.bo[bufnr].filetype = ft
								end
								vim.bo[bufnr].modified = false
								vim.bo[bufnr].modifiable = false
								vim.bo[bufnr].readonly = true
								vim.cmd.doautocmd({ args = { "BufReadPost", read_name }, mods = { silent = true } })
							end)
						end)
					end

					local ok, zip_aus = pcall(vim.api.nvim_get_autocmds, { group = "zip", event = "BufReadCmd" })
					if ok then
						for _, au in ipairs(zip_aus) do
							if not au.pattern:match("^zipfile:") then
								vim.api.nvim_del_autocmd(au.id)
								vim.api.nvim_create_autocmd("BufReadCmd", {
									pattern = au.pattern,
									callback = function(ev)
										if not ev.match:match("^oil%-ssh://") then
											vim.fn["zip#Browse"](ev.match)
										end
									end,
								})
							end
						end
					end
				end
			end

			-- From an oil-ssh:// buffer, open the matching local mirror dir
			-- in a vsplit. Host->path mappings are loaded from a private
			-- file (kept out of this dotfiles repo) that returns a
			--   function(host) -> path|nil
			-- If the file is missing or returns nil, falls back to ~/projects.
			local function open_local_mirror()
				local bufname = vim.api.nvim_buf_get_name(0)
				local host = bufname:match("^oil%-ssh://([^/]+)/")
				if not host then
					vim.notify("not in an oil-ssh:// buffer", vim.log.levels.WARN)
					return
				end
				host = host:gsub(".*@", "")
				local home = vim.uv.os_homedir()

				local target
				local private_path = vim.env.NVIM_OIL_MIRRORS_FILE
					or (home .. "/.config/.nickInstall/install/configs/private/oil-mirrors.lua")
				if vim.uv.fs_stat(private_path) then
					local ok, resolver = pcall(dofile, private_path)
					if ok and type(resolver) == "function" then
						local got = resolver(host)
						if type(got) == "string" and got ~= "" then
							target = got
						end
					end
				end
				if not target then
					target = home .. "/projects"
				end
				vim.cmd("vsplit " .. vim.fn.fnameescape(target))
			end

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "oil",
				callback = function(ev)
					vim.keymap.set("n", "<leader>ml", open_local_mirror, {
						buffer = ev.buf,
						desc = "Oil: open local mirror dir for this ssh host",
					})
				end,
			})
		end,
	},
}
