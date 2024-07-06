local M = {}

M.getVisualSelectionContents = function()
  local lines = vim.fn.getregion(vim.fn.getpos('v'), vim.fn.getpos('.'), { type = vim.fn.mode() })
  local text = vim.fn.join(lines, '\n')

  return text
end

return M
