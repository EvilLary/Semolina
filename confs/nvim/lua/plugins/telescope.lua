return {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
        'nvim-lua/plenary.nvim',
        {
            'nvim-telescope/telescope-fzf-native.nvim',
            build = 'make',
            cond = function()
            return vim.fn.executable 'make' == 1
            end,
        },
        { 'nvim-telescope/telescope-ui-select.nvim' },
        { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      require('telescope').setup ({
          defaults = {
              path_display = {'smart'},
              file_ignore_patterns = {
                  "/home/spicy/disks/WD1TB/",
              },
              prompt_prefix = "   ",
              selection_caret = " ",
              entry_prefix = " ",
              sorting_strategy = "ascending",
              layout_config = {
                  horizontal = {
                     prompt_position = "top",
                      preview_width = 0.55,
                  },
                  width = 0.87,
                  height = 0.80,
              },
              mappings = {
                  n = { ["q"] = require("telescope.actions").close },
              },
          },
      })
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>ff',  builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>fo', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
  end,
}
