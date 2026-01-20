return {
	init_options = {
		extendedClientCapabilities = {
			-- Switching to standard LSP progress events (as soon as it lands, see link)
			-- https://github.com/eclipse/eclipse.jdt.ls/pull/2030#issuecomment-1210815017
			progressReportProvider = false,
		},
		-- typescript = {
		-- 	serverPath =
		-- }
	},
	settings = {
		-- java = {
		-- 	contentProvider = { preferred = "fernflower" },
		-- 	eclipse = { downloadSources = true },
		-- 	maven = { downloadSources = true },
		-- 	implementationsCodeLens = { enabled = true },
		-- 	referencesCodeLens = { enabled = true },
		-- 	sources = {
		-- 		organizeImports = {
		-- 			starThreshold = 9999,
		-- 			staticStarThreshold = 9999,
		-- 		},
		-- 	},
		-- },
	},
	-- handlers = {
	-- 	["language/status"] = function(_, result)
	-- 		-- vim.print(result)
	-- 	end,
	-- 	["$/progress"] = function(_, result, ctx)
	-- 		-- vim.print(result)
	-- 	end,
	-- },
	on_attach = function(client, bufnr) end,
}
