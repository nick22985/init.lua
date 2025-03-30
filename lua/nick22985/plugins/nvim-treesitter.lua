return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = "VeryLazy",
		dependencies = {
			"JoosepAlviste/nvim-ts-context-commentstring",
			"nvim-treesitter/nvim-treesitter-textobjects",
			"nvim-treesitter/playground",
			"windwp/nvim-ts-autotag",
		},
		config = function()
			local status, treesitter = pcall(require, "nvim-treesitter.configs")
			if not status then
				return
			end

			treesitter.setup({
				-- A list of parser names, or "all" (the five listed parsers should always be installed)
				ensure_installed = {
					"javascript",
					"typescript",
					"rust",
					"c",
					"vim",
					"lua",
					"vimdoc",
					"html",
					"css",
					"scss",
					"tsx",
					"scss",
					"json",
					"regex",
					"markdown_inline",
					"go",
				},
				-- Install parsers synchronously (only applied to `ensure_installed`)
				ingore_install = {},
				sync_install = false,

				-- Automatically install missing parsers when entering buffer
				-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
				auto_install = true,

				-- List of parsers to ignore installing (for "all")

				---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
				-- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

				highlight = {
					enable = true,
					-- disable = function(lang, buf)
					-- 	if lang == "html" then
					-- 		print("disabled")
					-- 		return true
					-- 	end
					--
					-- 	local max_filesize = 100 * 1024 -- 100 KB
					-- 	local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
					-- 	if ok and stats and stats.size > max_filesize then
					-- 		vim.notify(
					-- 			"File larger than 100KB treesitter disabled for performance",
					-- 			vim.log.levels.WARN,
					-- 			{ title = "Treesitter" }
					-- 		)
					-- 		return true
					-- 	end
					-- end,
					injections = {
						enable = true,
					},
					-- Disable vue until there is custom block support or all projects move to vue3
					-- disable = {"vue"},
					-- disable = function(lang, buf)
					--     local max_filesize = 100 * 1024 -- 100 KB
					--     local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
					--     if ok and stats and stats.size > max_filesize then
					--         return true
					--     end
					-- end,
					--
					-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
					-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
					-- Using this option may slow down your editor, and you may see some duplicate highlights.
					-- Instead of true it can also be a list of languages
					-- disable = { "vue" },
					additional_vim_regex_highlighting = false,
					custom_captures = {
						["attr.value"] = "TSKeyword",
						-- ["non_standard"] = "NonStandardASCII",
						-- ["invisible"] = "InvisibleCharacters",
					},
				},
				-- Plug 'pangloss/vim-javascript'
				-- let g:javascript_conceal = 1
				-- let g:javascript_conceal_function = "λ"
				-- let g:javascript_conceal_null = "ø"
				-- let g:javascript_conceal_this = "◉"
				-- let g:javascript_conceal_ctrl = "◈"
				-- let g:javascript_conceal_return = "∴"
				-- let g:javascript_conceal_undefined = "¿"
				-- let g:javascript_conceal_NaN = "ℕ"
				-- let g:javascript_conceal_prototype = "¶"
				-- let g:javascript_conceal_static = "•"
				-- let g:javascript_conceal_super = "Ω"
				-- let g:javascript_conceal_question = "¿"
				-- let g:javascript_conceal_arrow_function = "🡆"
				-- let g:javascript_conceal_noarg_arrow_function = "🞅"
				-- let g:javascript_conceal_underscore_arrow_function = "🞅"
				-- set conceallevel=1

				-- conceal = {
				-- 	enable = true,
				-- 	disalbe = {},
				-- 	custom_captures = {
				-- 		["return"] = "∴",
				-- 		["arrow_function"] = "🡆",
				-- 	},
				-- },
				-- Plugins
				autotag = {
					enable = true,
					enable_rename = true,
					enable_close = true,
					enable_close_on_slash = true,
				},
				playground = {
					enable = true,
					updatetime = 25,
					persist_queries = true,
					keybindings = {
						toggle_query_editor = "o",
						toggle_hl_groups = "i",
						toggle_injected_languages = "t",

						-- This shows stuff like literal strings, commas, etc.
						toggle_anonymous_nodes = "a",
						toggle_language_display = "I",
						focus_language = "f",
						unfocus_language = "F",
						update = "R",
						goto_node = "<cr>",
						show_help = "?",
					},
				},
				textobjects = {
					select = {
						enable = true,

						-- Automatically jump forward to textobj, similar to targets.vim
						lookahead = true,

						keymaps = {
							-- You can use the capture groups defined in textobjects.scm
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							-- You can optionally set descriptions to the mappings (used in the desc parameter of
							-- nvim_buf_set_keymap) which plugins like which-key display
							["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
							-- You can also use captures from other query groups like `locals.scm`
							["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
						},
						-- You can choose the select mode (default is charwise 'v')
						--
						-- Can also be a function which gets passed a table with the keys
						-- * query_string: eg '@function.inner'
						-- * method: eg 'v' or 'o'
						-- and should return the mode ('v', 'V', or '<c-v>') or a table
						-- mapping query_strings to modes.
						selection_modes = {
							["@parameter.outer"] = "v", -- charwise
							["@function.outer"] = "V", -- linewise
							["@class.outer"] = "<c-v>", -- blockwise
						},
						-- If you set this to `true` (default is `false`) then any textobject is
						-- extended to include preceding or succeeding whitespace. Succeeding
						-- whitespace has priority in order to act similarly to eg the built-in
						-- `ap`.
						--
						-- Can also be a function which gets passed a table with the keys
						-- * query_string: eg '@function.inner'
						-- * selection_mode: eg 'v'
						-- and should return true of false
						include_surrounding_whitespace = true,
					},
					-- swap = {
					-- 	enable = true,
					-- 	swap_next = {
					-- 		["<leader>a"] = "@parameter.inner",
					-- 	},
					-- 	swap_previous = {
					-- 		["<leader>A"] = "@parameter.inner",
					-- 	},
					-- },
					move = {
						enable = true,
						set_jumps = true, -- whether to set jumps in the jumplist
						goto_next_start = {
							["]m"] = "@function.outer",
							["]]"] = { query = "@class.outer", desc = "Next class start" },
							--
							-- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queires.
							["]o"] = "@loop.*",
							-- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
							--
							-- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
							-- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
							["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
							["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
						},
						goto_next_end = {
							["]M"] = "@function.outer",
							["]["] = "@class.outer",
						},
						goto_previous_start = {
							["[m"] = "@function.outer",
							["[["] = "@class.outer",
						},
						goto_previous_end = {
							["[M"] = "@function.outer",
							["[]"] = "@class.outer",
						},
						-- Below will go to either the start or the end, whichever is closer.
						-- Use if you want more granular movements
						-- Make it even more gradual by adding multiple queries and regex.
						goto_next = {
							["]d"] = "@conditional.outer",
						},
						goto_previous = {
							["[d"] = "@conditional.outer",
						},
					},
					lsp_interop = {
						enable = true,
						border = "none",
						floating_preview_opts = {},
						peek_definition_code = {
							["<leader>df"] = "@function.outer",
							["<leader>dF"] = "@class.outer",
						},
					},
				},
			})
			-- highlight for characters
			-- vim.cmd("highlight NonStandardASCII ctermbg=red guibg=red")
			-- vim.cmd("highlight InvisibleCharacters ctermbg=blue guibg=blue")

			local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
			parser_config.tsx.filetype_to_parsername = { "javascript", "typescript.tsx", "tsx" }

			parser_config.vue = {
				install_info = {
					-- use custom parser
					-- has to be local putting a url does not work
					url = "~/.config/treesitterCustom/tree-sitter-vue",
					-- files = { "src/parser.c", "src/scanner.c" }, -- note that some parsers also require src/scanner.c or src/scanner.cc
					-- -- generate_requires_npm = true, -- if stand-alone parser without npm dependencies
					-- -- requires_generate_from_grammar = true, -- if folder contains pre-generated src/parser.c
					filetype = { "vue", "doop" },
					-- generate_requires_npm = true,
					-- requires_generate_from_grammar = true,

					-- url = "https://github.com/nick22985/tree-sitter-vue.git",
					branch = "main",
					files = { "src/parser.c", "src/scanner.c" },
				},
				maintainer = {
					"@nick22985",
				},
			}
			vim.treesitter.language.register("bash", "zsh")
			vim.treesitter.language.register("vue", "vue")

			require("ts_context_commentstring").setup({
				context_commentstring = {
					enable = true,
					enable_autocnd = true,
				},
			})
		end,
	},
	-- {
	-- 	"nvim-treesitter/nvim-treesitter-context",
	-- 	after = "nvim-treesitter",
	-- 	config = function()
	-- 		require("treesitter-context").setup({
	-- 			enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
	-- 			multiwindow = false, -- Enable multiwindow support.
	-- 			max_lines = 3, -- How many lines the window should span. Values <= 0 mean no limit.
	-- 			min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
	-- 			line_numbers = true,
	-- 			multiline_threshold = 20, -- Maximum number of lines to show for a single context
	-- 			trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
	-- 			mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
	-- 			-- Separator between context and content. Should be a single character string, like '-'.
	-- 			-- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
	-- 			separator = nil,
	-- 			zindex = 20, -- The Z-index of the context window
	-- 			on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
	-- 		})
	-- 	end,
	-- },
}
