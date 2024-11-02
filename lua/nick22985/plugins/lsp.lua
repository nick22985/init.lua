return { -- LSP Configuration & Plugins
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPost", "BufWritePost", "BufNewFile" },
		dependencies = {
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },
			{ "WhoIsSethDaniel/mason-tool-installer.nvim" },
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
		},
		config = function()
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

					map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

					map("K", vim.lsp.buf.hover, "Hover Documentation")

					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

					local client = vim.lsp.get_client_by_id(event.data.client_id)
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
							vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled())
						end, "[T]oggle Inlay [H]ints")
					end
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

			local cmp_lsp = require("cmp_nvim_lsp")
			local capabilities = vim.tbl_deep_extend(
				"force",
				{},
				vim.lsp.protocol.make_client_capabilities(),
				cmp_lsp.default_capabilities()
			)

			local servers = {
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
				tsserver = {
					init_options = {
						plugins = {
							-- {
							-- 	name = "@vue/typescript-plugin",
							-- 	location = "/path/to/@vue/language-server",
							-- 	languages = { "vue" },
							-- },
						},
					},
				},
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
								directive = "javascript",
								endpoint = "javascript",
								filter = "javascript",
								macgyver = "javascript",
								schema = "javascript",
								server = "javascript",
								service = "javascript",
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
			}

			require("mason").setup()

			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua", -- Used to format Lua code
				"tailwindcss",
				"gopls",
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			require("mason-lspconfig").setup({
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})

			vim.diagnostic.config({
				underline = true,
				update_in_insert = true,
				virtual_text = {
					spacing = 4,
					source = "if_many",
					prefix = "●",
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
					if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
						return
					end
					local disable_filetypes = { c = false, cpp = false, vue = false }
					return {
						timeout_ms = 500,
						lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
					}
				end,
				formatters_by_ft = {
					lua = { "stylua" },
					-- Conform can also run multiple formatters sequentially
					-- python = { "isort", "black" },
					--
					-- You can use a sub-list to tell conform to run *until* a formatter
					-- is found.
					javascript = { { "prettier" } },
					vue = { "prettier" },
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
	{ -- Autocompletion
		"hrsh7th/nvim-cmp",
		branch = "main",
		dependencies = {
			-- Snippet Engine & its associated nvim-cmp source
			{
				"L3MON4D3/LuaSnip",
				build = (function()
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
				dependencies = {
					"rafamadriz/friendly-snippets",
					config = function()
						require("luasnip.loaders.from_vscode").lazy_load()
					end,
				},
			},
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lua",
			"onsails/lspkind.nvim",
			"hrsh7th/nvim-cmp",
			"jcha0713/cmp-tw2css",
			{
				"zbirenbaum/copilot-cmp",
				dependencies = {
					"zbirenbaum/copilot.lua",
				},
			},
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local lspkind = require("lspkind")
			-- local copilot_cmp = require("copilot_cmp")
			-- copilot_cmp.setup()

			lspkind.init({
				-- defines how annotations are shown
				-- default: symbol
				-- options: 'text', 'text_symbol', 'symbol_text', 'symbol'
				mode = "symbol_text",

				-- default symbol map
				-- can be either 'default' (requires nerd-fonts font) or
				-- 'codicons' for codicon preset (requires vscode-codicons font)
				--
				-- default: 'default'
				preset = "codicons",

				-- override preset symbols
				--
				-- default: {}
				symbol_map = {
					Text = "󰉿",
					Method = "󰆧",
					Function = "󰊕",
					Constructor = "",
					Field = "󰜢",
					Variable = "󰀫",
					Class = "󰠱",
					Interface = "",
					Module = "",
					Property = "󰜢",
					Unit = "󰑭",
					Value = "󰎠",
					Enum = "",
					Keyword = "󰌋",
					Snippet = "",
					Color = "󰏘",
					File = "󰈙",
					Reference = "󰈇",
					Folder = "󰉋",
					EnumMember = "",
					Constant = "󰏿",
					Struct = "󰙅",
					Event = "",
					Operator = "󰆕",
					TypeParameter = "",
					Copilot = "",
				},
			})

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				preselect = cmp.PreselectMode.None,
				completion = { completeopt = "menu,menuone,noinsert" },
				perfomance = {
					max_view_entries = 7,
				},
				formatting = {
					format = function(entry, vim_item)
						if vim.tbl_contains({ "path" }, entry.source.name) then
							local icon, hl_group =
								require("nvim-web-devicons").get_icon(entry:get_completion_item().label)
							if icon then
								vim_item.kind = icon
								vim_item.kind_hl_group = hl_group
								return vim_item
							end
						end
						return lspkind.cmp_format({
							-- mode = "symbol", -- show only symbol annotations
							maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
							-- can also be a function to dynamically calculate max width such as
							-- maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
							ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
							show_labelDetails = true, -- show labelDetails in menu. Disabled by default
							menu = {
								buffer = "[Buffer]",
								nvim_lsp = "[LSP]",
								luasnip = "[LuaSnip]",
								nvim_lua = "[Lua]",
								latex_symbols = "[Latex]",
							},
							-- The function below will be called before any actual modifications from lspkind
							-- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
							before = function(entry, vim_item)
								return vim_item
							end,
						})(entry, vim_item)
					end,
					-- format =
					-- expandable_indicator = true,
					-- fields = {},
				},

				mapping = cmp.mapping.preset.insert({
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-p>"] = cmp.mapping.select_prev_item(),

					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),

					["<C-y>"] = cmp.mapping.confirm({ select = true }),

					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.close(),

					["<C-l>"] = cmp.mapping(function()
						if luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						end
					end, { "i", "s" }),
					["<C-h>"] = cmp.mapping(function()
						if luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						end
					end, { "i", "s" }),

					-- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
					--    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
				}),
				sources = {
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "path" },
					{ name = "copilot" },
					{ name = "cmp-tw2css" },
				},
			})

			luasnip.config.setup({
				history = true,
				-- updateevents = "TextChanged,TextChangedI",
			})
			for _, ft_path in ipairs(vim.api.nvim_get_runtime_file("lua/nick22985/snippets/*.lua", true)) do
				loadfile(ft_path)()
			end
			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
			})

			-- Set configuration for specific filetype.
			cmp.setup.filetype("gitcommit", {
				sources = cmp.config.sources({
					{ name = "git" }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
				}, {
					{ name = "buffer" },
				}),
			})
		end,
	},
}
