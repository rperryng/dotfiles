return {
  {
    'gcmt/taboo.vim',
    init = function()
      vim.g.taboo_tab_format=' [%N-%P]%m '
      vim.g.taboo_renamed_tab_format=' [%N-%P]%m '
    end,
  }
}
