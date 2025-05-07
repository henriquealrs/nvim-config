-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
    { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
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
        {"tpope/vim-fugitive"},
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
            'nvim-telescope/telescope.nvim', tag = '0.1.8',
            dependencies = {
                'nvim-lua/plenary.nvim',
                {
                    'nvim-telescope/telescope-fzf-native.nvim', build = 'make'
                }
            }
        },
        {
            'mason-org/mason.nvim',
            lazy = false,
            opts = {},
            version = "1.11.0"
        },
        {
            "Badhi/nvim-treesitter-cpp-tools",
            dependencies = { "nvim-treesitter/nvim-treesitter" },
            -- Optional: Configuration
            opts = function()
                local options = {
                    preview = {
                        quit = "q", -- optional keymapping for quit preview
                        accept = "<cr>", -- optional keymapping for accept preview
                    },
                    header_extension = "h", -- optional
                    source_extension = "cpp", -- optional
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

        {"mbbill/undotree"},
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
                enabled = true,  -- if you want to enable the plugin
                message_template = " <summary> • <date> • <author> • <<sha>>", -- template for the blame message, check the Message template section for more options
                date_format = "%m-%d-%Y %H:%M:%S", -- template for the date, check Date format section for more options
                virtual_text_column = 1,  -- virtual text start column, check Start virtual text at column section for more options
            },

        },
        -- amongst your other plugins
        {'akinsho/toggleterm.nvim', version = "*", config = true},
        -- Autocompletion
        {
            'hrsh7th/nvim-cmp',
            event = 'InsertEnter',
            config = function()
                local cmp = require('cmp')

                cmp.setup({
                    sources = {
                        {name = 'nvim_lsp'},
                    },
                    mapping = cmp.mapping.preset.insert({
                        ['<C-Space>'] = cmp.mapping.complete(),
                        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                        ['<C-d>'] = cmp.mapping.scroll_docs(4),
                    }),
                    snippet = {
                        expand = function(args)
                            vim.snippet.expand(args.body)
                        end,
                    },
                })
            end
        },

        -- LSP

        { 'hrsh7th/cmp-nvim-lsp'  },
        { 'hrsh7th/cmp-buffer'    },
        { 'hrsh7th/cmp-path'      },
        { 'hrsh7th/cmp-cmdline'   },
        { 'hrsh7th/nvim-cmp'      },
        { 'hrsh7th/cmp-vsnip'     },
        { 'hrsh7th/vim-vsnip'     },

        {'mason-org/mason-lspconfig.nvim', version = "1.32.0" },
        {
            'neovim/nvim-lspconfig',
            lazy = false,
            cmd = {'LspInfo', 'LspInstall', 'LspStart'},
            event = {'BufReadPre', 'BufNewFile'},
            dependencies = {
            },
            init = function()
                -- Reserve a space in the gutter
                -- This will avoid an annoying layout shift in the screen
                vim.opt.signcolumn = 'yes'
            end,
            config = function()
                local lsp_defaults = require('lspconfig').util.default_config

                -- Add cmp_nvim_lsp capabilities settings to lspconfig
                -- This should be executed before you configure any language server
                lsp_defaults.capabilities = vim.tbl_deep_extend(
                    'force',
                    lsp_defaults.capabilities,
                    require('cmp_nvim_lsp').default_capabilities()
                )

                -- LspAttach is where you enable features that only work
                -- if there is a language server active in the file
                vim.api.nvim_create_autocmd('LspAttach', {
                    desc = 'LSP actions',
                    callback = function(event)
                        local opts = {buffer = event.buf}

                        vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
                        vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
                        vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
                        vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
                        vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
                        vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
                        vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
                        vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
                        vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
                        vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
                    end,
                })

                require('mason-lspconfig').setup({
                    ensure_installed = {},
                    handlers = {
                        -- this first function is the "default handler"
                        -- it applies to every language server without a "custom handler"
                        function(server_name)
                            require('lspconfig')[server_name].setup({})
                        end,
                    }
                })
            end
        },
        {
            "nvim-treesitter/nvim-treesitter",
            build = ":TSUpdate",
                config = function ()
                local configs = require("nvim-treesitter.configs")

                configs.setup({
                    ensure_installed = { "c", "cpp", "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html" },
                    sync_install = false,
                    highlight = { enable = true },
                    indent = { enable = true },
                })
            end
        },
        {
            "nvim-neo-tree/neo-tree.nvim",
            branch = "v3.x",
            dependencies = {
                "nvim-lua/plenary.nvim",
                "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
                "MunifTanjim/nui.nvim",
                -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
                {
                    "s1n7ax/nvim-window-picker", -- for open_with_window_picker keymaps
                    version = "2.*",
                    config = function()
                        require("window-picker").setup({
                            filter_rules = {
                                include_current_win = false,
                                autoselect_one = true,
                                -- filter using buffer options
                                bo = {
                                    -- if the file type is one of following, the window will be ignored
                                    filetype = { "neo-tree", "neo-tree-popup", "notify" },
                                    -- if the buffer type is one of following, the window will be ignored
                                    buftype = { "terminal", "quickfix" },
                                },
                            },
                        })
                    end,
                },
            },
            lazy = false, -- neo-tree will lazily load itself
            ---@module "neo-tree"
            ---@type neotree.Config?
            opts = {
                -- fill any relevant options here
            },
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

