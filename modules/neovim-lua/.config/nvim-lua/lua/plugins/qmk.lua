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
    end,
  },
}
