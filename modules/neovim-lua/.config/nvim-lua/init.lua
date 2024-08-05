-- TODOp:
--   * terminal mappings
--   * test framework
--   * debug framework

local base_config_modules = { 'utils', 'options', 'keymaps', 'augroups', 'ui' }
for _, module_name in ipairs(base_config_modules) do
  xpcall(function()
    require(module_name)
  end, function(err)
    print(debug.traceback(err))
  end)
end

-- Load plugins
require('plugin')

-- Load other local config modules
local utils = require('utils')
utils.requireDir('local')
