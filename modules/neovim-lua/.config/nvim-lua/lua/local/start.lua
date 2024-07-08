local function start()
  if #vim.fn.argv() > 0 then
    return
  end

  local dotfiles_dir = os.getenv('DOTFILES_DIR')
  if dotfiles_dir then
    vim.api.nvim_command('cd ' .. dotfiles_dir)
  end

  vim.cmd('TabooRename dotfiles')

  local config_path = vim.fn.stdpath('config') .. '/init.lua'
  vim.api.nvim_command('edit ' .. config_path)
end

start()
