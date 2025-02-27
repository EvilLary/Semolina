vim.opt_local.titlestring = "%t - neovim"
vim.opt.title = true
-- vim.opt.formatoptions:remove {"c","r","o"}
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.o.showmode = false

vim.o.clipboard = "unnamedplus"
vim.o.mouse = "a"

vim.o.linebreak = true
vim.o.smartcase = true
vim.o.ignorecase = true

--vim.o.autochdir = true

vim.opt.breakindent = true
vim.o.autoindent = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.expandtab = true

vim.o.numberwidth = 4
vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.undofile = true
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.inccommand = "split"
vim.opt.cursorline = true
vim.opt.scrolloff = 10

vim.g.have_nerd_font = true
vim.opt.termguicolors = true

vim.opt.wrap = false
vim.opt.virtualedit = "block"

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

