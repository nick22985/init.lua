---@brief
---
--- https://projects.eclipse.org/projects/eclipse.jdt.ls
---
--- Language server for Java.
---
--- IMPORTANT: If you want all the features jdtls has to offer, [nvim-jdtls](https://github.com/mfussenegger/nvim-jdtls)
--- is highly recommended. If all you need is diagnostics, completion, imports, gotos and formatting and some code actions
--- you can keep reading here.
---
--- For manual installation you can download precompiled binaries from the
--- [official downloads site](http://download.eclipse.org/jdtls/snapshots/?d)
--- and ensure that the `PATH` variable contains the `bin` directory of the extracted archive.
---
--- ```lua
---   -- init.lua
---   vim.lsp.enable('jdtls')
--- ```
---
--- You can also pass extra custom jvm arguments with the JDTLS_JVM_ARGS environment variable as a space separated list of arguments,
--- that will be converted to multiple --jvm-arg=<param> args when passed to the jdtls script. This will allow for example tweaking
--- the jvm arguments or integration with external tools like lombok:
---
--- ```sh
--- export JDTLS_JVM_ARGS="-javaagent:$HOME/.local/share/java/lombok.jar"
--- ```
---
--- For automatic installation you can use the following unofficial installers/launchers under your own risk:
---   - [jdtls-launcher](https://github.com/eruizc-dev/jdtls-launcher) (Includes lombok support by default)
---     ```lua
---       -- init.lua
---       vim.lsp.config('jdtls', { cmd = { 'jdtls' } })
---     ```

local home = os.getenv("HOME")

-- local cmd = {
-- 	vim.fn.stdpath("data") .. "/mason/bin/jdtls",
-- 	"-configuration",
-- 	jdtls_config_dir(project),
-- 	"-data",
-- 	jdtls_workspace_dir(project),
-- 	-- Lombok support
-- 	-- Performance and memory settings
-- 	"--jvm-arg=-Xmx2G",
-- 	"--jvm-arg=-XX:+UseG1GC",
-- 	"--jvm-arg=-XX:+UseStringDeduplication",
-- 	-- Maven source/javadoc settings
-- 	"--jvm-arg=-Dmaven.source.skip=false",
-- 	"--jvm-arg=-Dmaven.javadoc.skip=false",
-- 	"--jvm-arg=-Dfile.encoding=UTF-8",
-- }
local function get_jdtls_cache_dir()
	return vim.fn.stdpath("cache") .. "/jdtls"
end

local function get_jdtls_workspace_dir()
	return get_jdtls_cache_dir() .. "/workspace"
end
local function get_jdtls_config_dir()
	return get_jdtls_cache_dir() .. "/config"
end

local function get_jdtls_jvm_args()
	local env = os.getenv("JDTLS_JVM_ARGS")
	local args = {}
	for a in string.gmatch((env or ""), "%S+") do
		local arg = string.format("--jvm-arg=%s", a)
		table.insert(args, arg)
	end
	return unpack(args)
end

local root_markers1 = {
	-- Multi-module projects
	"mvnw", -- Maven
	"gradlew", -- Gradle
	"settings.gradle", -- Gradle
	"settings.gradle.kts", -- Gradle
	-- Use git directory as last resort for multi-module maven projects
	-- In multi-module maven projects it is not really possible to determine what is the parent directory
	-- and what is submodule directory. And jdtls does not break if the parent directory is at higher level than
	-- actual parent pom.xml so propagating all the way to root git directory is fine
	".git",
}
local root_markers2 = {
	-- Single-module projects
	"build.xml", -- Ant
	"pom.xml", -- Maven
	"build.gradle", -- Gradle
	"build.gradle.kts", -- Gradle
}

---@type vim.lsp.Config
return {
	---@param dispatchers? vim.lsp.rpc.Dispatchers
	---@param config vim.lsp.ClientConfig
	cmd = function(dispatchers, config)
		local workspace_dir = get_jdtls_workspace_dir()
		local workspace_config_dir = get_jdtls_config_dir()
		local data_dir = workspace_dir
		local config_dir = workspace_config_dir

		if config.root_dir then
			data_dir = data_dir .. "/" .. vim.fn.fnamemodify(config.root_dir, ":p:h:t")
		end
		if config.root_dir then
			data_dir = config_dir .. "/" .. vim.fn.fnamemodify(config.root_dir, ":p:h:t")
		end

		local config_cmd = {
			"jdtls",
			"-data",
			data_dir,
			"-configuration",
			config_dir,
			get_jdtls_jvm_args(),
		}

		return vim.lsp.rpc.start(config_cmd, dispatchers, {
			cwd = config.cmd_cwd,
			env = config.cmd_env,
			detached = config.detached,
		})
	end,
	filetypes = { "java" },
	root_markers = vim.fn.has("nvim-0.11.3") == 1 and { root_markers1, root_markers2 }
		or vim.list_extend(root_markers1, root_markers2),

	-- settings = {
	-- 	java = {
	-- 		configuration = {
	-- 			maven = {
	-- 				userSettings = home .. "/.m2/settings.xml",
	-- 				globalSettings = "",
	-- 				notCoveredPluginExecutionSeverity = "ignore",
	-- 			},
	-- 		},
	-- 		eclipse = {
	-- 			downloadSources = true,
	-- 			downloadJavadoc = true,
	-- 		},
	-- 		project = {
	-- 			annotationProcessorEnabled = true,
	-- 			referencedLibraries = { "**/*.jar" },
	-- 		},
	-- 		maven = {
	-- 			downloadSources = true,
	-- 			downloadJavadoc = true,
	-- 			updateSnapshots = false,
	-- 			userSettings = home .. "/.m2/settings.xml",
	-- 		},
	-- 		gradle = {
	-- 			downloadSources = true,
	-- 			downloadJavadoc = true,
	-- 			annotationProcessing = { enabled = true },
	-- 			buildServer = { enabled = "on" },
	-- 			refreshDelay = 1000,
	-- 		},
	-- 		implementationsCodeLens = { enabled = true },
	-- 		referencesCodeLens = { enabled = true },
	-- 		signatureHelp = { enabled = true, description = { enabled = false } },
	-- 		hover = { enabled = true },
	-- 		codeGeneration = {
	-- 			toString = {
	-- 				template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
	-- 			},
	-- 			useBlocks = true,
	-- 		},
	-- 		inlayHints = {
	-- 			parameterNames = {
	-- 				enabled = "all",
	-- 			},
	-- 		},
	-- 		contentProvider = {
	-- 			preferred = "fernflower",
	-- 			includeDecompiledSources = true,
	-- 		},
	-- 		sources = {
	-- 			organizeImports = {
	-- 				starThreshold = 9999,
	-- 				staticStarThreshold = 9999,
	-- 			},
	-- 		},
	-- 		completion = {
	-- 			-- favoriteStaticMembers = {
	-- 			-- 	"org.junit.Assert.*",
	-- 			-- 	"org.junit.Assume.*",
	-- 			-- 	"org.junit.jupiter.api.Assertions.*",
	-- 			-- 	"org.junit.jupiter.api.Assumptions.*",
	-- 			-- 	"org.mockito.Mockito.*",
	-- 			-- 	"org.mockito.ArgumentMatchers.*",
	-- 			-- },
	-- 			-- filteredTypes = {
	-- 			-- 	"com.sun.*",
	-- 			-- 	"io.micrometer.shaded.*",
	-- 			-- 	"java.awt.*",
	-- 			-- 	"jdk.*",
	-- 			-- 	"sun.*",
	-- 			-- },
	-- 			-- importOrder = {
	-- 			-- 	"java",
	-- 			-- 	"javax",
	-- 			-- 	"com",
	-- 			-- 	"org",
	-- 			-- },
	-- 		},
	-- 		-- format = {
	-- 		-- 	settings = {
	-- 		-- 		url = home .. "/.config/nvim/rule/eclipse-java-google-style.xml",
	-- 		-- 		profile = "GoogleStyle",
	-- 		-- 	},
	-- 		-- },
	-- 		decompiler = {
	-- 			enabled = true,
	-- 			showInEditor = true,
	-- 		},
	-- 		autobuild = { enabled = true },
	-- 		maxConcurrentBuilds = 1,
	-- 		buildPath = {
	-- 			useGradleDependencies = true,
	-- 		},
	-- 		-- Error handling and logging
	-- 		errors = {
	-- 			incompleteClasspath = {
	-- 				severity = "ignore",
	-- 			},
	-- 		},
	-- 		-- saveActions = {
	-- 		-- 	organizeImports = true,
	-- 		-- },
	-- 		import = {
	-- 			maven = { enabled = true },
	-- 			gradle = {
	-- 				enabled = true,
	-- 				wrapper = { enabled = true },
	-- 				version = "wrapper",
	-- 				offline = false,
	-- 				arguments = {},
	-- 				jvmArguments = {},
	-- 				user = { home = home .. "/.gradle" },
	-- 			},
	-- 			exclusions = {
	-- 				"**/node_modules/**",
	-- 				"**/.metadata/**",
	-- 				"**/archetype-resources/**",
	-- 				"**/META-INF/maven/**",
	-- 			},
	-- 		},
	-- 		compile = {
	-- 			nullAnalysis = {
	-- 				mode = "automatic",
	-- 			},
	-- 		},
	-- 	},
	-- },
}
