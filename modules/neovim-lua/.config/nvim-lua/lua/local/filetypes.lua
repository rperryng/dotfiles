vim.filetype.add({
  pattern = {
    ['.*/ghostty/config'] = { 'dosini', { priority = 10 } },
  },
})
