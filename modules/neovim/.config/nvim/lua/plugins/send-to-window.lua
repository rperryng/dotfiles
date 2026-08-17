return {
  {
    'karoliskoncevicius/vim-sendtowindow',
    init = function()
      vim.g.sendtowindow_use_defaults = 0
    end,
    config = function()
      vim.keymap.set('n', '<space>wl', '<Plug>SendRight', { desc = 'Send to right window' })
      vim.keymap.set('x', '<space>wl', '<Plug>SendRightV', { desc = 'Send to right window' })
      vim.keymap.set('n', '<space>wh', '<Plug>SendLeft', { desc = 'Send to left window' })
      vim.keymap.set('x', '<space>wh', '<Plug>SendLeftV', { desc = 'Send to left window' })
      vim.keymap.set('n', '<space>wk', '<Plug>SendUp', { desc = 'Send to upper window' })
      vim.keymap.set('x', '<space>wk', '<Plug>SendUpV', { desc = 'Send to upper window' })
      vim.keymap.set('n', '<space>wj', '<Plug>SendDown', { desc = 'Send to lower window' })
      vim.keymap.set('x', '<space>wj', '<Plug>SendDownV', { desc = 'Send to lower window' })
    end,
  },
}
