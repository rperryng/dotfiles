local base_config_modules = { 'utils', 'options', 'keymaps', 'augroups', 'ui' }
for _, module_name in ipairs(base_config_modules) do
  xpcall(function()
    require(module_name)
  end, function(err)
    print('failed to load module ' .. module_name)
    print(debug.traceback(err))
  end)
end

