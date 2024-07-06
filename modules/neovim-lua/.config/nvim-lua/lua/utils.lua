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

M.requireDir = function(dir)
  local baseDir = vim.fn.stdpath('config') .. '/lua'
  local pattern = table.concat({ baseDir, dir, '*.lua' }, '/')
  local paths = vim.split(vim.fn.glob(pattern), '\n')
  local dirModuleName = dir:gsub('/', '.')
  for _i, file in pairs(paths) do
    local localModuleName = file:match('^.+/(.+).lua$')

    xpcall(function()
      require(dirModuleName .. '.' .. localModuleName)
    end, function(err)
      print(debug.traceback(err))
    end)
  end
end

return M
