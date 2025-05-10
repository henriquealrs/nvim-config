require("toggleterm").setup{
    on_open = function(t)
        vim.cmd(":set rnu")
    end,
    shell = "fish"
}

vim.keymap.set('n', '<leader>t', '<Cmd>exe v:count1 . "ToggleTerm direction=float"<CR>')
