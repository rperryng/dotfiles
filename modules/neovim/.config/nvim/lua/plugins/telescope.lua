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
    opts = {
      defaults = {
        mappings = {
          i = {
            ['<c-u>'] = false,
            ['<c-d>'] = false,
          }
        }
      }
    },
    config = function(_, opts)
      t = require('telescope')
      t.setup(opts)
      t.load_extension('fzf')

      builtin = require('telescope.builtin')

      vim.keymap.set(
        'n',
        '<space>fi',
        function()
          if (vim.fn)

          builtin.find_files()
        end,
        builtin.find_files,
        { desc = '[F]ind F[i]les' }
      )

      vim.keymap.set('n', '<space>fr', builtin.oldfiles, { desc = '[F]ind [R]ecently opened files' })
      vim.keymap.set('n', '<space>fb', builtin.buffers, { desc = '[F]ind [B]uffers' })
      vim.keymap.set('n', '<space>fh', builtin.help_tags, { desc = '[F]ind [H]elp' })
      vim.keymap.set('n', '<space>fw', builtin.grep_string, { desc = '[F]ind current [W]ord' })
      vim.keymap.set('n', '<space>fa', builtin.live_grep, { desc = '[F]ind in [A]ll files' })
      vim.keymap.set('n', '<space>fd', builtin.diagnostics, { desc = '[F]ind [D]iagnostics' })
      vim.keymap.set('n', '<space>fc', builtin.commands, { desc = '[F]ind [C]ommands' })
      vim.keymap.set('n', '<space>fC', builtin.command_history, { desc = '[F]ind [C]ommand history' })
      vim.keymap.set('n', '<space>fs', builtin.search_history, { desc = '[F]ind Search History' })
      vim.keymap.set('n', '<space>fm', builtin.keymaps, { desc = '[F]ind [M]appings' })
      vim.keymap.set('n', '<space>fM', builtin.marks, { desc = '[F]ind [M]arks' })
      vim.keymap.set('n', '<space>fgb', builtin.git_branches, { desc = '[F]ind [G]it [B]ranches' })
    end,
  },
}
