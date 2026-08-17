return {
  {
    'jake-stewart/multicursor.nvim',
    dependencies = { 'nvimtools/hydra.nvim' },
    branch = '1.0',
    config = function()
      local mc = require('multicursor-nvim')
      mc.setup()

      vim.keymap.set({ 'n', 'v' }, '<space>mc', function()
        mc.addCursor('*')
      end, { desc = 'Multicursor (add word under cursor)' })

      vim.keymap.set({ 'n', 'v' }, '<space>ms', function()
        mc.skipCursor('*')
      end, { desc = 'Multicursor (skip word under cursor)' })

      vim.keymap.set({ 'n', 'v' }, '<space>mx', function()
        mc.deleteCursor()
      end, { desc = 'Multicursor (skip word under cursor)' })

      vim.keymap.set({ 'n', 'v' }, '<space>mx', function()
        mc.clearCursors()
      end, { desc = 'Multicursor (skip word under cursor)' })

      local hydra = require('hydra')
      hydra({
        name = 'Multicursor',
        config = {
          hint = false,
        },
        mode = 'n',
        body = '<space>HC',
        heads = {
          {
            'j',
            function()
              mc.addCursor('j')
            end,
          },
          {
            'k',
            function()
              mc.skipCursor('k')
            end,
          },
        },
      })
    end,
  },
}
