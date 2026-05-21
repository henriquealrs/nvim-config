-- Same <leader> as rust (RustLsp codeAction) → pick a nvim-treesitter-cpp-tools command
local function pick_tscpp()
    pcall(function()
        require("lazy").load({ plugins = { "nvim-treesitter-cpp-tools" } })
    end)

    local items = {
        { label = "Define / implement class functions (TSCppDefineClassFunc)",  cmd = "TSCppDefineClassFunc" },
        { label = "Make concrete class — pure virtuals (TSCppMakeConcreteClass)", cmd = "TSCppMakeConcreteClass" },
        { label = "Rule of 3 (TSCppRuleOf3)",                                      cmd = "TSCppRuleOf3" },
        { label = "Rule of 5 (TSCppRuleOf5)",                                      cmd = "TSCppRuleOf5" },
        { label = "Impl write to .cpp (TSCppImplWrite)",                            cmd = "TSCppImplWrite" },
    }
    vim.ui.select(items, {
        prompt = "TSCpp",
        format_item = function(x)
            return x.label
        end,
    }, function(choice)
        if not choice then
            return
        end
        pcall(vim.cmd, choice.cmd)
    end)
end

local buf = vim.api.nvim_get_current_buf()
vim.keymap.set("n", "<leader>r", pick_tscpp, { buffer = buf, desc = "TSCpp: pick action" })
