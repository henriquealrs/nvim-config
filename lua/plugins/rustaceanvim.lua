-- Sole Rust LSP client; Mason installs rust-analyzer but must not :h vim.lsp.enable
-- it (see after/plugin/lsp.lua automatic_enable.exclude).
return {
    "mrcjkb/rustaceanvim",
    version = "^5",
    ft = { "rust" },
    dependencies = { "saghen/blink.cmp" },
    init = function()
        local caps = vim.lsp.protocol.make_client_capabilities()
        local blink_ok, blink = pcall(require, "blink.cmp")
        if blink_ok and blink.get_lsp_capabilities then
            caps = blink.get_lsp_capabilities(caps)
        end
        caps.offsetEncoding = { "utf-16" }
        vim.g.rustaceanvim = {
            server = {
                capabilities = caps,
            },
        }
    end,
}
