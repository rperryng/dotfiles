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
      vim.keymap.set('n', '<space>ff', builtin.find_files, {})
      vim.keymap.set('n', '<space>fg', builtin.live_grep, {})
      vim.keymap.set('n', '<space>fb', builtin.buffers, {})
      vim.keymap.set('n', '<space>fh', builtin.help_tags, {})

      vim.keymap.set('n', '<space>fr', builtin.registers, {})
      vim.keymap.set('n', '<space>fk', builtin.keymaps, {})
    end,
  },
}
