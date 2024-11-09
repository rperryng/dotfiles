return {
  {
    'codethread/qmk.nvim',
    config = function()
      local qmk = require('qmk')
      qmk.setup({
        name = 'LAYOUT',
        -- comment_preview = {
        --   keymap_overrides = {
        --     HERE_BE_A_LONG_KEY = 'Magic', -- replace any long key codes
        --   },
        -- },
        layout = { -- create a visual representation of your final layout
          'x x x x x x x _ _ _ _ _ _ _ x x x x x x x',
          'x x x x x x x _ _ _ _ _ _ _ x x x x x x x',
          'x x x x x x x _ _ _ _ _ _ _ x x x x x x x',
          'x x x x x x _ _ _ _ _ _ _ _ _ x x x x x x',
          'x x x x x _ _ _ x _ _ _ x _ _ _ x x x x x',
          '_ _ _ _ _ _ _ x x x _ x x x _ _ _ _ _ _ _',
        },
      })
    end,
  },
}

