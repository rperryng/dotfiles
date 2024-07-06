local M = {}

M.getVisualSelectionContents = function()
  local lines = vim.fn.getregion(
    vim.fn.getpos('v'),
    vim.fn.getpos('.'),
    { type = vim.fn.mode() }
  )

  return vim.fn.join(lines, '\n')
end

M.getCurrentFileRelativePath = function()
  return vim.fn.expand('%:P')
end

M.getCurrentFileAbsolutePath = function()
  return vim.fn.expand('%:p')
end

M.getCurrentBufferContents = function()
  local currentBufferLines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  return table.concat(currentBufferLines, '\n')
end

return M
