local ENSURE_INSTALLED = {
	"javascript",
	"typescript",
	"tsx",
	"rust",
	"c",
	"vim",
	"vimdoc",
	"lua",
	"html",
	"css",
	"scss",
	"json",
	"regex",
	"markdown",
	"markdown_inline",
	"go",
	"java",
	"bash",
	"query",
	"diff",
	"gitcommit",
	"git_rebase",
	"gitattributes",
	"git_config",
	"gitignore",
}

return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		dependencies = {
			"JoosepAlviste/nvim-ts-context-commentstring",
			"windwp/nvim-ts-autotag",
		},
		config = function()
			local ts = require("nvim-treesitter")
			ts.install(ENSURE_INSTALLED)

			local function attach(buf)
				if not pcall(vim.treesitter.start, buf) then
					return
				end
				vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end

			local seen = {}
			vim.api.nvim_create_autocmd("FileType", {
				callback = function(ev)
					local lang = vim.treesitter.language.get_lang(ev.match) or ev.match
					if vim.list_contains(ts.get_installed(), lang) then
						attach(ev.buf)
						return
					end
					if seen[lang] or not vim.list_contains(ts.get_available(), lang) then
						return
					end
					seen[lang] = true
					ts.install(lang):await(function()
						if vim.api.nvim_buf_is_valid(ev.buf) then
							attach(ev.buf)
						end
					end)
				end,
			})

			vim.treesitter.language.register("bash", "zsh")

			require("ts_context_commentstring").setup({
				enable_autocmd = false,
			})
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		event = "VeryLazy",
		config = function()
			require("nvim-treesitter-textobjects").setup({
				select = {
					lookahead = true,
					selection_modes = {
						["@parameter.outer"] = "v",
						["@function.outer"] = "V",
						["@class.outer"] = "<c-v>",
					},
					include_surrounding_whitespace = true,
				},
				move = {
					set_jumps = true,
				},
			})

			local select = require("nvim-treesitter-textobjects.select")
			local move = require("nvim-treesitter-textobjects.move")

			local function sel(q, group)
				return function()
					select.select_textobject(q, group or "textobjects")
				end
			end

			vim.keymap.set({ "x", "o" }, "af", sel("@function.outer"))
			vim.keymap.set({ "x", "o" }, "if", sel("@function.inner"))
			vim.keymap.set({ "x", "o" }, "ac", sel("@class.outer"))
			vim.keymap.set({ "x", "o" }, "ic", sel("@class.inner"), { desc = "Select inner part of a class region" })
			vim.keymap.set({ "x", "o" }, "as", sel("@local.scope", "locals"), { desc = "Select language scope" })

			local nxo = { "n", "x", "o" }
			vim.keymap.set(nxo, "]m", function()
				move.goto_next_start("@function.outer", "textobjects")
			end)
			vim.keymap.set(nxo, "]]", function()
				move.goto_next_start("@class.outer", "textobjects")
			end, { desc = "Next class start" })
			vim.keymap.set(nxo, "]o", function()
				move.goto_next_start({ "@loop.inner", "@loop.outer" }, "textobjects")
			end)
			vim.keymap.set(nxo, "]s", function()
				move.goto_next_start("@local.scope", "locals")
			end, { desc = "Next scope" })
			vim.keymap.set(nxo, "]z", function()
				move.goto_next_start("@fold", "folds")
			end, { desc = "Next fold" })

			vim.keymap.set(nxo, "]M", function()
				move.goto_next_end("@function.outer", "textobjects")
			end)
			vim.keymap.set(nxo, "][", function()
				move.goto_next_end("@class.outer", "textobjects")
			end)

			vim.keymap.set(nxo, "[m", function()
				move.goto_previous_start("@function.outer", "textobjects")
			end)
			vim.keymap.set(nxo, "[[", function()
				move.goto_previous_start("@class.outer", "textobjects")
			end)

			vim.keymap.set(nxo, "[M", function()
				move.goto_previous_end("@function.outer", "textobjects")
			end)
			vim.keymap.set(nxo, "[]", function()
				move.goto_previous_end("@class.outer", "textobjects")
			end)

			vim.keymap.set(nxo, "]d", function()
				move.goto_next("@conditional.outer", "textobjects")
			end)
			vim.keymap.set(nxo, "[d", function()
				move.goto_previous("@conditional.outer", "textobjects")
			end)
		end,
	},

	{
		"windwp/nvim-ts-autotag",
		event = "InsertEnter",
		opts = {
			opts = {
				enable_close = true,
				enable_rename = true,
				enable_close_on_slash = true,
			},
		},
	},
}
