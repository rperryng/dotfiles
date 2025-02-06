vim.filetype.add({
  pattern = {
    ['.*/ghostty/config'] = { 'dosini', { priority = 10 } },
  },
  filename = {
    ['.vrapperrc'] = 'vim',
  },
  extension = {
    gitconfig = 'gitconfig',
  }
})
