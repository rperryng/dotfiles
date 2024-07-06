-- TODO:
--   * Project picker
--   * LSP
--   * autocomplete
--   * tabline
--   * terminal mappings
--   * test framework
--   * depug framework

local function loadbaseconfig()
  require('utils')

  require('options')
  require('keymaps')
  require('augroups')
  require('ui')
  require('terminal')
end

xpcall(loadbaseconfig, function(err)
  print(debug.traceback(err))
end)

-- Load plugins separately from other configs, so that errors in my
-- config files don't stop _everything_ from loading
require('plugin')
