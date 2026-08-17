return {
  {
    'mbbill/undotree',
    config = function()
      vim.keymap.set(
        'n',
        '<space>U',
        vim.cmd.UndotreeToggle,
        { desc = 'Undo tree' }
      )
    end,
  },
}
