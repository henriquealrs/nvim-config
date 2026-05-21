require('telescope').load_extension('fzf')
require('telescope').setup {
    defaults = {
        -- Avoid stale-TSNode crashes in recycled previewer buffers on nvim 0.12
        -- (languagetree.lua:215 -> treesitter.lua:196 "attempt to call method 'range' (a nil value)").
        preview = {
            treesitter = false,
        },
    },
    pickers = {
        find_files = {
            theme = "ivy"
        },
    },
    extensions = { fzf = {} }
}

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<C-b>', builtin.buffers, {})

vim.keymap.set('n', '<leader>ps', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)

vim.keymap.set('n', '<leader>ep', function()
    builtin.find_files {
        cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy")
    }
end)

require("config.telescope.multigrep").setup()
require("config.telescope.wordgrep").setup()
