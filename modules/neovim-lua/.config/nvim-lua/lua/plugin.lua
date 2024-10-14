-- Automatically install Lazy on startup.
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  vim.system({
    'git',
    'clone',
    '--filter=blob:none',
    '--single-branch',
    'https://github.com/folke/lazy.nvim.git',
    lazypath,
  }):wait()
end
vim.opt.runtimepath:prepend(lazypath)

-- Automatically source all configs in plugins directory.
require('lazy').setup('plugins', {
  change_detection = {
    notify = false,
  },
})
