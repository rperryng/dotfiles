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
vim.keymap.set('n', '<space>rm', '<cmd>Redir messages<cr>', { desc = '[R]edirect "[M]essages" command output to a new buffer' })

-- Project Terminal (terminal based on cwd)
-- local function toggle_terminal()
--   local bufname_pattern = 'term://' .. vim.fn.expand('%:p:t')
--   local terminal_buf = vim.fn.bufnr(bufname_pattern)
--
--   if terminal_buf == -1 then
--     -- Create a new terminal buffer
--     terminal_buf = vim.api.nvim_create_buf(true, true)
--     vim.api.nvim_buf_set_name(terminal_buf, bufname_pattern)
--
--     local cmd = vim.fn.expand('$SHELL')
--     vim.fn.termopen(cmd)
--   end
--
--   local win = vim.fn.bufwinnr(terminal_buf)
--   if win == -1 then
--     -- Terminal buffer is not visible, create a new window
--     local columns = vim.api.nvim_get_option('columns')
--     local lines = vim.api.nvim_get_option('lines')
--     local split_height = math.floor(lines * 0.3)
--
--     vim.cmd('topleft ' .. split_height .. 'sp')
--     vim.api.nvim_win_set_buf(0, terminal_buf)
--   else
--     -- Terminal buffer is visible, close the window
--     vim.api.nvim_win_close(win, true)
--   end
-- end

local function terminal_resize()
  local current_win = vim.api.nvim_get_current_win()
  local current_tab = vim.api.nvim_get_current_tabpage()
  local windows = vim.api.nvim_tabpage_list_wins(current_tab)
  local last_window = windows[#windows]
  vim.api.nvim_set_current_win(last_window)

  local new_size = math.min(20, math.floor(vim.o.lines / 3))
  vim.api.nvim_win_set_height(0, new_size)
  vim.api.nvim_set_current_win(current_win)
end

local function toggle_project_terminal()
  local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
  local current_buf_name = vim.fn.expand('%')
  local terminal_buf_name = 'term-' .. project_name

  vim.cmd('wincmd b')
  if string.find(current_buf_name, '^term-') == nil then
    vim.cmd('botright split')
    terminal_resize()
  end

  if vim.fn.buflisted(terminal_buf_name) == 0 then
    vim.cmd('terminal')
    vim.api.nvim_buf_set_name(0, terminal_buf_name)
  elseif current_buf_name ~= terminal_buf_name then
    vim.cmd('edit ' .. terminal_buf_name)
  else
    vim.cmd('quit')
  end
end


vim.keymap.set(
  'n',
  '<space>T',
  toggle_project_terminal,
  {noremap = true, silent = true}
)

local function eval_visual_selection()
  -- Get the visual selection
  local start_line = vim.fn.getpos("'<")[2]
  local start_col = vim.fn.getpos("'<")[3]
  local end_line = vim.fn.getpos("'>")[2]
  local end_col = vim.fn.getpos("'>")[3]

  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

  -- Get the selected text
  lines[1] = lines[1]:sub(start_col)
  lines[#lines] = lines[#lines]:sub(1, end_col - 1)
  local code = table.concat(lines, '\n')

  -- Evaluate the code
  local ok, result = pcall(loadstring(code))
  if not ok then
    vim.api.nvim_err_writeln("Error evaluating code: " .. result)
  else
    print("Evaluated: " .. code)
  end
end

vim.keymap.set('v', '<space>se', eval_visual_selection)

