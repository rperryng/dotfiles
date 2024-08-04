-- TODOp:
--   * Project picker
--   * LSP
--   * autocomplete
--   * terminal mappings
--   * test framework
--   * debug framework

local function loadbaseconfig()
  local utils = require('utils')
  utils.try_require('options')
  utils.try_require('keymaps')
  utils.try_require('augroups')
  utils.try_require('ui')
end

xpcall(loadbaseconfig, function(err)
  print(debug.traceback(err))
end)

-- Load plugins separately from other configs, so that errors in my
-- config files don't stop _everything_ from loading
require('plugin')

-- Load other local configs
local utils = require('utils')
utils.requireDir('local')
