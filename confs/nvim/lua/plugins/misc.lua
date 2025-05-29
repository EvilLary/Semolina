return {
    -- Theme
    {
        "Mofiqul/vscode.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd.colorscheme('vscode')
        end,
    },
    -- Which key
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = true })
                end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        },
    },
    -- BufferLine
    {
        'akinsho/bufferline.nvim',
        version = "*",
        dependencies = 'nvim-tree/nvim-web-devicons',
        opts = {}
    },

    -- -- File format
    -- {
    --     'stevearc/conform.nvim',
    --     opts = function()
    --         require("conform").setup()
    --         vim.keymap.set("n", "<leader>fm", function() require("conform").format { lsp_fallback = true } end,
    --             { desc = "general format file" })
    --     end,
    -- },

    -- Telescope
    {
        'nvim-telescope/telescope.nvim',
        -- branch = '0.1.x',
        branch = "master",
        dependencies = {
            'nvim-lua/plenary.nvim',
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build = 'make',
                cond = function()
                    return vim.fn.executable 'make' == 1
                end,
            },
            { 'nvim-telescope/telescope-ui-select.nvim' },
            { 'nvim-tree/nvim-web-devicons',            enabled = true },
        },
        config = function()
            require('telescope').setup({
                defaults = {
                    path_display = { 'smart' },
                    file_ignore_patterns = {
                        "/home/spicy/disks/WD1TB/",
                    },
                    border = false,
                    prompt_prefix = "   ",
                    -- selection_caret = " ",
                    entry_prefix = " ",
                    sorting_strategy = "ascending",
                    layout_config = {
                        horizontal = {
                            prompt_position = "top",
                            preview_width = 0.55,
                        },
                        width = 0.87,
                        height = 0.80,
                    },
                    mappings = {
                        n = { ["q"] = require("telescope.actions").close },
                    },
                },
            })
            local builtin = require 'telescope.builtin'
            vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '[S]earch [F]iles' })
            vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
            vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
            vim.keymap.set('n', '<leader>fo', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
        end,
    },

    -- Neorg
    {
        "nvim-neorg/neorg",
        -- dependencies = {
        --     "nvim-lua/plenary.nvim"
        -- },
        lazy = false,  -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
        version = "*", -- Pin Neorg to the latest stable release
        -- build = ":Neorg sync-parsers",
        -- config = true,
        config = function()
            require("neorg").setup({
                load = {
                    -- ["core.defaults"] = {}, -- loads default behavior
                    -- ["core.completion"] = {
                    --     config = {
                    --         engine = "nvim-cmp",
                    --         name = "neorg",
                    --     }
                    -- },
                    -- -- ["core.integrations.treesitter"] = {},
                    ["core.autocommands"] = {},
                    -- ["core.concealer"] = {},
                    -- ["core.itero"] = {},
                    -- ["core.esupports.hop"] = {},
                    -- ["core.esupports.metagen"] = {
                    --     config = {
                    --         author = "spicy",
                    --         undojoin_updates = true,
                    --     }
                    -- },
                    -- ["core.esupports.indent"] = {},
                    ["core.keybinds"] = {
                        -- config = {
                        --     default_keybinds = true,
                        -- },
                    },
                    ["core.dirman"] = { -- Manages neorg workspaces
                        config = {
                            default_workspace = "notes",
                            workspaces = {
                                notes = "~/Documents/notes"
                            },
                            autodetect = true,
                            autochdir = true
                        }
                    },
                }
            })
        end,
    },

    -- Autopair
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = true
    }
}
