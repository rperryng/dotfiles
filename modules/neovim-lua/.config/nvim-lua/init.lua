-- TODO:
--   * Project picker
--   * LSP
--   * autocomplete
--   * terminal mappings
--   * test framework
--   * debug framework

local function loadbaseconfig()
  require('utils')

  require('options')
  require('keymaps')
  require('augroups')
  require('ui')
  require('terminal')
end

xpcall(loadbaseconfig, function(err)
  pint(debug.traceback(err))
end)

-- Load plugins separately from other configs, so that errors in my
-- config files don't stop _everything_ from loading
require('plugin')

-- Load other local configs
local utils = require('utils')
utils.requireDir('local')
