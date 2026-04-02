vim.api.nvim_create_user_command('StripWhitespace', function()
  local save_cursor = vim.api.nvim_win_get_cursor(0)
  pcall(vim.cmd, [[%s/\s\+$//e]])
  vim.api.nvim_win_set_cursor(0, save_cursor)
end, {})

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
