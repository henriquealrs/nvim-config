return {
    "mfussenegger/nvim-dap-python",
    dependencies = {
        "mfussenegger/nvim-dap",
    },
    ft = "python",
    rocks = false,
    config = function()
        local function mason_debugpy_python()
            local data = vim.fn.stdpath("data")

            if vim.fn.has("win32") == 1 then
                return data .. "/mason/packages/debugpy/venv/Scripts/python.exe"
            end

            return data .. "/mason/packages/debugpy/venv/bin/python"
        end

        local function is_executable(path)
            return path ~= nil and path ~= "" and vim.fn.executable(path) == 1
        end

        local function resolve_debugpy_adapter()
            local mason_python = mason_debugpy_python()
            if is_executable(mason_python) then
                return mason_python
            end

            local debugpy_adapter = vim.fn.exepath("debugpy-adapter")
            if debugpy_adapter ~= "" then
                return debugpy_adapter
            end

            local uv = vim.fn.exepath("uv")
            if uv ~= "" then
                return uv
            end

            local python3 = vim.fn.exepath("python3")
            if python3 ~= "" then
                return python3
            end

            local python = vim.fn.exepath("python")
            if python ~= "" then
                return python
            end

            return "python3"
        end

        require("dap-python").setup(resolve_debugpy_adapter(), {
            include_configs = false,
        })

        local vscode = require("dap.ext.vscode")
        vscode.type_to_filetypes.python = { "python" }
        vscode.type_to_filetypes.debugpy = { "python" }
    end,
}
