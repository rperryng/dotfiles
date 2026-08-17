-- vim.api.nvim_create_user_command('StripWhitespace', function()
--   local save_cursor = vim.api.nvim_win_get_cursor(0)
--   pcall(vim.cmd, [[%s/\s\+$//e]])
--   vim.api.nvim_win_set_cursor(0, save_cursor)
-- end, {})

vim.api.nvim_create_user_command('StripWhitespace', function(opts)
  local start_line = opts.line1
  local end_line = opts.line2
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

  -- Strip trailing whitespace
  for i, line in ipairs(lines) do
    lines[i] = line:gsub('%s+$', '')
  end

  -- Find minimum leading whitespace among non-empty lines
  local min_indent = math.huge
  for _, line in ipairs(lines) do
    if line ~= '' then
      local indent = #line:match('^%s*')
      if indent < min_indent then
        min_indent = indent
      end
    end
  end

  -- Remove the common indent
  if min_indent > 0 and min_indent < math.huge then
    for i, line in ipairs(lines) do
      if line ~= '' then
        lines[i] = line:sub(min_indent + 1)
      end
    end
  end

  vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, lines)
end, { range = '%' })

vim.api.nvim_create_user_command('BufReloadAll', function()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
      local name = vim.api.nvim_buf_get_name(buf)
      if name ~= '' and vim.fn.filereadable(name) == 1 then
        vim.api.nvim_buf_call(buf, function()
          vim.cmd('edit!')
        end)
      end
    end
  end
end, {})
