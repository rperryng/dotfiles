return {
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
  },
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require('telescope').setup({
        defaults = {
          mappings = {
            i = {
              -- restore my most commonly-used emacs-style navigation keymappings in insert mode
              ['<c-a>'] = function()
                vim.cmd.normal('^')
              end,
              ['<c-e>'] = function()
                vim.cmd.normal('$')
              end,
              ['<c-w>'] = function()
                vim.cmd.normal('db')
              end,
              ['<c-u>'] = function()
                vim.cmd.normal('d^')
              end,

              -- rebind the defaults to unused keys
              ['<c-s-u>'] = 'preview_scrolling_up',
              ['<c-s-d>'] = 'preview_scrolling_down',
            },
          },
        },
      })
      require('telescope').load_extension('fzf')

      local builtin = require('telescope.builtin')
      vim.keymap.set(
        'n',
        '<space>ff',
        builtin.find_files,
        { desc = 'Fuzzy search files' }
      )
      vim.keymap.set('n', '<space>fg', function()
        builtin.grep_string({
          path_display = { 'smart' },
          only_sort_text = false,
          word_match = '-w',
          search = '',
        })
      end, { desc = 'Fuzzy search code (match on filenames too)' })

      vim.keymap.set('n', '<space>fG', function()
        builtin.grep_string({
          path_display = { 'smart' },
          only_sort_text = true,
          word_match = '-w',
          search = '',
        })
      end, { desc = 'Fuzzy search code (no matching on filenames)' })

      vim.keymap.set(
        'n',
        '<space>fb',
        builtin.buffers,
        { desc = 'Fuzzy search buffers' }
      )
      vim.keymap.set(
        'n',
        '<space>fh',
        builtin.help_tags,
        { desc = 'Fuzzy search help docs' }
      )

      vim.keymap.set(
        'n',
        '<space>fr',
        builtin.registers,
        { desc = 'Fuzzy search registers' }
      )
      vim.keymap.set(
        'n',
        '<space>fk',
        builtin.keymaps,
        { desc = 'Fuzzy search keymaps' }
      )
    end,
  },
}
