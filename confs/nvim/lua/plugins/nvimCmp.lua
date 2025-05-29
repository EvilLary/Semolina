return { -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
        'saadparwaiz1/cmp_luasnip',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-path',
        "hrsh7th/cmp-buffer",
    },

    config = function()
        local cmp = require 'cmp'
        local kind_icons = {
            Text = "",
            Method = "󰆧",
            Function = "󰊕",
            Constructor = "",
            Field = "󰇽",
            Variable = "󰂡",
            Class = "󰠱",
            Interface = "",
            Module = "",
            Property = "󰜢",
            Unit = "",
            Value = "󰎠",
            Enum = "",
            Keyword = "󰌋",
            Snippet = "",
            Color = "󰏘",
            File = "󰈙",
            Reference = "",
            Folder = "󰉋",
            EnumMember = "",
            Constant = "󰏿",
            Struct = "",
            Event = "",
            Operator = "󰆕",
            TypeParameter = "󰅲",
        }
        cmp.setup {
            snippet = {
                -- expand = function(args)
                --     -- luasnip.lsp_expand(args.body)
                -- end,
            },
            completion = { completeopt = 'menu,menuone,noinsert' },

            -- myborder = {
            --     border = "rounded",
            --     col_offset = 0,
            --     scrollbar = true,
            --     scrolloff = 0,
            --     side_padding = 1,
            --     winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
            --     zindex = 1001
            -- },
            window = {
                completion = {
                    border = "single",
                },
                documentation = {
                    border = "single",
                },
            },



            mapping = cmp.mapping.preset.insert {
                ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                ['<C-d>'] = cmp.mapping.scroll_docs(4),
                ['<C-e>'] = cmp.mapping.abort(),

                ['<CR>'] = cmp.mapping.confirm { select = true },
                ['<Tab>'] = cmp.mapping.select_next_item(),
                ['<S-Tab>'] = cmp.mapping.select_prev_item(),
                ['<C-Space>'] = cmp.mapping.complete {},
                -- ['<a-l>'] = cmp.mapping(function()
                --     if luasnip.expand_or_locally_jumpable() then
                --         luasnip.expand_or_jump()
                --     end
                -- end, { 'i', 's' }),
                -- ['<a-h>'] = cmp.mapping(function()
                --     if luasnip.locally_jumpable(-1) then
                --         luasnip.jump(-1)
                --     end
                -- end, { 'i', 's' }),
            },
            sources = {
                { name = "neorg" },
                { name = 'nvim_lsp' },
                -- { name = 'luasnip' },
                { name = 'path' },
                { name = 'buffer' },
            },
            formatting = {
                -- 'menu','abbr', 'kind'
                fields = { 'abbr', 'kind' },
                format = function(entry, vim_item)
                    -- Kind icons
                    vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
                    -- vim_item.menu = ({
                    --     buffer = "[Buffer]",
                    --     nvim_lsp = "[LSP]",
                    --     luasnip = "[Snippet]",
                    --     nvim_lua = "[Lua]",
                    --     buffer = '[Buffer]',
                    --     path = '[Path]',
                    --     latex_symbols = "[LaTeX]",
                    -- })[entry.source.name]
                    return vim_item
                end,
            },
        }
    end,
}
