-- NOTE: to make any of this work you need a language server.
-- If you don't know what that is, watch this 5 min video:
-- https://www.youtube.com/watch?v=LaS32vctfOY
require('mason').setup()

local blink_ok, blink = pcall(require, 'blink.cmp')

-- Generate client capabilities, augmenting them with blink.cmp if available.
local capabilities = vim.lsp.protocol.make_client_capabilities()
if blink_ok and blink.get_lsp_capabilities then
  capabilities = blink.get_lsp_capabilities(capabilities)
end
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

local neodev_ok, neodev = pcall(require, "neodev")
if neodev_ok then
  neodev.setup({})
end

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


local luasnip_loader_ok, luasnip_loader = pcall(require, 'luasnip.loaders.from_vscode')
if luasnip_loader_ok then
  luasnip_loader.lazy_load()
end

if blink_ok then
  blink.setup({
    keymap = {
      preset = 'default',
      ['<C-b>'] = 'scroll_documentation_up',
      ['<C-f>'] = 'scroll_documentation_down',
      ['<C-Space>'] = 'show',
      ['<C-e>'] = 'hide',
      ['<CR>'] = 'accept',
    },
    snippets = { preset = 'luasnip' },
  })
end
