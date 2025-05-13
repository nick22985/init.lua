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
