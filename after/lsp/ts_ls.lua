return {

	root_dir = function(bufnr, on_dir)
		local fname = vim.api.nvim_buf_get_name(bufnr)
		local lsp_utils = require("nick22985.utils.lsp-utils")
		local util = require("lspconfig.util")
		local root_dir = util.root_pattern("package.json", "vue.config.js")(fname)
		local isVue3 = root_dir and lsp_utils.is_vue3_project(root_dir)
		local isVue2 = root_dir and lsp_utils.is_vue2_project(root_dir)
		if isVue3 or isVue2 then
			return on_dir(root_dir)
		else
			return
		end
	end,
	settings = {
		analysis = {
			diagnosticMode = "workspace",
		},
	},
	capabilities = {
		workspace = {
			workspace = {
				didChangeWatchedFiles = {
					dynamicRegistration = true,
					relativePatternSupport = true,
				},
			},
		},
	},
	-- root_dir = function(bufnr, on_dir)
	-- 	-- disable using tsgo atm
	-- 	-- also use vtsls because vue 3 needs it
	-- 	return nil
	-- end,
	init_options = {
		plugins = {
			-- {
			-- 	name = "@vue/typescript-plugin",
			-- 	location = "/path/to/@vue/language-server",
			-- 	languages = { "vue" },
			-- },
		},
	},
}
