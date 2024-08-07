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
  for _, file in pairs(paths) do
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

  local content = file:read('*all')
  file:close()
  if content:match('microsoft') then
    return true
  else
    return false
  end
end

M.try_require = function(module_name)
  return xpcall(function()
    require(module_name)
  end, function(err)
    print(debug.traceback(err))
  end)
end

local LOG_PATH = os.getenv('HOME') .. '/.local/neovim.log'
local function init_logfile()
  LogFileCleared = LogFileCleared or false
  if LogFileCleared then
    return
  end

  vim.fn.writefile({ '' }, LOG_PATH)
  LogFileCleared = true
end

-- global convenience
Log = function(value)
  init_logfile()

  if type(value) ~= 'string' then
    value = vim.inspect(value)
  end

  -- Use a global value to avoid having to worry how to pass it to
  -- the vimscript context
  _LogValue = value

  vim.cmd('redir >> ' .. LOG_PATH)
  vim.cmd('silent lua vim.print(_LogValue)')
  vim.cmd('redir END')
end

vim.keymap.set('n', '<space>rel', function()
  vim.fn.writefile({ '' }, LOG_PATH)
end, { desc = 'Clear Log file' })

vim.keymap.set(
  'n',
  '<space>ol',
  ':edit ' .. LOG_PATH .. '<cr>',
  { desc = 'open "Log" file' }
)

M.table = {
  deep_copy = function(obj, seen)
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

  uniq = function(t)
    local hash = {}
    local res = {}

    for _, v in ipairs(t) do
      if not hash[v] then
        res[#res + 1] = v -- add to result table
        hash[v] = true -- add to hash
      end
    end

    return res
  end,
}

return M
