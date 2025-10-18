return {
    "mfussenegger/nvim-dap-python",
    dependencies = {
        "mfussenegger/nvim-dap",
    },
    ft = "python",
    rocks = false, -- <— stop LuaRocks shenanigans for this plugin
    -- config = function()
    --     -- use Mason's debugpy (recommended)
    --     local mason = require("mason-registry")
    --     local pkg = mason.get_package("debugpy")
    --     local python = pkg:get_install_path() .. "/venv/bin/python" -- adjust for your OS
    --     require("dap-python").setup(python)
    -- end,
}
