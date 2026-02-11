return {
	-- delete once https://github.com/neovim/nvim-lspconfig/pull/3977/files merges
	cmd = { "vue-language-server", "--stdio" },
	filetypes = { "vue" },
	root_markers = { "package.json" },
	on_init = function(client)
		client.handlers["tsserver/request"] = function(_, result, context)
			local clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = "vtsls" })
			if #clients == 0 then
				vim.notify("Could not find `vtsls` lsp client, required by `vue_ls`.", vim.log.levels.ERROR)
				return
			end
			local ts_client = clients[1]

			local param = unpack(result)
			local id, command, payload = unpack(param)
			ts_client:exec_cmd({
				title = "vue_request_forward", -- You can give title anything as it's used to represent a command in the UI, `:h Client:exec_cmd`
				command = "typescript.tsserverRequest",
				arguments = {
					command,
					payload,
				},
			}, { bufnr = context.bufnr }, function(_, r)
				local response_data = { { id, r and r.body } }
				---@diagnostic disable-next-line: param-type-mismatch
				client:notify("tsserver/response", response_data)
			end)
		end
	end,
	server_capabilities = {
		semanticTokensProvider = {
			full = true,
		},
	},
	-- delete once https://github.com/neovim/nvim-lspconfig/pull/3977/files merges
	-- init_options = {
	-- 	languageFeatures = {
	-- 		typeDefinition = false,
	-- 	},
	-- 	vue = {
	-- 		hybridMode = false,
	-- 	},
	-- },
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
