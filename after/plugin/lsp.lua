local status, lsp = pcall(require, 'lsp-zero')
if not status then
	return
end

lsp.preset("recommended")

lsp.ensure_installed({
	'tsserver',
	'rust_analyzer',
	'lua_ls',
	'html',
	'marksman',
	'angularls',
	'vuels'
	-- 'tailwindcss'
})

local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
	['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
	['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
	['<C-y>'] = cmp.mapping.confirm({ select = true }),
	["<C-Space>"] = cmp.mapping.complete(),
})

cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

local null_ls = require('null-ls')

-- Setup nulls_ls
null_opts = lsp.build_options('null-ls', {
	on_attach = function(client, bufnr)
		---
		-- this function is optional
		---
	end
})

null_ls.setup({
	on_attach = null_opts.on_attach,
	sources = {
		---
		-- do what you have to do...
		---
		null_ls.builtins.formatting.stylua,
		-- null_ls.builtins.diagnostics.eslint,
		null_ls.builtins.completion.spell,
		null_ls.builtins.formatting.prettier
	}
})


lsp.setup_nvim_cmp({
	mapping = cmp_mappings
})

cmp.event:on(
	'confirm_done',
	cmp_autopairs.on_confirm_done()
)

lsp.set_preferences({
	suggest_lsp_servers = true,
	--    sign_icons = {
	--       error = 'E',
	--        warn = 'W',
	--       hint = 'H',
	--     info = 'I'
	-- }
})


lsp.on_attach(function(client, bufnr)
	lsp.default_keymaps({ buffer = bufnr })
	local opts = { buffer = bufnr, remap = false }

	vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
	vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
	vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
	vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
	vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
	vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
	vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
	vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
	vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
	vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)
--
-- (Optional) Configure lua language server for neovim
local lspconfig = require('lspconfig')

lspconfig.lua_ls.setup(lsp.nvim_lua_ls())

-- Doesnt Work
-- lspConfig.vuels.setup({
-- 	settings = {
-- 		vetur = {
-- 			enable = true,
-- 			grammar = {
-- 				customBlocks = {
-- 					component = "js",
-- 					directive = "js",
-- 					endpoint = "js",
-- 					filter = "js",
-- 					macgyver = "js",
-- 					schema = "js",
-- 					server = "js",
-- 					service = "js"
-- 				}
-- 			}
-- 		}
-- 	}
-- })

-- lsp.configure('tsserver', {
--         capabilities = {
--             typescript = {
--                 experimental = {
--                     enableProjectDiagnostics = true
--                 }
--             }
--         },
-- })
--



---@param client any
---@param bufnr number
local web_dev_attach = function(client, bufnr)
	local root_files = vim.fn.readdir(vim.fn.getcwd())
	local volar = true
	-- Add check here that sees if vue is 2 or 3 if it is vue 3 then enable volar
	if vim.tbl_contains(root_files, "pnpm-lock.yaml") then volar = true end

	-- disable vuels and tsserver if we're using volar
	if volar and (client.name == "tsserver" or client.name == "vuels") then
		client.stop()
		return false
	end

	-- disable volar if we don't have pnpm
	if not volar and client.name == "volar" then
		client.stop()
		return false
	end

	return true
end

-- typescript
lspconfig.tsserver.setup({
	on_attach = function(client, bufnr)
		if not web_dev_attach(client, bufnr) then return end
	end,
})

-- vue 2
lspconfig.vuels.setup({
	on_attach = web_dev_attach,
	settings = {
		vetur = {
			completion = {
				autoImport = true,
				tagCasing = "kebab",
				useScaffoldSnippets = true,
			},
			useWorkspaceDependencies = true,
			experimental = {
				templateInterpolationService = false,
			},
		},
		format = {
			enable = true,
			options = {
				useTabs = true,
				tabSize = 2,
			},
			defaultFormatter = {
				ts = "prettier",
			},
			scriptInitialIndent = false,
			styleInitialIndent = false,
		},
		validation = {
			template = true,
			script = true,
			style = true,
			templateProps = true,
			interpolation = true,
		},
	},
})

-- vue 3
lspconfig.volar.setup({
	on_attach = function(client, bufnr)
		if not web_dev_attach(client, bufnr) then return end
	end,
	-- enable "take over mode" for typescript files as well: https://github.com/johnsoncodehk/volar/discussions/471
	-- filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
})


lsp.setup()

vim.diagnostic.config({
	virtual_text = true
})
