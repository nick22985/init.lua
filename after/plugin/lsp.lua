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
local lspConfig = require('lspconfig')

lspConfig.lua_ls.setup(lsp.nvim_lua_ls())


lspConfig.vuels.setup({
	settings = {
		vetur = {
			enable = true,
			grammar = {
				customBlocks = {
					component = "js",
					directive = "js",
					endpoint = "js",
					filter = "js",
					macgyver = "js",
					schema = "js",
					server = "js",
					service = "js"
				}
			}
		}
	}
})

-- lsp.configure('tsserver', {
--         capabilities = {
--             typescript = {
--                 experimental = {
--                     enableProjectDiagnostics = true
--                 }
--             }
--         },
-- })


lsp.setup()

vim.diagnostic.config({
	virtual_text = true
})
