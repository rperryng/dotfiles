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

-- Check if lazypath is empty
-- This can happen if the clone fails because:
--   - my git config prefers ssh instead of https
--   - my ssh is configured to use the 1pw CLI
--   - the `vim.system(...)` call doesn't successfully prompt the 1pw gui
local lazypath_contents = vim.fn.readdir(lazypath)
if #lazypath_contents == 0 then
  local clone_command = "git clone --filter=blob:none --single-branch https://github.com/folke/lazy.nvim.git " .. lazypath
  vim.fn.setreg("+", clone_command)
  error("lazypath folder is empty: " .. lazypath .. ". The git clone likely failed. The clone command has been copied to your clipboard: '" .. clone_command .. "'")
end

vim.opt.runtimepath:prepend(lazypath)

-- Automatically source all configs in plugins directory.
require('lazy').setup({
  spec = {
    { import = "plugins" },
  },
  install = { colorscheme = { "gruvbox" }},
  change_detection = {
    notify = false,
  },
})
