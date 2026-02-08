local home = os.getenv("HOME")

local cmd = {
	vim.fn.stdpath("data") .. "/mason/bin/jdtls",
	-- Lombok support
	"--jvm-arg=-javaagent:"
		.. vim.fn.stdpath("data")
		.. "/mason/packages/jdtls/lombok.jar",
	-- Performance and memory settings
	"--jvm-arg=-Xmx2G",
	"--jvm-arg=-XX:+UseG1GC",
	"--jvm-arg=-XX:+UseStringDeduplication",
	-- Maven source/javadoc settings
	"--jvm-arg=-Dmaven.source.skip=false",
	"--jvm-arg=-Dmaven.javadoc.skip=false",
	"--jvm-arg=-Dfile.encoding=UTF-8",
}

-- Set up custom commands and DAP integration
-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = "java",
-- 	callback = function(args)
-- 		local bufnr = args.buf
--
-- 		-- Add Java project management commands
-- 		vim.api.nvim_buf_create_user_command(bufnr, "JdtReloadProjects", function()
-- 			require("jdtls").update_project_config()
-- 			print("JDTLS: Project configuration reloaded")
-- 		end, { desc = "Reload JDTLS project configuration" })
--
-- 		vim.api.nvim_buf_create_user_command(bufnr, "JdtCleanReload", function()
-- 			require("jdtls").clean_workspace()
-- 			vim.defer_fn(function()
-- 				require("jdtls").update_project_config()
-- 				print("JDTLS: Workspace cleaned and reloaded")
-- 			end, 1000)
-- 		end, { desc = "Clean and reload JDTLS workspace" })
-- 	end,
-- })

return {
	cmd = cmd,
	root_markers = { ".git", "mvnw", "gradlew", "pom.xml" },
	settings = {
		java = {
			configuration = {
				maven = {
					userSettings = home .. "/.m2/settings.xml",
					globalSettings = "",
					notCoveredPluginExecutionSeverity = "ignore",
				},
			},
			eclipse = {
				downloadSources = true,
				downloadJavadoc = true,
			},
			maven = {
				downloadSources = true,
				downloadJavadoc = true,
				updateSnapshots = false,
				userSettings = home .. "/.m2/settings.xml",
			},
			gradle = {
				downloadSources = true,
				downloadJavadoc = true,
			},
			implementationsCodeLens = { enabled = true },
			referencesCodeLens = { enabled = true },
			signatureHelp = { enabled = true, description = { enabled = false } },
			hover = { enabled = true },
			inlayHints = {
				parameterNames = {
					enabled = "all",
				},
			},
			contentProvider = {
				preferred = "fernflower",
				includeDecompiledSources = true,
			},
			sources = {
				organizeImports = {
					starThreshold = 9999,
					staticStarThreshold = 9999,
				},
			},
			completion = {
				favoriteStaticMembers = {
					"org.junit.Assert.*",
					"org.junit.Assume.*",
					"org.junit.jupiter.api.Assertions.*",
					"org.junit.jupiter.api.Assumptions.*",
					"org.mockito.Mockito.*",
					"org.mockito.ArgumentMatchers.*",
				},
				filteredTypes = {
					"com.sun.*",
					"io.micrometer.shaded.*",
					"java.awt.*",
					"jdk.*",
					"sun.*",
				},
				importOrder = {
					"java",
					"javax",
					"com",
					"org",
				},
			},
			format = {
				settings = {
					url = home .. "/.config/nvim/rule/eclipse-java-google-style.xml",
					profile = "GoogleStyle",
				},
			},
			decompiler = {
				enabled = true,
				showInEditor = true,
			},
			autobuild = { enabled = true },
			maxConcurrentBuilds = 1,
			saveActions = {
				organizeImports = true,
			},
			import = {
				maven = { enabled = true },
				gradle = { enabled = true },
				exclusions = {
					"**/node_modules/**",
					"**/.metadata/**",
					"**/archetype-resources/**",
					"**/META-INF/maven/**",
				},
			},
		},
	},
}
