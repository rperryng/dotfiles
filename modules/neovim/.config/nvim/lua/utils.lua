-- Redirect vim command to new buffer
local function redir_command(arg_table)
  local cmd = arg_table.args
  local reg = vim.fn.getreg('"')
  local escaped_cmd = vim.fn.escape(cmd, '"')

  vim.cmd('redir @">')
  vim.cmd('silent execute "' .. escaped_cmd .. '"')
  vim.cmd('redir END')
  vim.cmd('enew')
  vim.cmd('put')
  vim.cmd('1,2delete _')
  vim.fn.setreg('"', reg)
end
vim.api.nvim_create_user_command('Redir', redir_command, { nargs = '+', complete = 'command' })

-- Project Terminal (terminal based on cwd)
local function toggle_terminal()
  print ("running")
  local bufname_pattern = "term://" .. vim.fn.expand("%:p:h")
  local terminal_buf = vim.fn.bufnr(bufname_pattern)

  if terminal_buf == -1 then
    -- Create a new terminal buffer
    terminal_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(terminal_buf, bufname_pattern)
    vim.api.nvim_buf_set_option(terminal_buf, "buftype", "terminal")

    local cmd = vim.fn.expand("$SHELL")
    vim.fn.termopen(cmd)
  end

  local win = vim.fn.bufwinnr(terminal_buf)
  if win == -1 then
    -- Terminal buffer is not visible, create a new window
    local columns = vim.api.nvim_get_option("columns")
    local lines = vim.api.nvim_get_option("lines")
    local split_height = math.floor(lines * 0.3)

    vim.cmd("topleft " .. split_height .. "sp")
    vim.api.nvim_win_set_buf(0, terminal_buf)
  else
    -- Terminal buffer is visible, close the window
    vim.api.nvim_win_close(win, true)
  end
end

-- vim.keymap.sewa('n', '<space>wa', '<cmd>wall<cr><cmd>set nohlsearch<cr>', { desc = '[wa] Write all', silent = true })
vim.keymap.set(
  'n',
  '<space>T',
  toggle_terminal,
  {noremap = true, silent = true}
)
