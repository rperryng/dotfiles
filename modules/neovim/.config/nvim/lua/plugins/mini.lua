return {
  {
    'echasnovski/mini.bracketed',
    version = false,
    config = function()
      require('mini.bracketed').setup()
    end,
  },
  {
    'echasnovski/mini.trailspace',
    version = false,
    config = function()
      require('mini.trailspace').setup()
      vim.keymap.set('n', '<space>c', '<cmd>lua MiniTrailspace.trim()<cr>', { desc = 'Trim Trailing whitespace' })
    end,
  },
  {
    'echasnovski/mini.pairs',
    version = false,
    config = function()
      require('mini.pairs').setup()
    end,
  },
  {
    'echasnovski/mini.move',
    version = false,
    config = function()
      require('mini.move').setup()
    end,
  },
  {
    'echasnovski/mini.surround',
    version = false,
    config = function()
      require('mini.surround').setup()
    end,
  },
}
