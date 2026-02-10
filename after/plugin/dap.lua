-- Save this in ~/.config/nvim/lua/dap_cpp.lua
local dap = require("dap")

dap.adapters.gdb = {
    type = "executable",
    command = "gdb",
    args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
}

dap.configurations.cpp = {
    {
        name = "Launch",
        type = "gdb",
        request = "launch",
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = "${workspaceFolder}",
        stopAtBeginningOfMainSubprogram = false,
    },
}

dap.adapters.python = {
    type = "executable",
    command = vim.fn.getcwd() .. "/.venv/bin/python",
    args = { "-m", "debugpy.adapter" },
}

dap.configurations.python = { {
    type = "python",
    request = "launch",
    name = "Debug CLI",
    module = "src/b3_investidor/b3_investidor.py",
    args = {},
    cwd = "${workspaceFolder}",
    pythonPath = function()
        return vim.fn.getcwd() .. "/.venv/bin/python"
    end,
}, }

require("nvim-dap-virtual-text").setup()
