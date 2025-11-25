return {
  {
    'gbprod/yanky.nvim',
    config = function()
      require('yanky').setup({})
      vim.keymap.set('n', '<space>fy', ':YankyRingHistory<cr>', { desc = 'Fuzzy search yank history' })
    end
  }
}
