local render_markdown_venv = vim.fn.stdpath("data") .. "/render-markdown-venv"
local render_markdown_bin = render_markdown_venv .. (vim.fn.has("win32") ~= 0 and "/Scripts" or "/bin")

return {
    "yetone/avante.nvim",
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    -- ⚠️ must add this setting! ! !
    build = vim.fn.has("win32") ~= 0
        and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
        or "make",
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    ---@module 'avante'
    ---@type avante.Config
    opts = {
        -- add any opts here
        -- this file can contain specific instructions for your project
        instructions_file = "avante.md",
        -- for example
        provider = "claude",
        providers = {
            claude = {
                endpoint = "https://api.anthropic.com",
                model = "claude-sonnet-4-20250514",
                timeout = 30000, -- Timeout in milliseconds
                extra_request_body = {
                    temperature = 0.75,
                    max_tokens = 20480,
                },
            },
            moonshot = {
                endpoint = "https://api.moonshot.ai/v1",
                model = "kimi-k2-0711-preview",
                timeout = 30000, -- Timeout in milliseconds
                extra_request_body = {
                    temperature = 0.75,
                    max_tokens = 32768,
                },
            },
        },
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        --- The below dependencies are optional,
        "nvim-mini/mini.pick",       -- for file_selector provider mini.pick
        "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
        "hrsh7th/nvim-cmp",          -- autocompletion for avante commands and mentions
        "ibhagwan/fzf-lua",          -- for file_selector provider fzf
        "stevearc/dressing.nvim",    -- for input provider dressing
        "folke/snacks.nvim",         -- for input provider snacks
        "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
        "zbirenbaum/copilot.lua",    -- for providers='copilot'
        {
            -- support for image pasting
            "HakonHarnes/img-clip.nvim",
            event = "VeryLazy",
            opts = {
                -- recommended settings
                default = {
                    embed_image_as_base64 = false,
                    prompt_for_file_name = false,
                    drag_and_drop = {
                        insert_mode = true,
                    },
                    -- required for Windows users
                    use_absolute_path = true,
                },
            },
        },
        {
            -- Make sure to set this up properly if you have lazy=true
            'MeanderingProgrammer/render-markdown.nvim',
            build = function()
                local python = render_markdown_bin .. (vim.fn.has("win32") ~= 0 and "/python.exe" or "/python")

                local function run(command)
                    local result = vim.system(command, { text = true }):wait()
                    if result.code ~= 0 then
                        error(result.stderr or result.stdout or "command failed")
                    end
                end

                if vim.fn.executable(python) == 0 then
                    run({ "python3", "-m", "venv", render_markdown_venv })
                end
                run({ python, "-m", "pip", "install", "--disable-pip-version-check", "pylatexenc" })
            end,
            opts = {
                file_types = { "markdown", "Avante" },
                latex = {
                    enabled = true,
                    converter = render_markdown_bin
                        .. (vim.fn.has("win32") ~= 0 and "/latex2text.exe" or "/latex2text"),
                    inline = true,
                    block = true,
                },
            },
            ft = { "markdown", "Avante" },
        },
    },
}
