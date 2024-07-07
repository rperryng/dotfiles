local M = {}

-- WIP
M.find_project_dirs = function(max_depth)
  max_depth = max_depth or 2
  local search_root_paths = { os.getenv('HOME') .. '/code' }
  local patterns = { '.git', 'Gemfile' }
  local project_dirs = {}

  for _, search_root_path in ipairs(search_root_paths) do
    for depth = 1, max_depth do
      local search_path = search_root_path .. string.rep('/*', depth)
      for _, pattern in ipairs(patterns) do
        local dirs = vim.fn.globpath(search_path, pattern, 1, 1)

        for _, dir in ipairs(dirs) do
          table.insert(project_dirs, vim.fn.fnamemodify(dir, ':h'))
        end
      end
    end
  end


  return project_dirs
end

vim.keymap.set('n', '<space>fp', function()
  vim.print(M.find_project_dirs())
end, { desc = 'Fuzzy search projects' })

vim.keymap.set('n', '<space>test', function()
  dofile(
    '/Users/rperryng/.dotfiles/modules/neovim-lua/.config/nvim-lua/lua/local/projects.lua'
  )
end, { desc = 'Fuzzy search projects' })

return M
