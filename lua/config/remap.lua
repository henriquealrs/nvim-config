vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>ft", ":Neotree toggle<CR>")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzK`z")

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<leader>p", "\"_dP")

vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("n", "<leader>ws", "<cmd>:split<cr>")

vim.keymap.set("n", "<leader>wv", "<cmd>:vsplit<cr>")

local hs = function()
    vim.cmd(":highlight ExtraWhitespace ctermbg=red guibg=red")
    vim.cmd([[match ExtraWhitespace /\s\+$/]])
end

vim.api.nvim_set_keymap("n", "<leader>ct", [[:%s/\s\+$//e<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<leader>ct", [[:s/\s\+$//e<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>hs", [[:highlight ExtraWhitespace ctermbg=red guibg=red<CR> <BAR>:match ExtraWhitespace /\s\+$/ <CR>]], {noremap = true, silent = true})
