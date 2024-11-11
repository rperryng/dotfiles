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
      vim.keymap.set('n', '<space>wu', function()
        vim.fn['winlayout#restore'](-1)
      end, { desc = 'Undo window layout change' })
      vim.keymap.set('n', '<space>wr', function()
        vim.fn['winlayout#restore'](1)
      end, { desc = 'Redo window layout change' })
    end,
  },

  {
    'onsails/lspkind.nvim',
    config = function()
      require('lspkind').setup()
    end,
  },

  {
    'tzachar/highlight-undo.nvim',
    commit = 'c87a6ec1ded241ef223269077cbd5f97a6f0d5bf',
    -- Make sure this loads last (on keypress), since it relies
    -- on hijacking the u / ctrl-r keys
    keys = { { 'u' }, { '<C-r>' } },
    config = function()
      require('highlight-undo').setup()
    end,
  },
}
