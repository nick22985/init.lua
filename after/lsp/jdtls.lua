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
	-- handlers = {
	-- 	["language/status"] = function(_, result)
	-- 		-- vim.print(result)
	-- 	end,
	-- 	["$/progress"] = function(_, result, ctx)
	-- 		-- vim.print(result)
	-- 	end,
	-- },
}
