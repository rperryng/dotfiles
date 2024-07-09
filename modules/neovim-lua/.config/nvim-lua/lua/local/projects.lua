-- TODO:
-- 1. read from clone_urls path
-- 2. clone the repo if it doesn't exist yet
-- 3. re-run the refresh_clone_urls script after completion
-- 4. extract to plugin

local M = {}

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

M.open_project = function(project_dir)
  local project_name = vim.fn.fnamemodify(project_dir, ':t')
  local current_tabnr = vim.fn.tabpagenr()

  -- If an existing tab already uses this working directory, switch to it.
  for tabnr = 1, vim.fn.tabpagenr('$') do
    vim.cmd(tabnr .. 'tabnext')
    local tcd = vim.fn.getcwd()
    if tcd == project_dir then
      return
    end
  end

  -- Otherwise, create a new one with that working directory.
  vim.cmd(current_tabnr .. 'tabnext')
  vim.cmd('tabnew')
  vim.cmd('tchdir ' .. project_dir)
  vim.cmd('TabooRename ' .. project_name)
end

-- Fzf Lua
local projects_picker_fzf_lua = function()
  require('fzf-lua').fzf_exec(M.find_project_dirs(), {
    actions = {
      -- Use fzf-lua builtin actions or your own handler
      ['default'] = function(selected, opts)
        if #selected == 0 then
          return
        end

        M.open_project(selected[1])
      end,
    },
  })
end

vim.keymap.set(
  'n',
  '<space>fp',
  projects_picker_fzf_lua,
  { desc = 'Fuzzy search projects' }
)

return M
