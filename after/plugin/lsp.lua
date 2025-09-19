-- Reserve a space in the gutter
vim.opt.signcolumn = 'yes'

-- Must run before Lua LS config/enable
require("neodev").setup({})

-- Add cmp_nvim_lsp capabilities to *all* LSPs
vim.lsp.config('*', {
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
})

-- Keymaps & buffer-local tweaks when an LSP client attaches
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = { buffer = event.buf }
    vim.keymap.set('n', 'K',  vim.lsp.buf.hover,          opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition,     opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration,    opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'go', vim.lsp.buf.type_definition,opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references,     opts)
    vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<F2>',  vim.lsp.buf.rename,      opts)
    vim.keymap.set({'n','x'}, '<F3>', function() vim.lsp.buf.format({ async = true }) end, opts)
    vim.keymap.set('n', '<F4>',  vim.lsp.buf.code_action, opts)
  end,
})

-- Server-specific settings (Lua LS shown as example)
vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      diagnostics = { globals = { 'vim' } },
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true),
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    },
  },
})

-- If you want ocamllsp later, add: vim.lsp.enable('ocamllsp')
-- Enable the servers you use
vim.lsp.enable({ 'gleam', 'lua_ls' })

-- === nvim-cmp + LuaSnip ===
local cmp = require('cmp')
local luasnip = require('luasnip')
require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
  snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
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
  sources = cmp.config.sources(
    { { name = 'nvim_lsp' }, { name = 'luasnip' } },
    { { name = 'buffer' } }
  ),
})
