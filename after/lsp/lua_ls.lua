return {
	-- cmd = {...},
	-- filetypes = { ...},
	-- capabilities = {
	-- 	workspace = {
	-- 		didChangeWatchedFiles = {
	-- 			dynamicRegistration = true,
	-- 		},
	-- 	},
	-- },
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
				path = vim.split(package.path, ";"),
			},
			completion = {
				callSnippet = "Replace",
			},
			diagnostics = {
				globals = { "it", "describe", "before_each", "after_each", "vim" },
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
			telemetry = {
				enable = false,
			},
		},
	},
}
