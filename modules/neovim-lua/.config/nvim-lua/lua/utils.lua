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

M.close_floating_windows = function()
  local found_float = false
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_config(win).relative ~= '' then
      vim.api.nvim_win_close(win, true)
      found_float = true
    end
  end

  return found_float
end

-- global convenience
Log = function(...)
  local args = table.pack(...)
  for i = 1, args.n do
    _Log(args[i])
  end
end

_Log = function(value)
  init_logfile()

  if type(value) ~= 'string' then
    value = vim.inspect(value)
  end

  -- Use a global value to avoid having to worry about how to properly
  -- pass it from the lua context to the vimscript context
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

M.escape_pattern = function(text)
  return text:gsub('([^%w])', '%%%1')
end

-- Call '<Plug>(name)' from lua
M.call_plug_map = function(plug_map_name, mode_arg)
  mode_arg = mode_arg or 'n'
  local mode_map = {
    n = 'normal',
    v = 'visual',
    x = 'visual',
    i = 'insert',
    c = 'command',
    t = 'terminal',
  }

  local mode = mode_map[mode_arg]
  if mode == nil then
    error(mode_arg .. ' is not a valid mode shorthand')
  end
  vim.cmd(string.format('execute "%s \\%s"', mode, plug_map_name))
end

M.iconify = function(item, icon)
  return ('%s  %s'):format(icon, item)
end
M.uniconify = function(line)
  -- - `^` - Start of string
  -- - `[^\32-\126]*` - Skip zero or more non-ASCII characters (including Unicode icons)
  --   - `\32-\126` is the range of printable ASCII characters (space through ~)
  --   - `[^\32-\126]` matches anything outside this range (like Unicode icons)
  -- - `%s*` - Skip zero or more whitespace characters  
  -- - `(.+)` - Capture one or more of any remaining characters
  return line:match("^[^\32-\126]*%s*(.+)")
end

-- polyfill table.pack ...
table.pack = function(...)
  local t = { ... }
  t.n = select('#', ...)
  return t
end

M.table = {
  -- http://lua-users.org/wiki/CopyTable
  shallow_copy = function(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
      copy = {}
      for orig_key, orig_value in pairs(orig) do
        copy[orig_key] = orig_value
      end
    else -- number, string, boolean, etc
      copy = orig
    end
    return copy
  end,

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
