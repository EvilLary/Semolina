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

-- Setup lazy.nvim
require("lazy").setup({
    checker = { enabled = true },
    require ("plugins.nvim-tree"),
    require ("plugins.theme"),
    require ("plugins.lualine"),
    require ("plugins.autopairs"),
    require ("plugins.treesitter"),
    require ("plugins.lsp"),
    require ("plugins.bufferline"),
    require ("plugins.telescope"),
    require ("plugins.autocompletion"),
    require ("plugins.snacks"),
    require ("plugins.which-key"),
    require ("plugins.conform"),
})
