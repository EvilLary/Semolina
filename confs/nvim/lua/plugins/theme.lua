return {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    opts = function()
        require('kanagawa').setup({
            compile = false,
            typeStyle = {},
            transparent = true,
            dimInactive = false,
            terminalColors = false,
            theme = "wave",
            background = {
                dark = "wave",           -- try "dragon" !
                light = "lotus"
            },
        })
        vim.cmd("colorscheme kanagawa")
        vim.cmd("hi LineNr guibg=bg")
		-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
		-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
		-- vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
		-- vim.opt.fillchars = { eob = " " }
     end,

    -- 'navarasu/onedark.nvim',
    -- lazy = false,
    -- priority = 1000,
    -- opts = function()
    --     require('onedark').setup({
    --         style = deep,
    --         transparent = false,
    --     })
    --
    --     vim.cmd("colorscheme onedark")
    -- end,

    -- "folke/tokyonight.nvim",
    -- lazy = false,
    -- priority = 1000,
    -- opts = function()
    --     require('tokyonight').setup({
    --         transparent = true,
    --     })
    --     vim.cmd("colorscheme tokyonight")
    -- end,


    -- "rose-pine/neovim", 
    -- name = "rose-pine",
    -- config = function()
    --     require('rose-pine').setup({
    --         variant = "moon", -- auto, main, moon, or dawn
    --         transparent = false,
    --
    --         styles = {
    --             bold = true,
    --             italic = true,
    --             transparency = false,
    --         },
    --     })
    --     vim.cmd("colorscheme rose-pine")
    -- end
}

