local M = {}

function M.setup(opts)
    local ipybridge = assert(opts.ipybridge, "Spyder layout requires ipybridge")
    local prepare = assert(opts.prepare, "Spyder layout requires a uv preparation wrapper")
    local explorer = require("ipybridge.var_explorer")
    local original_ensure_window = explorer.ensure_window
    local state = {
        active = false,
        docking = false,
        editor_win = nil,
    }

    local function sidebar_width()
        local preferred = math.max(40, math.floor(vim.o.columns * 0.38))
        return math.min(preferred, math.max(30, vim.o.columns - 30))
    end

    local function explorer_height()
        local preferred = math.max(10, math.floor(vim.o.lines * 0.35))
        return math.min(preferred, math.max(6, vim.o.lines - 8))
    end

    local function resize_floating_explorer(win)
        local width = math.min(
            math.max(70, math.floor(vim.o.columns * 0.80)),
            math.max(20, vim.o.columns - 4)
        )
        local height = math.min(
            math.max(16, math.floor(vim.o.lines * 0.70)),
            math.max(8, vim.o.lines - 4)
        )

        vim.api.nvim_win_set_config(win, {
            relative = "editor",
            width = width,
            height = height,
            row = math.max(1, math.floor((vim.o.lines - height) / 2) - 1),
            col = math.max(1, math.floor((vim.o.columns - width) / 2)),
        })
    end

    -- ipybridge normally opens the variable explorer as a float. Override only
    -- while assembling the Spyder layout, preserving the original behavior for
    -- the standalone <leader>vx mapping.
    explorer.ensure_window = function(self)
        if self:is_open() then
            return
        end

        local term = ipybridge.term_instance
        if not state.docking or not term or not vim.api.nvim_win_is_valid(term.win_id) then
            original_ensure_window()
            if self:is_open() then
                resize_floating_explorer(self.win)
            end
            return
        end

        self.buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_set_current_win(term.win_id)
        vim.cmd("aboveleft split")
        self.win = vim.api.nvim_get_current_win()
        vim.api.nvim_win_set_buf(self.win, self.buf)

        vim.api.nvim_set_option_value("buftype", "nofile", { buf = self.buf })
        vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = self.buf })
        vim.api.nvim_set_option_value("swapfile", false, { buf = self.buf })
        vim.api.nvim_set_option_value("filetype", "ipybridge-vars", { buf = self.buf })
        vim.api.nvim_set_option_value("modifiable", false, { buf = self.buf })
        vim.api.nvim_set_option_value("number", false, { win = self.win })
        vim.api.nvim_set_option_value("relativenumber", false, { win = self.win })
        vim.api.nvim_set_option_value("signcolumn", "no", { win = self.win })
        vim.api.nvim_set_option_value("winfixbuf", true, { win = self.win })
        vim.api.nvim_set_option_value("winfixheight", true, { win = self.win })
        vim.api.nvim_set_option_value("winfixwidth", true, { win = self.win })
        vim.api.nvim_set_option_value("winbar", " Variable Explorer ", { win = self.win })

        local function map(lhs, action, description)
            vim.keymap.set("n", lhs, action, {
                buffer = self.buf,
                silent = true,
                nowait = true,
                desc = description,
            })
        end

        map("q", function()
            self:close()
        end, "Close variable explorer")
        map("r", ipybridge.var_explorer_refresh, "Refresh variables")
        map("<CR>", function()
            self:drilldown_current()
        end, "Preview variable")
    end

    local function restore_editor_focus()
        if state.editor_win and vim.api.nvim_win_is_valid(state.editor_win) then
            vim.api.nvim_set_current_win(state.editor_win)
        end
    end

    local function close_layout()
        if explorer.is_open() then
            explorer.close()
        end
        restore_editor_focus()
        if ipybridge.is_open() then
            ipybridge.close()
        end
        state.active = false
        state.editor_win = nil
    end

    local function arrange_layout()
        local term = ipybridge.term_instance
        if not term then
            vim.notify("IPython console did not start", vim.log.levels.ERROR)
            return
        end

        if not term:isshow() then
            term:show()
        end
        if not term.win_id or not vim.api.nvim_win_is_valid(term.win_id) then
            vim.notify("IPython console window is unavailable", vim.log.levels.ERROR)
            return
        end

        vim.api.nvim_set_current_win(term.win_id)
        vim.cmd("vertical resize " .. sidebar_width())
        vim.api.nvim_set_option_value("winfixwidth", true, { win = term.win_id })
        vim.api.nvim_set_option_value("winbar", " IPython Console ", { win = term.win_id })

        if explorer.is_open() then
            explorer.close()
        end
        state.docking = true
        ipybridge.var_explorer_open(false)
        state.docking = false

        if explorer.is_open() then
            vim.api.nvim_set_current_win(explorer.win)
            vim.cmd("resize " .. explorer_height())
        end

        state.active = true
        restore_editor_focus()
    end

    local open_layout = prepare(function()
        state.editor_win = vim.api.nvim_get_current_win()
        if ipybridge.is_open() then
            arrange_layout()
            return
        end

        ipybridge.open(true, function(ok)
            if ok then
                arrange_layout()
            end
        end)
    end)

    function M.toggle()
        if state.active then
            close_layout()
            return
        end
        open_layout()
    end

    vim.api.nvim_create_user_command("SpyderToggle", M.toggle, {
        desc = "Toggle the Spyder-style Python workspace",
    })

    return M
end

return M
