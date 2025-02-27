return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function()

            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "c",
                    "lua",
                    "vim",
                    "bash",
                    "rust",
                    "hyprlang",
                    "markdown",
                    "slint",
                    "qmljs",
                    "query",
                    "markdown_inline",
                },
                auto_install = false,
                highlight = {
                    enable = true,
                },

                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<Leader>ss",
                        node_incremental = "<Leader>si",
                        node_decremental = "<Leader>sd",
                        scope_incremental = "<Leader>sc",
                    },
                },

                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ["of"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["oc"] = "@class.outer",
                            ["ic"] = { query = "@class.inner", desc = "Select inner part of a calss region"},
                            ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope"},
                        },
                        selection_modes = {
                            ["@parameter.outer"] = 'v',
                            ["@function.outer"] = 'v',
                            ["@class.outer"] = 'c-v',
                        },
                        include_surrounding_whitespace = false,
                    },
                }
            })
            vim.filetype.add({
              pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
            })

            vim.filetype.add({
              pattern = { [".*%.slint"] = "slint" },
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
    },
}
