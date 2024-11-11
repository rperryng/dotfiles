return {
  {
    'bfredl/nvim-luadev',
    config = function ()
      vim.keymap.set('v', '<space>E', '<Plug>(Luadev-Run)', { desc = 'Eval with luadev' })
    end
  }
}
