local status, treesitter = pcall(require, "nvim-treesitter.configs")
if not status then
	return
end

local lists = require("nvim-treesitter.parsers").get_parser_configs()

--[[ lists.vue = { ]]
--[[ 	install_info= { ]]
--[[ 		url ="", ]]
--[[ 		files = {"src/parser.c", "src/scanner.cc"}, ]]
--[[ 		branch = "master" ]]
--[[ 	} ]]
--[[ } ]]

treesitter.setup {
	-- A list of parser names, or "all" (the five listed parsers should always be installed)
	ensure_installed = {"javascript", "typescript", "rust", "c", "vim", "lua", "vimdoc", "html", "css", "tsx", "scss", "json", "regex", "vue" },
	-- Install parsers synchronously (only applied to `ensure_installed`)
	sync_install = false,

	-- Automatically install missing parsers when entering buffer
	-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
	auto_install = true,

	-- List of parsers to ignore installing (for "all")

	---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
	-- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

	highlight = {
		enable = true,
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
			additional_vim_regex_highlighting = false,
			custom_captures = {
				["attr.value"] = "TSKeyword"
			}
		},
		-- Plugins
		context_commentstring = {
			enable = true,
			enable_autocnd = false
		},
		autotag = {
			enable = true,
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
	}
	local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
	parser_config.tsx.filetype_to_parsername = { "javascript", "typescript.tsx", "tsx" }

	-- Path: treesitter-context.lua
	-- Treesitter context

	local present, treesitter_context = pcall(require, "treesitter-context")
	if not present then
		return
	end

	treesitter_context.setup{
		enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
		max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
		min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
		line_numbers = true,
		multiline_threshold = 20, -- Maximum number of lines to collapse for a single context line
		trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
		mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
		-- Separator between context and content. Should be a single character string, like '-'.
		-- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
		separator = nil,
		zindex = 20, -- The Z-index of the context window
	}











































