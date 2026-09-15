local M = {}

local utils = require('utils')
local projects = require('local.projects')
local TERM_BUFFER_PREFIX = '[term]'

local project_terminal_buffer_name = function()
  return string.format('%s (%s)', TERM_BUFFER_PREFIX, projects.get_project_name())
end
M.project_terminal_buffer_name = project_terminal_buffer_name

local find_buffer_by_name = function(name)
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) and vim.fn.bufname(buf) == name then
      return buf
    end
  end
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
  --
  -- Use `belowright split` (splits the current content window) rather than
  -- `botright split` (spans the whole tabpage width). The latter would slice
  -- underneath the full-height tab panel (see local/tabpanel.lua) and cut it
  -- off; `belowright` keeps the split within the content column so the panel
  -- stays full height.
  vim.cmd('wincmd b')
  if not string.match(vim.fn.bufname(), '^' .. utils.escape_pattern(TERM_BUFFER_PREFIX)) then
    vim.cmd('belowright split')
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
  local new_buf = vim.api.nvim_get_current_buf()

  vim.ui.input({ prompt = 'keepalt file ', default = terminal_buf_name .. ' ' }, function(input)
    if not input then
      return
    end

    local name = vim.trim(input)
    if name == '' then
      return
    end

    -- If a buffer with that name already exists, switch to it and throw away
    -- the terminal buffer that was just created for the rename.
    local existing_buf = find_buffer_by_name(name)
    if existing_buf and existing_buf ~= new_buf then
      vim.api.nvim_set_current_buf(existing_buf)
      require('mini.bufremove').delete(new_buf, true)
      return
    end

    vim.cmd('keepalt file ' .. name)
  end)
end, { desc = 'Open new misc terminal' })

return M
