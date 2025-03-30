return { -- LSP Configuration & Plugins
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPost", "BufWritePost", "BufNewFile" },
		dependencies = {
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },
			{ "WhoIsSethDaniel/mason-tool-installer.nvim" },
			{ "artemave/workspace-diagnostics.nvim" },
			{
				"j-hui/fidget.nvim",
				config = function()
					require("fidget").setup({
						notification = {
							redirect = function(msg, level, opts)
								if opts and opts.on_open then
									return require("fidget.integration.nvim-notify").delegate(msg, level, opts)
								end
							end,
							window = {
								winblend = 0,
							},
						},
					})
				end,
			},

			-- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
			-- used for completion, annotations and signatures of Neovim apis
			{
				"folke/neodev.nvim",
				opts = {},
			},
			{
				"saghen/blink.cmp",
				lazy = true,
				dependencies = {
					"rafamadriz/friendly-snippets",
					{
						"Saghen/blink.compat",
						lazy = true,
						opts = {
							-- some plugins lazily register their completion source when nvim-cmp is
							-- loaded, so pretend that we are nvim-cmp, and that nvim-cmp is loaded.
							-- most plugins don't do this, so this option should rarely be needed
							-- NOTE: only has effect when using lazy.nvim plugin manager
							impersonate_nvim_cmp = true,
						},
					},
					-- nvim-cmp sources
					{ "dmitmel/cmp-digraphs" },
					{
						-- "zbirenbaum/copilot-cmp",
						"giuxtaposition/blink-cmp-copilot",
						dependencies = {
							"zbirenbaum/copilot.lua",
						},
					},
				},

				-- use a release tag to download pre-built binaries
				version = "1.*",
				-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
				-- build = "cargo build --release",
				-- If you use nix, you can build from source using latest nightly rust with:
				-- build = 'nix run .#build-plugin',

				---@module 'blink.cmp'
				---@type blink.cmp.Config
				opts = {
					-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
					-- 'super-tab' for mappings similar to vscode (tab to accept)
					-- 'enter' for enter to accept
					-- 'none' for no mappings
					--
					-- All presets have the following mappings:
					-- C-space: Open menu or open docs if already open
					-- C-n/C-p or Up/Down: Select next/previous item
					-- C-e: Hide menu
					-- C-k: Toggle signature help (if signature.enabled = true)
					--
					-- See :h blink-cmp-config-keymap for defining your own keymap
					keymap = { preset = "default" },
					signature = {
						enabled = true,
						window = {
							show_documentation = true,
							treesitter_highlighting = true,
						},
					},

					appearance = {
						-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
						nerd_font_variant = "mono",
						-- Adjusts spacing to ensure icons are aligned
						highlight_ns = vim.api.nvim_create_namespace("blink_cmp"),
						-- Sets the fallback highlight groups to nvim-cmp's highlight groups
						-- Useful for when your theme doesn't support blink.cmp
						-- Will be removed in a future release
						use_nvim_cmp_as_default = false,
						-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
						-- Adjusts spacing to ensure icons are aligned
						kind_icons = {
							Text = "󰉿",
							Method = "󰊕",
							Function = "󰊕",
							Constructor = "󰒓",

							Field = "󰜢",
							Variable = "󰆦",
							Property = "󰖷",

							Class = "󱡠",

							Interface = "󱡠",
							Struct = "󱡠",
							Module = "󰅩",

							Unit = "󰪚",
							Value = "󰦨",
							Enum = "󰦨",
							EnumMember = "󰦨",

							Keyword = "󰻾",
							Constant = "󰏿",

							Snippet = "󱄽",
							Color = "󰏘",
							File = "󰈔",
							Reference = "󰬲",
							Folder = "󰉋",
							Event = "󱐋",
							Operator = "󰪚",
							TypeParameter = "󰬛",
							Copilot = "",
						},
					},

					-- (Default) Only show the documentation popup when manually triggered
					completion = {
						documentation = {
							auto_show = true,
							auto_show_delay_ms = 200,
							treesitter_highlighting = true,
						},
						ghost_text = {
							enabled = true,
							show_with_menu = true,
						},
						list = {
							selection = {
								preselect = true,
								auto_insert = false,
							},
						},
						menu = {
							draw = {
								treesitter = { "lsp" },
								columns = {
									{ "kind_icon", "label", "label_description", gap = 1 },
									{ "kind" },
								},
							},
						},
					},

					-- Default list of enabled providers defined so that you can extend it
					-- elsewhere in your config, without redefining it, due to `opts_extend`
					sources = {
						default = { "lsp", "path", "snippets", "buffer", "digraphs", "copilot" },
						providers = {
							buffer = {
								opts = {
									-- get all buffers, even ones like neo-tree
									-- get_bufnrs = vim.api.nvim_list_bufs,
									-- or (recommended) filter to only "normal" buffers
									get_bufnrs = function()
										return vim.tbl_filter(function(bufnr)
											return vim.bo[bufnr].buftype == ""
										end, vim.api.nvim_list_bufs())
									end,
								},
							},
							-- nvim-cmp providers below
							digraphs = {
								-- IMPORTANT: use the same name as you would for nvim-cmp
								name = "digraphs",
								module = "blink.compat.source",

								-- all blink.cmp source config options work as normal:
								score_offset = -3,

								-- this table is passed directly to the proxied completion source
								-- as the `option` field in nvim-cmp's source config
								--
								-- this is NOT the same as the opts in a plugin's lazy.nvim spec
								opts = {
									-- this is an option from cmp-digraphs
									cache_digraphs_on_start = true,

									-- If you'd like to use a `name` that does not exactly match nvim-cmp,
									-- set `cmp_name` to the name you would use for nvim-cmp, for instance:
									-- cmp_name = "digraphs"
									-- then, you can set the source's `name` to whatever you like.
								},
							},
							copilot = {
								name = "copilot",
								module = "blink-cmp-copilot",
								score_offset = 100,
								async = false,
								transform_items = function(_, items)
									local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
									local kind_idx = #CompletionItemKind + 1
									CompletionItemKind[kind_idx] = "Copilot"
									for _, item in ipairs(items) do
										item.kind = kind_idx
									end
									return items
								end,
							},
						},
						min_keyword_length = 2,
					},
					-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
					-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
					-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
					--
					-- See the fuzzy documentation for more information
					fuzzy = { implementation = "prefer_rust_with_warning" },
				},
				opts_extend = { "sources.default" },
			},
		},
		opts = {
			servers = {
				lua_ls = {
					-- cmd = {...},
					-- filetypes = { ...},
					-- capabilities = {},
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
							diagnostics = {
								globals = { "vim", "it", "describe", "before_each", "after_each" },
							},
						},
					},
				},
				tailwindcss = {
					filetypes = { "css", "javascriptreact", "typescriptreact" },
				},
				-- tsserver = {
				-- 	init_options = {
				-- 		plugins = {
				-- 			-- {
				-- 			-- 	name = "@vue/typescript-plugin",
				-- 			-- 	location = "/path/to/@vue/language-server",
				-- 			-- 	languages = { "vue" },
				-- 			-- },
				-- 		},
				-- 	},
				-- },
				volar = {
					init_options = {
						languageFeatures = {
							typeDefinition = false,
						},
						vue = {
							hybridMode = false,
						},
					},
				},
				vuels = {
					vetur = {
						grammar = {
							customBlocks = {
								component = "md",
								directive = "js",
								endpoint = "js",
								filter = "js",
								macgyver = "js",
								schema = "js",
								server = "js",
								service = "js",
							},
						},
					},
				},
				angularls = {
					filestypes = {
						"ng",
						"html",
					},
				},
				gopls = {
					settings = {
						gopls = {
							completeUnimported = true,
							-- usePlaceholders = true,
							analyses = {
								unusedparams = true,
							},
						},
					},
				},
				eslint = {
					root_dir = function()
						return false
					end,
				},
				bashls = {
					filetypes = { "sh", "zsh" },
				},
				copilot = {
					filetypes = "*",
				},
			},
		},
		config = function(_, opts)
			local lspconfig = require("lspconfig")
			require("workspace-diagnostics").setup()

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
					map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
					map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
					map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
					map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
					map(
						"<leader>ws",
						require("telescope.builtin").lsp_dynamic_workspace_symbols,
						"[W]orkspace [S]ymbols"
					)

					-- map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

					map("K", vim.lsp.buf.hover, "Hover Documentation")

					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

					-- project level diagnostics

					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client then
						-- NOTE: disabled for copilot
						if client.name ~= "copilot" then
							require("workspace-diagnostics").populate_workspace_diagnostics(client, event.buf)
						end
					end
					if client and client.server_capabilities.documentHighlightProvider then
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							callback = vim.lsp.buf.clear_references,
						})
					end

					if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})
			-- Hide copilot suggestions when BlinkCmp menu is open
			-- When cmp menu is open
			vim.api.nvim_create_autocmd("User", {
				pattern = "BlinkCmpMenuOpen",
				callback = function()
					require("copilot.suggestion").dismiss()
					vim.b.copilot_suggestion_hidden = true
				end,
			})

			vim.api.nvim_create_autocmd("User", {
				pattern = "BlinkCmpMenuClose",
				callback = function()
					vim.b.copilot_suggestion_hidden = false
				end,
			})

			local function eslint_config_exists()
				local eslintrc = vim.fn.glob(".eslintrc*", 0, 1)

				if not vim.tbl_isempty(eslintrc) then
					return true
				end

				if vim.fn.filereadable("package.json") then
					if vim.fn.json_decode(vim.fn.readfile("package.json"))["eslintConfig"] then
						return true
					end
				end

				return true
			end

			local capabilities = vim.lsp.protocol.make_client_capabilities()

			capabilities =
				vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities({}, false))

			local ensure_installed = vim.tbl_keys(masonServers or {})

			vim.list_extend(ensure_installed, {
				"stylua", -- Used to format Lua code
				"tailwindcss",
				"gopls",
				"ts_ls",
			})

			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			require("mason").setup()
			require("mason-lspconfig").setup({
				handlers = {
					function(server_name)
						local server = opts.servers[server_name] or {}
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						lspconfig[server_name].setup(server)
					end,
				},
				ensure_installed = {},
				automatic_installation = {},
			})

			vim.diagnostic.config({
				underline = true,
				update_in_insert = true,
				virtual_text = {
					spacing = 4,
					source = "if_many",
					prefix = "●",
					current_line = false,
				},
				virtual_lines = {
					current_line = true,
				},
				severity_sort = true,
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = " ",
						[vim.diagnostic.severity.WARN] = " ",
						[vim.diagnostic.severity.HINT] = "",
						[vim.diagnostic.severity.INFO] = " ",
					},
				},
				inlay_hints = {
					enabled = true,
				},
				codelens = {
					enabled = true,
				},
			})
		end,
	},
	{
		"stevearc/conform.nvim",
		event = { "BufReadPost", "BufWritePost", "BufNewFile" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {},
		config = function(opts)
			local function get_prettier_config()
				local config_files = {
					"package.json",
					".prettierrc",
					".prettierrc.json",
					".prettierrc.yml",
					".prettierrc.yaml",
					".prettierrc.json5",
					".prettierrc.js",
					"prettier.config.js",
					".prettierrc.mjs",
					"prettier.config.mjs",
					".prettierrc.cjs",
					"prettier.config.cjs",
					".prettierrc.toml",
				}

				local function file_exists_in_directory(directory, file)
					return vim.fn.filereadable(vim.fn.expand(directory .. "/" .. file)) == 1
				end

				local function find_config_file(starting_directory)
					local current_directory = starting_directory
					local root_directory = vim.fn.getcwd()

					while current_directory ~= "/" do
						for _, file in ipairs(config_files) do
							local file_path = current_directory .. "/" .. file
							if file_exists_in_directory(current_directory, file) then
								if file == "package.json" then
									local package_json = vim.fn.json_decode(vim.fn.readfile(file_path))
									if package_json["prettier"] then
										return file_path
									end
								else
									return file_path
								end
							end
						end
						if current_directory == root_directory then
							break
						end
						current_directory = vim.fn.fnamemodify(current_directory, ":h")
					end

					-- Return the fallback config if no config files are found
					return os.getenv("HOME") .. "/.config/nvim/utils/linter-config/.prettierrc.json"
				end

				return find_config_file(vim.fn.expand("%:p:h"))
			end
			require("conform").setup({
				notify_on_error = false,
				format_on_save = function(bufnr)
					-- Disable "format_on_save lsp_fallback" for languages that don't
					-- have a well standardized coding style. You can add additional
					-- languages here or re-enable it for the disabled ones.
					local disable_filetypes = { c = false, cpp = false, vue = false }

					if
						vim.g.disable_autoformat
						or vim.b[bufnr].disable_autoformat
						or disable_filetypes[vim.bo[bufnr].filetype]
					then
						return
					end
					return {
						timeout_ms = 500,
						lsp_fallback = true,
						async = false,
					}
				end,
				formatters_by_ft = {
					lua = { "stylua" },
					-- Conform can also run multiple formatters sequentially
					-- python = { "isort", "black" },
					--
					-- You can use a sub-list to tell conform to run *until* a formatter
					-- is found.
					javascript = { "prettier", stop_after_first = true },
					vue = { "prettier" },
					-- Use the "*" filetype to run formatters on all filetypes.
					["*"] = { "codespell" },
					-- Use the "_" filetype to run formatters on filetypes that don't
					-- have other formatters configured.
					["_"] = { "trim_whitespace" },
				},
				formatters = {
					prettier = {
						command = "prettier",
						args = function()
							local config = get_prettier_config()
							return { "--config", config, "--stdin-filepath", vim.fn.expand("%:p") }
						end,
						stdin = true,
					},
				},
			})

			vim.api.nvim_create_user_command("FormatDisable", function(args)
				if args.bang then
					-- FormatDisable! will disable formatting just for this buffer
					vim.b.disable_autoformat = true
				else
					vim.g.disable_autoformat = true
				end
			end, {
				desc = "Disable autoformat-on-save",
				bang = true,
			})
			vim.api.nvim_create_user_command("FormatEnable", function()
				vim.b.disable_autoformat = false
				vim.g.disable_autoformat = false
			end, {
				desc = "Re-enable autoformat-on-save",
			})
		end,
	},
}
