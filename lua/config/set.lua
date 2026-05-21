vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.autoread = true
vim.opt.undodir = os.getenv("HOME") .. "/.vim.undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

vim.cmd(":highlight ExtraWhitespace ctermbg=red guibg=red")
vim.cmd([[match ExtraWhitespace /\s\+$/]])

local autoread_group = vim.api.nvim_create_augroup("AutoRead", { clear = true })
local uv = vim.uv or vim.loop
local last_check = 0

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
    group = autoread_group,
    callback = function()
        if vim.fn.mode() == "c" then
            return
        end

        local now = uv.hrtime()
        if now - last_check < 1000000000 then
            return
        end

        last_check = now
        vim.cmd("silent! checktime")
    end,
})

vim.api.nvim_create_autocmd("FileChangedShellPost", {
    group = autoread_group,
    callback = function(args)
        local file = args.file ~= "" and vim.fn.fnamemodify(args.file, ":~:.") or vim.fn.expand("%:~:.")
        vim.notify("Reloaded " .. file, vim.log.levels.INFO, { title = "File changed on disk" })
    end,
})
