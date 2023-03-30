return {
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    -- NOTE: If you are having trouble with this installation,
    --       refer to the README for telescope-fzf-native for more instructions.
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },
  {
    'nvim-telescope/telescope.nvim',
    version = '*',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      t = require('telescope')
      t.setup({
        defaults = {
          mappings = {
            i = {
              ['<c-u>'] = false,
              ['<c-d>'] = false,
            }
          }
        }
      })
      t.load_extension('fzf')

      builtin = require('telescope.builtin')
      vim.keymap.set('n', '<space>fr', builtin.oldfiles, { desc = '[F]ind [R]ecently opened files' })
      vim.keymap.set('n', '<space>fb', builtin.buffers, { desc = '[F]ind [B]uffers' })
      vim.keymap.set('n', '<space>fi', builtin.find_files, { desc = '[F]ind F[i]les' })
      vim.keymap.set('n', '<space>fh', builtin.help_tags, { desc = '[F]ind [H]elp' })
      vim.keymap.set('n', '<space>fw', builtin.grep_string, { desc = '[F]ind current [W]ord' })
      vim.keymap.set('n', '<space>fg', builtin.live_grep, { desc = '[F]ind by [G]rep' })
      vim.keymap.set('n', '<space>fd', builtin.diagnostics, { desc = '[F]ind [D]iagnostics' })
    end,
  },
}
