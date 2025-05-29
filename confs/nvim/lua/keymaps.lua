local remap = vim.keymap.set

remap({ 'n', 'i' }, '<C-s>', '<cmd>w<CR>', { desc = "Save file", silent = true })
remap('n', '<a-w>', ':q<CR>')

-- Move between windows
remap('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window', silent = true })
remap('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window', silent = true })
remap('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window', silent = true })
remap('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window', silent = true })

-- Escape terminal
-- remap('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode', silent = true })
-- Clear Highlights
remap('n', '<Esc>', '<cmd>nohlsearch<CR>')

remap({ 'v' }, 'c', '"_c', { desc = "", silent = true })
remap('n', 'x', '"_x', { desc = "", silent = true })
remap('n', 'd', '"_d', { desc = "", silent = true })

-- remap('n','dd','"_dd', { desc = "", silent = true})

remap('v', 'x', '"_x', { desc = "", silent = true })
remap('n', '<Up>', ':resize -2<CR>', { desc = 'decrease window height', silent = true })
remap('n', '<Down>', ':resize +2<CR>', { desc = 'increase window height', silent = true })
remap('n', '<Left>', ':vertical resize -2<CR>', { desc = 'decrease window width', silent = true })
remap('n', '<Right>', ':vertical resize +2<CR>', { desc = 'increase window width', silent = true })

remap('n', '<Tab>', ':bnext<CR>', { desc = 'Switch to next buffer', silent = true })
remap('n', '<S-Tab>', ':bprevious<CR>', { desc = 'Switch to previous buffer', silent = true })
remap('n', '<leader>x', ':bdelete<CR>', { desc = 'Delete current buffer' })
remap('n', '<leader>b', '<cmd> enew <CR>', { desc = 'Create a new buffer' })

remap('i', '<a-h>', '<Left>')
remap('i', '<a-l>', '<Right>')
remap('i', '<a-k>', '<Up>')
remap('i', '<a-j>', '<Down>')

remap('v', '>', '>gv', { desc = "", silent = true })
remap('v', '<', '<gv', { desc = "", silent = true })


remap('v', 'p', '"_dP', { desc = "", silent = true })

-- vim.keymap.set('n','<a-h>',':ToggleTerm<CR>')
-- vim.keymap.set('t','<a-h>','<cmd>ToggleTerm<CR>')
-- remap('n',"<leader>'","vi'", {noremap = true, silent = true})
-- remap('n','<leader>"','vi"', {noremap = true, silent = true})
-- remap('n',"<leader>)","vi)", {noremap = true, silent = true})
-- remap('n',"<leader>]","vi]", {noremap = true, silent = true})
-- remap('n',"<leader>}","vi}", {noremap = true, silent = true})


remap("n", "<C-/>", "gcc", { desc = "toggle comment", remap = true })
-- remap("v", "<C-/>", "gc", { desc = "toggle comment", remap = true })

-- remap({"v","n"},"<a-k>", ":m -2<CR>", { desc = "move current line up one line", silent = true})
-- remap({"v","n"},"<a-j>", ":m +1<CR>", { desc = "move current line down one line", silent = true})
