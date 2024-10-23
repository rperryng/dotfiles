local M = {}

M.new = function(list)
  local lookup = {}
  for _, v in ipairs(list) do
    lookup[v] = true
  end

  return {
    values = function()
      local values = {}
      for k, _ in pairs(lookup) do
        table.insert(values, k)
      end
      return values
    end,
    has = function(value)
      return lookup[value] ~= nil
    end,
    insert = function(value)
      lookup[value] = true
      return value
    end,
    delete = function(value)
      lookup[value] = nil
      return value
    end,
  }
end

return M
