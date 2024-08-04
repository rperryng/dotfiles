-- TODOp:
--   * LSP
--   * terminal mappings
--   * test framework
--   * debug framework

-- local utils = require('utils')
-- utils.try_require('options')
-- utils.try_require('keymaps')
-- utils.try_require('augroups')
-- utils.try_require('ui')

local base_config_modules = { 'utils', 'options', 'keymaps', 'augroups', 'ui' }
for _, module_name in ipairs(base_config_modules) do
  xpcall(function()
    require(module_name)
  end, function(err)
    print(debug.traceback(err))
  end)
end

-- Load plugins separately from other configs, so that errors in my
-- config files don't stop _everything_ from loading
require('plugin')

-- Load other local configs
local utils = require('utils')
utils.requireDir('local')
