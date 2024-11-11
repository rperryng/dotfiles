return {
  {
    'yorickpeterse/nvim-window',
    config = function()
      local nvim_window = require('nvim-window')
      nvim_window.setup({
        chars = { 'a', 'r', 's', 't', 'm', 'e', 'i' },
      })

      vim.keymap.set('n', '<leader>wj', function()
        nvim_window.pick()
      end, { desc = 'nvim-window: Jump to window' })
    end,
  },
}
