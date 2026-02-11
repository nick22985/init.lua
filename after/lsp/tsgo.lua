-- install with bun install @typescript/native-preview (or package manager of choice)

---@type vim.lsp.Config
return {
	init_options = { hostInfo = "neovim" },
	cmd = function(dispatchers, config)
		local cmd = "tsgo"
		local local_cmd = (config or {}).root_dir and config.root_dir .. "/node_modules/.bin/tsgo"
		if local_cmd and vim.fn.executable(local_cmd) == 1 then
			cmd = local_cmd
		end
		return vim.lsp.rpc.start({ cmd, "--lsp", "--stdio" }, dispatchers)
	end,
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
	},
	root_dir = function(bufnr, on_dir)
		local fname = vim.api.nvim_buf_get_name(bufnr)
		local lsp_utils = require("nick22985.utils.lsp-utils")
		local util = require("lspconfig.util")
		local root_dir = util.root_pattern("package.json", "vue.config.js")(fname)
		local isVue3 = root_dir and lsp_utils.is_vue3_project(root_dir)
		local isVue2 = root_dir and lsp_utils.is_vue2_project(root_dir)
		if vim.fs.root(bufnr, { "deno.json", "deno.jsonc", "deno.lock" }) then
			return
		elseif isVue3 or isVue2 then
			return
		else
			return on_dir(root_dir)
		end
	end,
	settings = {
		analysis = {
			diagnosticMode = "workspace",
		},
		javascript = {
			implicitProjectConfig = {
				checkJs = true,
			},
		},
		typescript = {
			implicitProjectConfig = {
				allowJs = true,
			},
		},
	},
	on_attach = function(client, bufnr)
		-- ts_ls provides `source.*` code actions that apply to the whole file. These only appear in
		-- `vim.lsp.buf.code_action()` if specified in `context.only`.
		vim.api.nvim_buf_create_user_command(bufnr, "LspTypescriptSourceAction", function()
			local source_actions = vim.tbl_filter(function(action)
				return vim.startswith(action, "source.")
			end, client.server_capabilities.codeActionProvider.codeActionKinds)

			vim.lsp.buf.code_action({
				context = {
					only = source_actions,
				},
			})
		end, {})
	end,
}
