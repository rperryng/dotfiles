return {
  {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require('ibl').setup({
        indent = {
          char = '▏',
        },
        scope = {
          enabled = false,
        },
      })
    end,
  },

  {
    'habamax/vim-winlayout',
    config = function()
      vim.keymap.set(
        'n',
        '<space>wu',
        function()
          vim.fn['winlayout#restore'](-1)
        end,
        { desc = 'Undo window layout change' }
      )
      vim.keymap.set(
        'n',
        '<space>wr',
        function()
          vim.fn['winlayout#restore'](1)
        end,
        { desc = 'Redo window layout change' }
      )
    end
  }
}
