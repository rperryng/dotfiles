vim.filetype.add({
  pattern = {
    ['.*/ghostty/config'] = { 'dosini', { priority = 10 } },
    ['${DOTFILES_DIR}/modules/git/.config/git/config.*'] = { 'gitconfig', { priority = 10 } },
  },
  filename = {
    ['.vrapper'] = 'vim',
  },
})
-- Log('this should be running ...')
--
-- vim.filetype.add({
--   pattern = {
--     ['$HOME/.config/git/*'] = 'gitconfig',
--     ['$HOME/.dotfiles/modules/git/.config/git/config*'] = 'gitconfig',
--   },
-- })
