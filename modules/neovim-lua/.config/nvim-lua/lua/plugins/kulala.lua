return {
  {
    'mistweaverco/kulala.nvim',
    ft = { 'http', 'rest' },
    config = function()
      local kulala = require('kulala');
      kulala.setup({
        global_keymaps = true,
      })

      vim.keymap.set('n', '<space>Ry', function()
        kulala.copy()
      end, { desc = 'Copy HTTP request to clipboard (as cURL command)' });
    end,
  },
}
