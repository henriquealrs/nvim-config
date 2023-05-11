-- local lsp = require('lsp-zero')
--
-- lsp.preset('recommended')
-- lsp.setup()
--
local lspconfig = require('lspconfig')
lspconfig.pyright.setup{}
lspconfig.clangd.setup{}

local servers = {'pyright', 'clangd'}

