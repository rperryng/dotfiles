return {
  {
    'echasnovski/mini.bufremove',
    version = '*',
    config = function()
      require('mini.bufremove').setup()

      vim.keymap.set('n', '<space>bd', '<cmd>lua MiniBufremove.delete(0, true)<cr>', { desc = 'Delete Buffer' })
    end,
  },
}

