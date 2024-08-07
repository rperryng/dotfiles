return {
  {
    'mhartington/formatter.nvim',
    event = 'VeryLazy',
    init = function()
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
