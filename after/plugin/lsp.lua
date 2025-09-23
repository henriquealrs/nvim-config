-- NOTE: to make any of this work you need a language server.
-- If you don't know what that is, watch this 5 min video:
-- https://www.youtube.com/watch?v=LaS32vctfOY
require('mason').setup()

-- Add this line near the top (before vim.lsp.config calls):
local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.offsetEncoding = { "utf-16" }

require('mason-lspconfig').setup({
  ensure_installed = { 'lua_ls', 'clangd', 'pyright' },
  automatic_installation = true,
  handlers = {
    function(server)
      vim.lsp.config(server, {
        capabilities = capabilities,
      })
    end,
  },
})

-- Reserve a space in the gutter
vim.opt.signcolumn = 'yes'

require("neodev").setup({})

-- Define/override server configs (data only)
vim.lsp.config('lua_ls', {
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = { globals = { "vim" } },
      workspace = { library = vim.api.nvim_get_runtime_file("", true), checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
})

vim.lsp.config('clangd', {
  capabilities = capabilities,
  -- example tweaks:
  -- cmd = { "clangd", "--background-index" },
  -- filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
})

vim.lsp.config('gleam', { capabilities = capabilities })

vim.lsp.config('pyright', {capabilities = capabilities})

vim.lsp.enable({ 'lua_ls', 'clangd', 'gleam', 'pyright' })


-- Auto-attach keymaps etc.
vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function(event)
        vim.bo[event.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
        local opts = { buffer = event.buf }
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, opts)
        vim.keymap.set({ 'n', 'x' }, '<F3>', function() vim.lsp.buf.format({ async = true }) end, opts)
        vim.keymap.set('n', '<F4>', vim.lsp.buf.code_action, opts)
    end,
})


-- Finally, enable by server-name; this activates them for their filetypes
-- vim.lsp.enable({ 'lua_ls', 'clangd', 'gleam', 'pyright' })


local cmp = require('cmp')
local luasnip = require('luasnip')
require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        -- { name = 'luasnip' },
        -- { name = 'buffer' },
    })
})
