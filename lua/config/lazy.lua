-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)



-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
    spec = {
        {
            "nvim-lua/plenary.nvim",
            lazy = false,
        },
        { "tpope/vim-fugitive" },
        {
            "ThePrimeagen/harpoon",
            lazy = false,
        },
        {
            'numToStr/Comment.nvim',
            lazy = false,
            config = function()
                require('Comment').setup()
            end
        },
        {
            'nvim-telescope/telescope.nvim',
            tag = '0.1.8',
            dependencies = {
                'nvim-lua/plenary.nvim',
                {
                    'nvim-telescope/telescope-fzf-native.nvim', build = 'make'
                }
            }
        },
        {
            "Badhi/nvim-treesitter-cpp-tools",
            dependencies = { "nvim-treesitter/nvim-treesitter" },
            -- Optional: Configuration
            opts = function()
                local options = {
                    preview = {
                        quit = "q",                           -- optional keymapping for quit preview
                        accept = "<cr>",                      -- optional keymapping for accept preview
                    },
                    header_extension = "h",                   -- optional
                    source_extension = "cpp",                 -- optional
                    custom_define_class_function_commands = { -- optional
                        TSCppImplWrite = {
                            output_handle = require("nt-cpp-tools.output_handlers").get_add_to_cpp(),
                        },
                        --[[
                <your impl function custom command name> = {
                    output_handle = function (str, context)
                        -- string contains the class implementation
                        -- do whatever you want to do with it
                    end
                }
                ]]
                    },
                }
                return options
            end,
            -- End configuration
            config = true,
        },

        { "mbbill/undotree" },
        {
            "f-person/git-blame.nvim",
            -- load the plugin at startup
            event = "VeryLazy",
            -- Because of the keys part, you will be lazy loading this plugin.
            -- The plugin wil only load once one of the keys is used.
            -- If you want to load the plugin at startup, add something like event = "VeryLazy",
            -- or lazy = false. One of both options will work.
            opts = {
                -- your configuration comes here
                -- for example
                enabled = true, -- if you want to enable the plugin
                message_template = " <summary> • <date> • <author> • <<sha>>", -- template for the blame message, check the Message template section for more options
                date_format = "%m-%d-%Y %H:%M:%S", -- template for the date, check Date format section for more options
                virtual_text_column = 1, -- virtual text start column, check Start virtual text at column section for more options
            },

        },
        -- amongst your other plugins
        { 'akinsho/toggleterm.nvim',        version = "*",     config = true },
        -- Autocompletion
        {
            'saghen/blink.cmp',
            version = '*',
            event = 'InsertEnter',
            dependencies = {
                'L3MON4D3/LuaSnip',
                'rafamadriz/friendly-snippets',
            },
        },


        -- LSP

        -- { 'hrsh7th/cmp-buffer' },
        -- { 'hrsh7th/cmp-path' },
        -- { 'hrsh7th/cmp-cmdline' },

        {
            'mason-org/mason.nvim',
            lazy = false,
            opts = {},
        },
        { 'mason-org/mason-lspconfig.nvim', version = "*",
            -- config = function()
            -- end,
        },
        {
            'neovim/nvim-lspconfig',
            lazy = false,
            cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
            event = { 'BufReadPre', 'BufNewFile' },
            dependencies = {
            },
            init = function()
                -- Reserve a space in the gutter
                -- This will avoid an annoying layout shift in the screen
                vim.opt.signcolumn = 'yes'
            end,
        },
        {
            "nvim-treesitter/nvim-treesitter",
            build = ":TSUpdate",
            config = function()
                local configs = require("nvim-treesitter.configs")

                configs.setup({
                    ensure_installed = { "c", "cpp", "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html" },
                    sync_install = false,
                    highlight = { enable = true },
                    indent = { enable = true },
                })
            end
        },
        -- {
        --     "nvim-neo-tree/neo-tree.nvim",
        --     branch = "v3.x",
        --     dependencies = {
        --         "nvim-lua/plenary.nvim",
        --         "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        --         "MunifTanjim/nui.nvim",
        --         -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
        --         {
        --             "s1n7ax/nvim-window-picker", -- for open_with_window_picker keymaps
        --             version = "2.*",
        --             config = function()
        --                 require("window-picker").setup({
        --                     filter_rules = {
        --                         include_current_win = false,
        --                         autoselect_one = true,
        --                         -- filter using buffer options
        --                         bo = {
        --                             -- if the file type is one of following, the window will be ignored
        --                             filetype = { "neo-tree", "neo-tree-popup", "notify" },
        --                             -- if the buffer type is one of following, the window will be ignored
        --                             buftype = { "terminal", "quickfix" },
        --                         },
        --                     },
        --                 })
        --             end,
        --         },
        --     },
        --     lazy = false, -- neo-tree will lazily load itself
        --     ---@module "neo-tree"
        --     ---@type neotree.Config?
        --     opts = {
        --         -- fill any relevant options here
        --     },
        -- },

        {
            "yochem/jq-playground.nvim",
        },
        {
            "folke/neodev.nvim",
            ft = "lua",
            opts = {},
            config = function()
                require("neodev").setup({})
            end
        },
        {
            "mfussenegger/nvim-dap",
            dependencies = {
                "rcarriga/nvim-dap-ui",
                "theHamsta/nvim-dap-virtual-text",
                "nvim-neotest/nvim-nio",
            },
            config = function()
                require("dapui").setup()
            end
        },
        -- import your plugins
        { import = "plugins" },
    },
    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    install = { colorscheme = { "rose-pine" } },
    -- automatically check for plugin updates
    checker = { enabled = true },
})
