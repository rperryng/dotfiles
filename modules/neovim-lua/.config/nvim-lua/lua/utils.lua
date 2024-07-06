local M = {}

M.getVisualSelectionContents = function()
  local mode = vim.fn.mode()
  local pos1 = vim.fn.getpos('v')
  local pos2 = vim.fn.getpos('.')
  local lines = vim.fn.getregion(pos1, pos2, { type = mode })
  local text = vim.fn.join(lines, '\n')

  vim.fn.setreg('+', text)
  return text
end

return M
