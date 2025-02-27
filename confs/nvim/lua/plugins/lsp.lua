return {
    'neovim/nvim-lspconfig',

    dependencies = {
        { 'williamboman/mason.nvim', config = true },
        'williamboman/mason-lspconfig.nvim',
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        -- { 'RaafatTurki/corn.nvim', opts = {
        --     scope = "file",
        --     border_style = "none"
        -- }},
        { 'j-hui/fidget.nvim', opts = {} },
        'hrsh7th/cmp-nvim-lsp',
    },
    opts = {
        diagnostics = {
            virtual_text = false,
            virtual_lines = false,
        },
    },
    config = function()
        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
            callback = function(event)
                local map = function(keys, func, desc, mode)
                    mode = mode or 'n'
                    vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
                end

                map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

                -- Find references for the word under your cursor.
                map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

                -- Jump to the implementation of the word under your cursor.
                map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

                -- Jump to the type of the word under your cursor.
                --  the definition of its *type*, not where it was *defined*.
                map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

                -- Fuzzy find all the symbols in your current document.
                map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

                -- Fuzzy find all the symbols in your current workspace.
                map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

                -- Rename the variable under your cursor.
                map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

                -- Execute a code action, usually your cursor needs to be on top of an error
                map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

                -- WARN: This is not Goto Definition, this is Goto Declaration.
                --  For example, in C this would take you to the header.
                map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

                local client = vim.lsp.get_client_by_id(event.data.client_id)
                if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
                    local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
                    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                        buffer = event.buf,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.document_highlight,
                    })

                    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                        buffer = event.buf,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.clear_references,
                    })

                    vim.api.nvim_create_autocmd('LspDetach', {
                        group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
                        callback = function(event2)
                            vim.lsp.buf.clear_references()
                            vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
                        end,
                    })
                end
                if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
                    map('<leader>th', function()
                        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
                    end, '[T]oggle Inlay [H]ints')
                end
            end,
        })
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
        local servers = {
            clangd = {},
            -- slint_lsp = {
            --   filetypes =   { "slint" },
            -- },
            rust_analyzer = {
                settings = {
                    ['rust-analyzer'] = {
                        diagnostics = {
                            enable = true,
                        },
                        -- cargo = {
                        --     allFeatures = true,
                        -- },
                        -- inlayHints = {
                        --     enable = true,
                        -- },
                    },
                },

            },

        }
        require('mason').setup()
        require("lspconfig").qmlls.setup({
            cmd = {'/usr/bin/qmlls6'},
            -- root_dir = function(fname)
            --     return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
            -- end,
        })
        local ensure_installed = vim.tbl_keys(servers or {})
        vim.list_extend(ensure_installed, {
            'rust-analyzer',
        })
        require('mason-tool-installer').setup { ensure_installed = ensure_installed }

        require('mason-lspconfig').setup {
            handlers = {
                function(server_name)
                    local server = servers[server_name] or {}
                    server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
                    require('lspconfig')[server_name].setup(server)
                end,
            },
        }

        -- local signs = { Error = "", Warn = "", Hint = "󰌵", Info = "" }
        -- for type, icon in pairs(signs) do
        --     local hl = "DiagnosticSign" .. type
        --     vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
        -- end
        vim.diagnostic.config({
            virtual_text = false,
            -- virtual_text = {
            --     enabled = false,
            --     -- source = "always",  -- Or "if_many"
            --     prefix = '● ', -- Could be '■', '▎', 'x'
            -- },
            virtual_lines = true,
            severity_sort = true,
            float = {
                source = "always",  -- Or "if_many"
            },
        })
        -- open diagnostics on hover
        -- vim.api.nvim_create_autocmd({ "CursorHold" }, {
        --     pattern = "*",
        --     callback = function()
        --         for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
        --             if vim.api.nvim_win_get_config(winid).zindex then
        --                 return
        --             end
        --         end
        --         vim.diagnostic.open_float({
        --             scope = "cursor",
        --             focusable = false,
        --             close_events = {
        --                 "CursorMoved",
        --                 "CursorMovedI",
        --                 "BufHidden",
        --                 "InsertCharPre",
        --                 "WinLeave",
        --             },
        --         })
        --     end
        -- })
    end,
}
