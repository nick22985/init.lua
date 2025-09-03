return {
	filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
	settings = {
		autoUseWorkspaceTsdk = false,
	},
	root_dir = function(bufnr, on_dir)
		-- using tsgo for normal ts projects for now
		-- vue_ls requires this to work
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
