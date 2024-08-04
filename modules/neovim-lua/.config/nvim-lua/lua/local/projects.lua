-- TODO:
-- 3. re-run the refresh_clone_urls script after completion
-- 4. extract to plugin

local M = {}

local utils = require('utils')
local CLONE_URLS_PATH = os.getenv('DOTFILES_CLONE_URLS_PATH') or '~/.clone_urls'

local ICONS = {
  DIR = '',
  GITHUB = '',
}

local iconify = function(item, icon)
  return ('%s  %s'):format(icon, item)
end

local uniconify = function(line)
  return line:match('^[^ ]+%s+(.+)')
end

M.find_project_dirs = function(max_depth)
  max_depth = max_depth or 2
  local search_root_paths = { os.getenv('HOME') .. '/code' }
  local patterns = { '.git', 'Gemfile', 'package.json' }
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

  return utils.table.uniq(project_dirs)
end

M.find_project_dirs_decorated = function(max_depth)
  local entries = M.find_project_dirs(max_depth)
  local ansi_codes = require('fzf-lua.utils').ansi_codes
  local dir_icon = ansi_codes['blue'](ICONS.DIR)

  for i, path in ipairs(entries) do
    path = require('fzf-lua.path').relative_to(path, vim.fn.expand('$HOME'))
    path = '~/' .. path
    entries[i] = iconify(path, dir_icon)
  end

  return entries
end

M.find_clone_urls = function()
  return vim.fn.readfile(CLONE_URLS_PATH)
end

M.find_clone_urls_decorated = function()
  local entries = M.find_clone_urls()
  local ansi_codes = require('fzf-lua.utils').ansi_codes
  local github_icon = ansi_codes['yellow'](ICONS.GITHUB)

  for i, clone_url in ipairs(entries) do
    local full_reponame = clone_url:match('git@github.com:(.+)%.git')
    local owner, repo = full_reponame:match('([%w-_]+)/([%w-_%.]+)')
    entries[i] = iconify(owner .. '/' .. repo, github_icon)
  end

  return entries
end

vim.keymap.set(
  'n',
  '<space>fP',
  M.find_clone_urls_decorated,
  { desc = 'testing' }
)

local function fzf_lua_projects()
  local project_dirs = M.find_project_dirs_decorated()
  local clone_urls = M.find_clone_urls_decorated()

  coroutine.wrap(function()
    local co = coroutine.running()

    local fzf_fn = function(fzf_cb)
      local ids = {}

      local function add_entry(value, id)
        if ids[id] ~= nil then
          return
        end

        fzf_cb(value)
        ids[id] = true
      end

      -- Add local projects
      for _, value in ipairs(project_dirs) do
        local id = value:match('code/([%w-_%.]+/[%w-_%.].+)')
        assert(id, string.format('could not extract repo id from entry %s', value))
        add_entry(value, id)
      end

      -- Add any uncloned GitHub projects
      for _, value in ipairs(clone_urls) do
        local id = uniconify(value)
        assert(id, 'could not extract id from github repo line', id)

        -- Only add the value if it's not already cloned
        if ids[id] == nil then
          add_entry(value, id)
        end
      end

      fzf_cb()
    end

    local opts = {
      fzf_opts = {
        ['--no-multi'] = '',
        ['--prompt'] = 'Projects❯ ',
        ['--preview-window'] = 'hidden:right:0',
      },
    }

    local selected = require('fzf-lua.core').fzf(fzf_fn, opts)
    if selected == nil or #selected == 0 or selected[1] == 'esc' then
      return
    end

    -- Extract the "value" (no icon) from the selected line
    local line = selected[2]
    local value = uniconify(line)

    -- Open existing local project
    if string.find(line, ICONS.DIR) then
      M.open_project(vim.fn.expand(value))
      return
    end

    -- Clone project and then open it
    if string.find(line, ICONS.GITHUB) then
      local owner, repo = value:match('([%w-_]+)/([%w-_%.]+)')
      if not owner or not repo then
        return
      end

      local owner_path = vim.fn.expand('~/code/' .. owner)
      if vim.fn.empty(vim.fn.glob(owner_path)) > 0 then
        vim.fn.mkdir(owner_path, 'p')
      end

      local path = vim.fn.expand('~/code/' .. owner .. '/' .. repo)
      if vim.fn.empty(vim.fn.glob(path)) then
        local clone_url = 'git@github.com:' .. owner .. '/' .. repo .. '.git'
        vim.fn.system('git clone ' .. clone_url .. ' ' .. path)
      end

      M.open_project(path)
    end
  end)()
end

vim.keymap.set(
  'n',
  '<space>fp',
  fzf_lua_projects,
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
