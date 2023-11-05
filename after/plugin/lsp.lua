local status, lsp_zero = pcall(require, 'lsp-zero')
if not status then
    return
end


require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = {
        'tsserver',
        'rust_analyzer',
        'lua_ls',
        'html',
        'marksman',
        'angularls',
        'vuels',
        -- 'tailwindcss'
    },
    handlers = {
        lsp_zero.default_setup,
        lua_ls = function()
            local lua_opts = lsp_zero.nvim_lua_ls()
            require('lspconfig').lua_ls.setup(lua_opts)
        end,
    }
})

lsp_zero.preset({
    name = "recommended"
})

lsp_zero.configure('lua_ls', {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
})

local cmp = require('cmp')
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp_nvim_lsp = require('cmp_nvim_lsp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp_zero.defaults.cmp_mappings({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
})

cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil
cmp.setup({
    maping = cmp_mappings,
    sources = {
        {
            name = 'buffer',
            option = {
                keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%([\-.]\w*\)*\)]],
                get_bufnrs = function()
                    return vim.api.nvim_list_bufs() -- All buffers
                end
            }
        },
        {
            name = 'nvim_lua'
        }
    }
})

cmp.event:on(
    'confirm_done',
    cmp_autopairs.on_confirm_done({

    })
)

local null_ls = require('null-ls')
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

-- Setup nulls_ls
local null_opts = lsp_zero.build_options('null-ls', {
    on_attach = function(client, bufnr)
        ---
        -- this function is optional
        ---
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                    -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
                    -- on later neovim version, you should use vim.lsp.buf.format({ async = false }) instead
                    vim.lsp.buf.format({ async = false })
                end,
            })
        end
    end
})

null_ls.setup({
    on_attach = null_opts.on_attach,
    sources = {
        ---
        -- do what you have to do...
        ---
        --[[ null_ls.builtins.formatting.stylua, ]]
        -- null_ls.builtins.diagnostics.eslint,
        null_ls.builtins.completion.spell,
        null_ls.builtins.formatting.prettierd.with({
            extra_args = function(params)
                return params.options
                    and params.options.tabSize
                    and { "--tab-width", 1 }
            end,
        })
    }
})



lsp_zero.set_sign_icons({
    error = '',
    warn = '',
    hint = '',
    info = ''
})

lsp_zero.on_attach(function(client, bufnr)
    lsp_zero.default_keymaps({ buffer = bufnr })
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

lspconfig.clangd.setup({
    capabilities = cmp_nvim_lsp.default_capabilities()
})
lspconfig.lua_ls.setup(lsp_zero.nvim_lua_ls())

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
        -- Need this for vue files only. Need to detect if it is vue and only run if it is vue.
        -- if not web_dev_attach(client, bufnr) then return end
    end,
    fileTypes = { "typescript", "typescriptreact", "typescript.tsx" },
    cmd = { "typescript-language-server", "--stdio" },
})

-- vue 2
lspconfig.vuels.setup({
    on_attach = function(client, bufnr)
        if not web_dev_attach(client, bufnr) then return end
    end,
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




lsp_zero.setup()

vim.diagnostic.config({
    virtual_text = true
})
