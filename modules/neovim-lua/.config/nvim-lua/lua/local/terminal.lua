local M = {}

local utils = require('utils')
local projects = require('local.projects')
local TERM_BUFFER_PREFIX = '[term]'

local project_terminal_buffer_name = function()
  return string.format('%s (%s)', TERM_BUFFER_PREFIX, projects.get_project_name())
end

M.terminal_resize = function()
  local currwin = vim.api.nvim_get_current_win()
  vim.cmd(vim.api.nvim_win_get_number(currwin) .. 'wincmd w')

  local new_size = math.min(20, vim.o.lines / 3)
  vim.cmd('resize ' .. new_size)
  vim.cmd(vim.api.nvim_win_get_number(currwin) .. 'wincmd w')
end

M.toggle_project_terminal = function()
  local current_win_number = vim.api.nvim_win_get_number(0)

  -- If bottom-most window is not already a terminal buffer, open a new
  -- split to open the terminal buffer in.
  vim.cmd('wincmd b')
  if not string.match(vim.fn.bufname(), '^' .. utils.escape_pattern(TERM_BUFFER_PREFIX)) then
    vim.cmd('botright split')
  end

  -- If the terminal buffer is focused, close it and switch focus back to
  -- the original window
  local terminal_buf_name = project_terminal_buffer_name()
  if vim.fn.bufname() == terminal_buf_name then
    vim.cmd('quit')
    if vim.api.nvim_win_is_valid(current_win_number) then
      vim.cmd(current_win_number .. 'wincmd w')
    end
    return
  end

  -- If the term doesn't exist, create it
  if vim.fn.buflisted(terminal_buf_name) == 0 then
    vim.cmd('terminal')
    vim.cmd('keepalt file ' .. terminal_buf_name)
    return
  end

  -- Otherwise, the buf already exists but isn't focused, so switch to it
  vim.cmd('edit ' .. terminal_buf_name)
end

vim.keymap.set('n', '<space>tt', function()
  M.toggle_project_terminal()
end, { desc = 'Toggle project terminal' })

vim.keymap.set('n', '<space>tR', function()
  local current_bufname = vim.fn.bufname()
  if not current_bufname:match('^' .. utils.escape_pattern(TERM_BUFFER_PREFIX)) then
    return
  end

  require('mini.bufremove').delete()
  vim.cmd('terminal')
  vim.cmd('keepalt file ' .. current_bufname)
end, { desc = 'Restart project terminal' })

vim.keymap.set('n', '<space>term', function()
  local terminal_buf_name = project_terminal_buffer_name()
  vim.cmd('terminal')
  vim.fn.feedkeys(':keepalt file ' .. terminal_buf_name .. ' ')
end, { desc = 'Open new misc terminal' })

vim.keymap.set('n', '<space>test', function()
  dofile(
    '/Users/rperryng/.dotfiles/modules/neovim-lua/.config/nvim-lua/lua/local/terminal.lua'
  )
end, { desc = 'Reload test config' })

return M
