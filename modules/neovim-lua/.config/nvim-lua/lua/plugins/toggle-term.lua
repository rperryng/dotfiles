return {
  {
    'akinsho/toggleterm.nvim',
    config = function()
      require('toggleterm').setup({
        winbar = {
          enabled = false,
        }
      })

      vim.keymap.set('n', '<space>tm', function()
        local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
        vim.cmd('ToggleTerm name=' .. project_name)
      end, { desc = 'Toggle terminal' })
    end,
  },
}
