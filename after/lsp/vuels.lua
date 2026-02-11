---@brief
---
--- https://github.com/vuejs/vetur/tree/master/server
---
--- Vue language server(vls)
--- `vue-language-server` can be installed via `npm`:
--- ```sh
--- npm install -g vls
--- ```
return {
	cmd = { "vls" },
	filetypes = { "vue" },
	root_markers = { "package.json", "vue.config.js" },
	init_options = {
		config = {
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
				useWorkspaceDependencies = false,
				validation = {
					template = true,
					style = true,
					script = true,
				},
				completion = {
					autoImport = false,
					useScaffoldSnippets = false,
					tagCasing = "kebab",
				},
				format = {
					defaultFormatter = {
						js = "none",
						ts = "none",
					},
					defaultFormatterOptions = {},
					scriptInitialIndent = false,
					styleInitialIndent = false,
				},
			},
			css = {},
			html = {
				suggest = {},
			},
			javascript = {
				format = {},
			},
			typescript = {
				format = {},
			},
			emmet = {},
			stylusSupremacy = {},
		},
	},
	root_dir = function(bufnr, on_dir)
		local fname = vim.api.nvim_buf_get_name(bufnr)

		local lsp_utils = require("nick22985.utils.lsp-utils")
		local util = require("lspconfig.util")
		local root_dir = util.root_pattern("package.json", "vue.config.js")(fname)
		local root = root_dir and lsp_utils.is_vue2_project(root_dir) and root_dir or nil
		if root then
			on_dir(root)
		else
			return nil
		end
	end,
}
