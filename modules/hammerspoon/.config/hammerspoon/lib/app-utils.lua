local M = {}

-- Function to launch or focus an application by bundle ID
function M.launchById(id)
  return function()
    hs.application.launchOrFocusByBundleID(id)
  end
end

-- Function to launch or focus an application by path
function M.launchByPath(path)
  return function()
    hs.application.launchOrFocus(path)
  end
end

return M
