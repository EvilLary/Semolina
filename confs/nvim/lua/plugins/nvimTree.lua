return {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
        "nvim-tree/nvim-web-devicons"
    },
    keys = {
        { "\\", "<cmd>NvimTreeToggle<cr>", desc = "toggle Noetree" },
        -- {"<leader>e", "<cmd>NvimTreeFocus<cr>", desc = "Focus current file" },
    },
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    opts = {
        disable_netrw = true,
        hijack_cursor = true,
        sync_root_with_cwd = true,
        update_focused_file = {
            enable = true,
            update_root = false,
        },
        view = {
            width = 30,
            -- preserve_window_proportions = true,
        },
        git = {
            enable = false,
            -- show_on_dirs = true,
            -- show_on_open_dirs = true,
            -- disable_for_dirs = {},
            -- timeout = 400,
            -- cygwin_support = false,
        },
        renderer = {
            -- root_folder_label = true,
            highlight_git = true,
            indent_markers = { enable = true },
            icons = {
                glyphs = {
                    default = "󰈚",
                    folder = {
                        default = "",
                        empty = "",
                        empty_open = "",
                        open = "",
                        symlink = "",
                    },
                    git = { unmerged = "" },
                },
            },
        }
    }
}
