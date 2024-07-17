local M = {}

M.terminal_resize = function()
  local currwin = vim.api.nvim_get_current_win()
  vim.cmd(vim.api.nvim_win_get_number(currwin) .. 'wincmd w')

  local new_size = math.min(20, vim.o.lines / 3)
  vim.cmd('resize ' .. new_size)
  vim.cmd(vim.api.nvim_win_get_number(currwin) .. 'wincmd w')
end

M.toggle_project_terminal = function()
  local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
  local current_win_number = vim.api.nvim_win_get_number(0)

  -- If bottom-most window is not already a terminal buffer, open a new
  -- split to open the terminal buffer in.
  vim.cmd('wincmd b')
  if not string.match(vim.fn.bufname(), '^term-') then
    vim.cmd('botright split')
  end

  -- If the terminal buffer is focused, close it and switch focus back to
  -- the original window
  local terminal_buf_name = 'term-' .. project_name
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

vim.keymap.set('n', '<space>test', function()
  dofile(
    '/Users/rperryng/.dotfiles/modules/neovim-lua/.config/nvim-lua/lua/local/terminal.lua'
  )
end, { desc = 'Reload test config' })

-- setup autocmd on `TermOpen` to :setlocal bufhidden

return M
