return {
  {
    'codethread/qmk.nvim',
    config = function()
      local qmk = require('qmk')
      -- qmk.setup({
      --   name = 'LAYOUT',
      --   layout = { -- create a visual representation of your final layout
      --     'x x x x x x x _ _ _ _ _ _ _ x x x x x x x',
      --     'x x x x x x x _ _ _ _ _ _ _ x x x x x x x',
      --     'x x x x x x x _ _ _ _ _ _ _ x x x x x x x',
      --     'x x x x x x _ _ _ _ _ _ _ _ _ x x x x x x',
      --     'x x x x x _ _ _ x _ _ _ x _ _ _ x x x x x',
      --     '_ _ _ _ _ _ _ x x x _ x x x _ _ _ _ _ _ _',
      --   },
      -- })

      local augroup =
        vim.api.nvim_create_augroup('qmk_layouts', { clear = true })

      -- Moonlander
      vim.api.nvim_create_autocmd('BufEnter', {
        desc = 'Format moonlander layout',
        group = augroup,
        pattern = '*zsa/moonlander/keymaps/rperryng/keymap.c',
        callback = function()
          qmk.setup({
            name = 'LAYOUT',
            layout = {
              'x x x x x x x _ _ _ _ _ _ _ x x x x x x x',
              'x x x x x x x _ _ _ _ _ _ _ x x x x x x x',
              'x x x x x x x _ _ _ _ _ _ _ x x x x x x x',
              'x x x x x x _ _ _ _ _ _ _ _ _ x x x x x x',
              'x x x x x _ _ _ x _ _ _ x _ _ _ x x x x x',
              '_ _ _ _ _ _ _ x x x _ x x x _ _ _ _ _ _ _',
            },
          })
        end,
      })

      -- Ergodox EZ (Glow)
      vim.api.nvim_create_autocmd('BufEnter', {
        desc = 'Format Ergodox EZ (Glow) layout',
        group = augroup,
        pattern = '*ergodox_ez/glow/keymaps/rperryng/keymap.c',
        callback = function()
          qmk.setup({
            name = 'LAYOUT_ergodox_pretty',
            layout = { -- create a visual representation of your final layout
              'x x x x x x x _ _ _ _ _ _ _ x x x x x x x',
              'x x x x x x x _ _ _ _ _ _ _ x x x x x x x',
              'x x x x x x _ _ _ _ _ _ _ _ _ x x x x x x',
              'x x x x x x x _ _ _ _ _ _ _ x x x x x x x',
              'x x x x x _ _ _ _ _ _ _ _ _ _ _ x x x x x',
              '_ _ _ _ _ _ _ _ x x _ x x _ _ _ _ _ _ _ _',
              '_ _ _ _ _ _ _ _ _ x _ x _ _ _ _ _ _ _ _ _',
              '_ _ _ _ _ _ _ x x x _ x x x _ _ _ _ _ _ _',
            },
          })
        end,
      })

      -- DASBOBgs
      --
      vim.api.nvim_create_autocmd('BufEnter', {
        desc = 'Format DASBOB layout',
        group = augroup,
        pattern = '*dasbob/keymaps/rperryng/keymap.c',
        callback = function()
          qmk.setup({
            name = 'LAYOUT_split_3x5_3',
            layout = {
              'x x x x x _ _ _ x x x x x',
              'x x x x x _ _ _ x x x x x',
              'x x x x x _ _ _ x x x x x',
              '_ _ _ x x x _ x x x _ _ _',
            },
          })
        end,
      })

      -- Keyball39 (right-ball build)
      --
      -- Uses LAYOUT_right_ball, which is 39 keys: 10 per row for the top
      -- three rows, then a 9-key thumb row. The trackball sits on the right
      -- board where R31/R32/R33 would otherwise be, so those positions don't
      -- exist in the macro at all (unlike LAYOUT_universal/LAYOUT_no_ball,
      -- which include them as unused slots).
      vim.api.nvim_create_autocmd('BufEnter', {
        desc = 'Format Keyball39 layout',
        group = augroup,
        pattern = '*keyball/keyball39/keymaps/rperryng/keymap.c',
        callback = function()
          qmk.setup({
            name = 'LAYOUT_right_ball',
            layout = {
              'x x x x x _ _ _ x x x x x',
              'x x x x x _ _ _ x x x x x',
              'x x x x x _ _ _ x x x x x',
              'x x x x x x _ x x _ _ _ x',
            },
          })
        end,
      })
    end,
  },
}
