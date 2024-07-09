return {
  {
    'gcmt/taboo.vim',
    config = function()
      vim.g.taboo_tab_format = ' [%N-NoName]%m '
      vim.g.taboo_renamed_tab_format = ' [%N-%l]%m '

      vim.keymap.set('n', '<space>ret', function()
        local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
        vim.fn.feedkeys(':TabooRename ' .. project_name)
      end, { noremap = true, silent = true, desc = 'Rename tab' })
    end,
  },
}
