return {
    "neovim/nvim-lspconfig",
    dependencies = {
        { 'j-hui/fidget.nvim', opts = {} },
    },
    lazy = false,
    config = function()
        vim.diagnostic.config({
            virtual_text = {
                source = "if_many", -- "if_many", "always", "single"
                prefix = '● ', -- '●', '▎', 'x'
            },
            virtual_lines = false,
            severity_sort = true,
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = " ",
                    [vim.diagnostic.severity.WARN] = " ",
                    [vim.diagnostic.severity.INFO] = " ",
                    [vim.diagnostic.severity.HINT] = " 󰌵"
                }
            },
            float = {
                border = "single",
                -- border = { "╔", "═" ,"╗", "║", "╝", "═", "╚", "║" },
                source = "always", -- Or "if_many", "always", "single",
            },
            underline = true,
        })

        vim.lsp.enable("qmlls")
        vim.lsp.enable("clangd")
        vim.lsp.enable("rust_analyzer")
        vim.lsp.enable("lua_ls")
        -- vim.lsp.enable("csharp_ls")

        vim.api.nvim_create_autocmd('LspAttach', {
            --group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
            callback = function(event)
                local map = function(keys, func, desc, mode)
                    mode = mode or 'n'
                    vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
                end

                local client = vim.lsp.get_client_by_id(event.data.client_id)
                local telescope = require("telescope.builtin")
                map('gd', telescope.lsp_definitions, '[G]oto [D]efinition')

                -- Find references for the word under your cursor.
                map('gr', telescope.lsp_references, '[G]oto [R]eferences')
                -- Jump to the implementation of the word under your cursor.
                map('gI', telescope.lsp_implementations, '[G]oto [I]mplementation')
                --
                -- Jump to the type of the word under your cursor.
                --  the definition of its *type*, not where it was *defined*.
                map('<leader>D', telescope.lsp_type_definitions, 'Type [D]efinition')

                -- Fuzzy find all the symbols in your current document.
                map('<leader>ds', telescope.lsp_document_symbols, '[D]ocument [S]ymbols')

                -- Fuzzy find all the symbols in your current workspace.
                map('<leader>ws', telescope.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

                map('<leader>dL', telescope.diagnostics, "[D]iagnostic [L]ist")

                -- if client and client:supports_method("textDocument/foldingRange") then
                --     local win = vim.api.nvim_get_current_win()
                --     vim.wo[win][0].foldmethod = "expr"
                --     vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
                -- end

                -- inly hints
                if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
                    map("<leader>th", function()
                        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
                    end, "[T]oggle Inlay [H]ints")
                end

                if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_rename) then
                    map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
                end

                if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_declaration) then
                    map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
                end

                if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_hover) then
                    map("K", function() vim.lsp.buf.hover { border = "single", max_height = 25, max_width = 120 } end,
                        "Lsp hover action")
                end

                if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_codeAction) then
                    map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { 'n', 'x' })
                end

                if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_formatting) then
                    map("<leader>fm", vim.lsp.buf.format, "[F]ormat current file")
                end

                -- if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_) then
                --
                -- end
                if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
                    local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
                    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                        buffer = event.buf,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.document_highlight,
                    })

                    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                        buffer = event.buf,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.clear_references,
                    })

                    vim.api.nvim_create_autocmd("LspDetach", {
                        group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
                        callback = function(event2)
                            vim.lsp.buf.clear_references()
                            vim.api.nvim_clear_autocmds { group = "kickstart-lsp-highlight", buffer = event2.buf }
                        end,
                    })
                end
            end,
        })
    end,
}
