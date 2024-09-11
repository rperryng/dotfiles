return {
  {
    'mhartington/formatter.nvim',
    event = 'VeryLazy',
    config = function()
      local util = require('formatter.util')

      require('formatter').setup({
        filetype = {
          lua = {
            require('formatter.filetypes.lua').stylua,
          },

          json = {
            require('formatter.filetypes.json').jq,
          },

          ruby = {
            require('formatter.filetypes.ruby').rubocop,
          },

          typescript = {
            require('formatter.filetypes.typescript').prettier,
          },

          ['*'] = {
            require('formatter.filetypes.any').remove_trailing_whitespace,
          },
        },
      })

      vim.keymap.set(
        'n',
        '<space>fo',
        '<cmd>Format<cr>',
        { desc = 'Format Buffer' }
      )
    end,
  },
}
