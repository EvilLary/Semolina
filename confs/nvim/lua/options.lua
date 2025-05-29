vim.g.mapleader = " "
vim.g.maplocalleader = ","

local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.numberwidth = 4
opt.signcolumn = "yes:2"
opt.scrolloff = 15

opt.cursorline = true
opt.splitbelow = true
opt.splitright = true

opt.wrap = false
opt.linebreak = true
opt.autoindent = true
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.list = true
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

opt.inccommand = "split"
opt.smartcase = true
opt.ignorecase = true

opt.icon = true
opt.iconstring = "nvim"
opt.titlestring = "%F - NVIM"
opt.title = true
opt.titlelen = 50

opt.foldmethod = "indent"
opt.foldlevelstart = 2

opt.arabicshape = false
-- opt.termbidi = true
opt.winborder = "single"
opt.termguicolors = true
opt.undofile = true
opt.virtualedit = "block"
opt.clipboard = "unnamedplus"
opt.conceallevel = 3

-- Annoying auto-comment
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ 'r', 'o' })
  end,
})
-- vim.treesitter.language.register('rust', { 'rust' })
-- vim.treesitter.language.add('rust', { path = '/usr/lib/libtree-sitter-rust.so'})
