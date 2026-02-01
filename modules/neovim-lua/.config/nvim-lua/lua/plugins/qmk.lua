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

      -- Keyball39
      --
      -- Uses LAYOUT_universal (an alias for LAYOUT_no_ball), which is 42 keys:
      -- 10 per row for the top three rows, then a 12-key thumb row. The thumb
      -- row has no gap because the inner thumb keys tuck underneath the space
      -- between the halves, so it spans all 12 columns.
      --
      -- Note: on a right-ball build three of those thumb positions (R31/R32/R33)
      -- do not physically exist -- that is where the trackball sits -- but they
      -- are still present in the layout macro, so they are counted here.
      vim.api.nvim_create_autocmd('BufEnter', {
        desc = 'Format Keyball39 layout',
        group = augroup,
        pattern = '*keyball/keyball39/keymaps/rperryng/keymap.c',
        callback = function()
          qmk.setup({
            name = 'LAYOUT_universal',
            layout = {
              'x x x x x _ _ _ x x x x x',
              'x x x x x _ _ _ x x x x x',
              'x x x x x _ _ _ x x x x x',
              'x x x x x x _ x x x x x x',
            },
          })
        end,
      })
    end,
  },
}
