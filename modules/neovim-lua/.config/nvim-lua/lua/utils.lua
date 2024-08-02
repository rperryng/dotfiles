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

M.is_wsl = function()
  local version_path = '/proc/version'
  local file = io.open(version_path, 'r')
  if not file then
    return false
  end

  content = file:read('*all')
  file:close()
  if content:match('microsoft') then
    return true
  else
    return false
  end
end

M.table = {
  deep_copy = function(obj, seen)
    -- Handle non-tables and previously-seen tables.
    if type(obj) ~= 'table' then
      return obj
    end
    if seen and seen[obj] then
      return seen[obj]
    end

    -- New table; mark it as seen and copy recursively.
    local s = seen or {}
    local res = {}
    s[obj] = res
    for k, v in pairs(obj) do
      res[M.table.deep_copy(k, s)] = M.table.deep_copy(v, s)
    end
    return setmetatable(res, getmetatable(obj))
  end,
}

return M
