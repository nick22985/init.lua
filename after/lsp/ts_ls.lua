return {
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
