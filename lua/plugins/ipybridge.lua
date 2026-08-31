return {
    "ok97465/ipybridge.nvim",
    ft = "python",
    dependencies = {
        "saghen/blink.cmp",
    },
    config = function()
        local ipybridge = require("ipybridge")
        local uv_python = vim.fn.stdpath("config") .. "/scripts/ipybridge-python"
        local prepared_projects = {}
        local preparing_projects = {}

        local function uv_project_root()
            local buffer_name = vim.api.nvim_buf_get_name(0)
            local start = buffer_name ~= "" and vim.fs.dirname(buffer_name) or vim.fn.getcwd()

            return vim.fs.root(start, { "uv.lock", "pyproject.toml" })
        end

        local function with_uv_project(action)
            return function()
                local root = uv_project_root()
                local project_key = root or "__standalone__"
                vim.env.IPYBRIDGE_UV_PROJECT_ROOT = root

                if prepared_projects[project_key] then
                    action()
                    return
                end

                if preparing_projects[project_key] then
                    vim.notify("The uv IPython environment is still being prepared", vim.log.levels.INFO)
                    return
                end

                preparing_projects[project_key] = true
                vim.notify("Preparing the uv IPython environment...", vim.log.levels.INFO)
                vim.system({
                    uv_python,
                    "-c",
                    "import IPython, ipykernel, jupyter_client, jupyter_console, zmq",
                }, { text = true }, function(result)
                    vim.schedule(function()
                        preparing_projects[project_key] = nil
                        if result.code ~= 0 then
                            local details = vim.trim(result.stderr or result.stdout or "")
                            vim.notify(
                                "Could not prepare the uv IPython environment"
                                    .. (details ~= "" and ":\n" .. details or ""),
                                vim.log.levels.ERROR
                            )
                            return
                        end

                        prepared_projects[project_key] = true
                        vim.env.IPYBRIDGE_UV_PROJECT_ROOT = root
                        action()
                    end)
                end)
            end
        end

        local function run_file()
            local path = vim.api.nvim_buf_get_name(0)
            if path == "" then
                vim.notify("Save the Python file before running it", vim.log.levels.WARN)
                return
            end
            if vim.bo.modified then
                vim.cmd.write()
            end

            -- Unlike ipybridge's runfile helper, %run resets sys.argv so
            -- argparse does not receive ipykernel's `-f connection.json`.
            ipybridge.run_cmd("%run -i " .. vim.fn.shellescape(path))
        end

        ipybridge.setup({
            -- Run the kernel in the current uv project without modifying its
            -- dependency groups. See scripts/ipybridge-python.
            python_cmd = uv_python,
            profile_name = nil,
            sleep_ms_after_open = 1000,
            set_default_keymaps = false,
            terminal_winfixbuf = true,
            autoreload = 2,
            exec_cwd_mode = "pwd",
            completion = {
                engine_priority = { "blink.cmp" },
            },
            viewer_max_rows = 40,
            viewer_max_cols = 20,
            plot_viewer = {
                mode = "off",
            },
            terminal_keymaps = function(set)
                set("<C-c>", ipybridge.interrupt, { desc = "IPython: interrupt" })
                set("<leader>iv", ipybridge.goto_vi, { desc = "IPython: back to editor" })
                set("<leader>ir", ipybridge.restart, { desc = "IPython: restart kernel" })
                set("<leader>vx", ipybridge.var_explorer_open, { desc = "IPython: variable explorer" })
            end,
        })

        local spyder = require("config.spyder").setup({
            ipybridge = ipybridge,
            prepare = with_uv_project,
        })

        local group = vim.api.nvim_create_augroup("IpybridgePythonKeymaps", { clear = true })
        vim.api.nvim_create_autocmd("FileType", {
            group = group,
            pattern = "python",
            callback = function(args)
                local opts = function(description)
                    return { buffer = args.buf, silent = true, desc = "IPython: " .. description }
                end

                vim.keymap.set("n", "<leader>ti", with_uv_project(ipybridge.toggle), opts("toggle console"))
                vim.keymap.set("n", "<leader>sp", spyder.toggle, opts("toggle Spyder workspace"))
                vim.keymap.set("n", "<leader>ii", ipybridge.goto_ipy, opts("focus console"))
                vim.keymap.set("n", "<leader>iv", ipybridge.goto_vi, opts("back to editor"))
                vim.keymap.set("n", "<leader>ir", with_uv_project(ipybridge.restart), opts("restart kernel"))
                vim.keymap.set("n", "<leader>if", with_uv_project(run_file), opts("run file"))
                vim.keymap.set("n", "<leader><CR>", with_uv_project(ipybridge.run_cell), opts("run cell"))
                vim.keymap.set("n", "<F9>", with_uv_project(ipybridge.run_line), opts("run line"))
                vim.keymap.set("x", "<F9>", with_uv_project(ipybridge.run_lines), opts("run selection"))
                vim.keymap.set({ "n", "x" }, "]c", ipybridge.down_cell, opts("next cell"))
                vim.keymap.set({ "n", "x" }, "[c", ipybridge.up_cell, opts("previous cell"))
                vim.keymap.set("n", "<leader>vx", with_uv_project(ipybridge.var_explorer_open), opts("variable explorer"))
                vim.keymap.set("n", "<leader>vr", with_uv_project(ipybridge.var_explorer_refresh), opts("refresh variables"))
                vim.keymap.set("n", "<leader>vp", with_uv_project(function()
                    ipybridge.request_preview(vim.fn.expand("<cword>"))
                end), opts("preview variable"))
            end,
        })
    end,
}
