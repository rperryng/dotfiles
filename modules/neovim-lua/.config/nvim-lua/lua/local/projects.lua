local M = {}

local projectRootDir = os.getenv('HOME') .. '/code'

-- TODO ...
M.getProjectPaths = function()
  local folders = vim.fn.glob(projectRootDir .. '/*')
end

return M
