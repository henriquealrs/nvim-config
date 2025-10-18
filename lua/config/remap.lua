vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzK`z")

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<leader>p", "\"_dP")

vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("n", "<leader>ws", "<cmd>:split<cr>")

vim.keymap.set("n", "<leader>wv", "<cmd>:vsplit<cr>")

vim.api.nvim_set_keymap("n", "<leader>ct", [[:%s/\s\+$//e<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<leader>ct", [[:s/\s\+$//e<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>hs", [[:highlight ExtraWhitespace ctermbg=red guibg=red<CR> <BAR>:match ExtraWhitespace /\s\+$/ <CR>]], {noremap = true, silent = true})

vim.api.nvim_set_keymap('t', '<ESC>', [[<C-\><C-n>]], { noremap = true })

vim.keymap.set('n', '<A-j>', [[:cnext <CR>]], { noremap = true })
vim.keymap.set('n', '<A-k>', [[:cprev <CR>]], { noremap = true })

vim.keymap.set("n", "<leader>di", function()
    vim.diagnostic.open_float(nil, { focus=false, scope="cursor"})
end)

-- Debugging keys
vim.keymap.set('n', '<F5>', function() require('dap').continue() end)
vim.keymap.set('n', '<F10>', function() require('dap').step_over() end)
vim.keymap.set('n', '<F11>', function() require('dap').step_into() end)
vim.keymap.set('n', '<F12>', function() require('dap').step_out() end)
vim.keymap.set('n', '<Leader>b', function() require('dap').toggle_breakpoint() end)
vim.keymap.set('n', '<Leader>B', function() require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: ')) end)


-- DAP UI toggle
vim.keymap.set('n', '<Leader>du', function()
  require("dapui").toggle()
end)
