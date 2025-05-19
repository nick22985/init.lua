return {
	init_options = {
		languageFeatures = {
			typeDefinition = false,
		},
		vue = {
			hybridMode = false,
		},
	},
	root_dir = function(bufnr, on_dir)
		local fname = vim.api.nvim_buf_get_name(bufnr)

		local lsp_utils = require("nick22985.utils.lsp-utils")
		local util = require("lspconfig.util")
		local root_dir = util.root_pattern("package.json", "vue.config.js")(fname)
		local root = root_dir and lsp_utils.is_vue3_project(root_dir) and root_dir or nil

		if root then
			on_dir(root)
		else
			return nil
		end
	end,
}
