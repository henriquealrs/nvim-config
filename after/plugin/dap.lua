local dap = require("dap")

local function lldb_executable(path)
    return path ~= nil
        and path ~= ""
        and vim.fn.filereadable(path) == 1
        and vim.fn.executable(path) == 1
end

--- Resolve lldb-vscode or lldb-dap. Ubuntu/Debian LLVM packages install these under
--- /usr/lib/llvm-<ver>/bin/ and often do not add them to PATH.
local function resolve_lldb_adapter_cmd()
    local override = vim.env.NVIM_DAP_LLDB
    if override and override ~= "" and lldb_executable(override) then
        return override
    end

    for _, cmd in ipairs({ "lldb-vscode", "lldb-dap" }) do
        local path = vim.fn.exepath(cmd)
        if path ~= "" then
            return path
        end
    end

    local candidates = {}
    for _, pattern in ipairs({
        "/usr/lib/llvm-*/bin/lldb-vscode",
        "/usr/lib/llvm-*/bin/lldb-dap",
        "/usr/local/opt/llvm/bin/lldb-vscode",
        "/usr/local/opt/llvm/bin/lldb-dap",
    }) do
        local matches = vim.fn.glob(pattern, false, true)
        if type(matches) == "table" then
            vim.list_extend(candidates, matches)
        elseif matches ~= "" then
            candidates[#candidates + 1] = matches
        end
    end

    table.sort(candidates, function(a, b)
        local va = tonumber((a:match("llvm%-(%d+)"))) or 0
        local vb = tonumber((b:match("llvm%-(%d+)"))) or 0
        return va > vb
    end)

    for _, path in ipairs(candidates) do
        if lldb_executable(path) then
            return path
        end
    end

    vim.notify(
        "lldb DAP not found (lldb-vscode / lldb-dap). "
        .. "Install `lldb` from your distro, or set NVIM_DAP_LLDB to the full path.",
        vim.log.levels.ERROR
    )
    return nil
end

local lldb_cmd = resolve_lldb_adapter_cmd()

dap.adapters.lldb = lldb_cmd and {
    type = "executable",
    command = lldb_cmd,
    name = "lldb",
} or nil

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

require("nvim-dap-virtual-text").setup()

local vscode = require("dap.ext.vscode")
vscode.type_to_filetypes["lldb"] = { "rust", "cpp" }   -- if not set elsewhere
vscode.load_launchjs(
    vim.fn.getcwd() .. "/.vscode/nvim-launch.json",
    { lldb = { "rust" } }
)
