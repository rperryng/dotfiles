vim.filetype.add({
  pattern = {
    ['.*/ghostty/config'] = { 'dosini', { priority = 10 } },
  },
  filename = {
    ['.vrapper'] = 'vim',
  },
  extension = {
    gitconfig = 'gitconfig',
  }
})
