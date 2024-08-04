-- TODO:
-- 1. read from clone_urls path
-- 2. clone the repo if it doesn't exist yet
-- 3. re-run the refresh_clone_urls script after completion
-- 4. extract to plugin

local M = {}

local utils = require('utils')
local CLONE_URLS_PATH = os.getenv('HOME') .. '/.clone_urls'

M.find_project_dirs = function(max_depth)
  max_depth = max_depth or 2
  local search_root_paths = { os.getenv('HOME') .. '/code' }
  local patterns = { '.git', 'Gemfile' }
  local project_dirs = {}

  for _, search_root_path in ipairs(search_root_paths) do
    for depth = 1, max_depth do
      local search_path = search_root_path .. string.rep('/*', depth)
      for _, pattern in ipairs(patterns) do
        local dirs = vim.fn.globpath(search_path, pattern, true, true)
        for _, dir in ipairs(dirs) do
          table.insert(project_dirs, vim.fn.fnamemodify(dir, ':h'))
        end
      end
    end
  end

  vim.print(project_dirs)
  vim.print(utils.table)
  return utils.table.uniq(project_dirs)
end

local find_project_dirs_decorated = function(max_depth)
  local entries = M.find_project_dirs(max_depth)

  local ansi_codes = require('fzf-lua.utils').ansi_codes
  local dir_icon = ansi_codes['blue']('')
  local iconify = function(item, icon)
    icon = icon or dir_icon
    return ('%s  %s'):format(icon, item)
  end

  coroutine.wrap(function()
    -- prepend dirs with folder icon
    for i, path in ipairs(entries) do
      path = require('fzf-lua.path').relative_to(
        path,
        vim.fn.expand('$HOME')
      )
      entries[i] = iconify(path)
    end

    local fzf_fn = function(cb)
      for _, entry in ipairs(entries) do
        cb(entry, function(err)
          if err then
            return
          end
          cb(nil, function() end)
        end)
      end
    end
    local opts = {
      fzf_opts = {
        ['--no-multi'] = '',
        ['--prompt'] = 'Workdirs❯ ',
        ['--preview-window'] = 'hidden:right:0',
      }
    }
    local selected = require('fzf-lua.core').fzf(fzf_fn, opts)
    if not selected then
      return
    end
    local pwd = require('fzf-lua.path').join({
      vim.fn.expand('$HOME'),
      selected[2]:match('[^ ]*$'),
    })

    if not pwd then
      return
    end

    M.open_project(pwd)
  end)()
end

vim.keymap.set(
  'n',
  '<space>fp',
  find_project_dirs_decorated,
  { desc = 'Fuzzy search projects' }
)

M.open_project = function(project_dir)
  local project_name = vim.fn.fnamemodify(project_dir, ':t')
  local current_tabnr = vim.fn.tabpagenr()

  -- If an existing tab already uses this working directory, switch to it.
  for tabnr = 1, vim.fn.tabpagenr('$') do
    vim.cmd(tabnr .. 'tabnext')
    local tcd = vim.fn.getcwd()
    if tcd == project_dir then
      vim.cmd(current_tabnr .. 'tabnext')
      vim.cmd(tabnr .. 'tabnext')
      return
    end
  end

  -- Otherwise, create a new one with that working directory.
  vim.cmd(current_tabnr .. 'tabnext')
  vim.cmd('tabnew')
  vim.cmd('tchdir ' .. project_dir)
  vim.cmd('TabooRename ' .. project_name)
end

return M
