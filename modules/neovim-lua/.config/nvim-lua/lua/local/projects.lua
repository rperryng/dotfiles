-- TODO:
-- 4. extract to plugin

local M = {}

local fzf_utils = require('fzf-lua.utils')
local utils = require('utils')
local DOTFILES_DIR = os.getenv('DOTFILES_DIR')
local CLONE_URLS_PATH = os.getenv('DOTFILES_CLONE_URLS_PATH') or '~/.clone_urls'
local ICONS = {
  DIR = '',
  GITHUB = '',
  GIT_WORKTREE = '',
}

local PROJECT_ROOT_FILES =
  { '.git', 'Gemfile', 'package.json', 'deno.json', 'deno.jsonc' }

M.get_project_name = function(opts)
  opts = opts or {}
  local project_dir = opts.project_dir or vim.fn.getcwd()

  -- If worktree dir, return <repo>/<branch>
  do
    local _, repo, branch =
      project_dir:match('code%-worktrees/([%w%.%-_]+)/([%w%.%-_]+)/([%w%.%-_]+)')
    if branch ~= nil then
      return string.format('%s/%s', repo, branch)
    end
  end

  -- If main-repo dir, return '<org>/<repo>'
  do
    local org, repo = project_dir:match('code/([%w%.%-_]+)/([%w%.%-_]+)')
    if org ~= nil then
      return string.format('%s/%s', org, repo)
    end
  end

  -- otherwise, simply return working directory name
  return vim.fn.fnamemodify(project_dir, ':t')
end

local search = function(opts)
  local search_root_path = opts.root_path
  local max_depth = opts.max_depth
  local patterns = opts.patterns

  local project_dirs = {}
  for depth = 1, max_depth do
    local search_path = search_root_path .. string.rep('/*', depth)
    for _, pattern in ipairs(patterns) do
      local dirs = vim.fn.globpath(search_path, pattern, true, true)

      for _, dir in ipairs(dirs) do
        table.insert(project_dirs, vim.fn.fnamemodify(dir, ':h'))
      end
    end
  end

  return utils.table.uniq(project_dirs)
end

M.find_project_dirs = function()
  local project_dirs = search({
    root_path = os.getenv('HOME') .. '/code',
    max_depth = 2,
    patterns = PROJECT_ROOT_FILES,
  })

  if DOTFILES_DIR and vim.fn.isdirectory(DOTFILES_DIR) == 1 then
    table.insert(project_dirs, DOTFILES_DIR)
  end

  return project_dirs
end

M.find_project_dirs_decorated = function()
  local entries = M.find_project_dirs()
  local dir_icon = fzf_utils.ansi_codes.blue(ICONS.DIR)

  for i, path in ipairs(entries) do
    path = require('fzf-lua.path').relative_to(path, vim.fn.expand('$HOME'))
    path = '~/' .. path
    entries[i] = utils.iconify(path, dir_icon)
  end

  return entries
end

M.find_worktrees_dirs = function()
  return search({
    root_path = os.getenv('HOME') .. '/code-worktrees',
    max_depth = 3,
    patterns = PROJECT_ROOT_FILES,
  })
end

M.find_worktrees_dirs_decorated = function()
  local entries = M.find_worktrees_dirs()
  local ansi_codes = require('fzf-lua.utils').ansi_codes
  local dir_icon = ansi_codes['green'](ICONS.GIT_WORKTREE)

  for i, path in ipairs(entries) do
    path = require('fzf-lua.path').relative_to(path, vim.fn.expand('$HOME'))
    path = '~/' .. path
    entries[i] = utils.iconify(path, dir_icon)
  end

  return entries
end

M.find_clone_urls = function()
  if vim.uv.fs_stat(CLONE_URLS_PATH) then
    return vim.fn.readfile(CLONE_URLS_PATH)
  else
    return {}
  end
end

M.find_clone_urls_decorated = function()
  local entries = M.find_clone_urls()
  local github_icon = fzf_utils.ansi_codes.yellow(ICONS.GITHUB)

  for i, clone_url in ipairs(entries) do
    local full_reponame = clone_url:match('git@github.com:(.+)%.git')
    local owner, repo = full_reponame:match('([%w%-_]+)/([%w%-_%.]+)')
    entries[i] = utils.iconify(owner .. '/' .. repo, github_icon)
  end

  return entries
end

vim.keymap.set(
  'n',
  '<space>fP',
  M.find_clone_urls_decorated,
  { desc = 'testing' }
)

local function refresh_clone_urls()
  local octokit = require('local.octokit')
  octokit.fidget('/user/repos', function(result)
    if not result.done then
      return
    end

    local clone_urls = {}
    for _, v in ipairs(result.data) do
      if not v.archived then
        table.insert(clone_urls, v.ssh_url)
      end
    end

    vim.fn.writefile(clone_urls, CLONE_URLS_PATH)
  end)
end
vim.keymap.set('n', '<space>rec', function()
  refresh_clone_urls()
end, { desc = 'refresh_clone_urls' })

local function job_clone_repo(clone_url, reponame, path)
  local progress = require('fidget.progress')
  local progress_handler = progress.handle.create({
    title = reponame,
    message = string.format('Cloning repo'),
    lsp_client = { name = 'Git' },
  })

  vim.system({ 'mkdir', '-p', 'path' }):wait()

  -- local fidget = require('fidget')
  local Job = require('plenary.job')

  ---@diagnostic disable-next-line: missing-fields
  Job:new({
    command = 'git',
    args = { 'clone', clone_url, path },
    on_exit = function(j, return_val)
      if return_val ~= 0 then
        local result = table.concat(j:result(), '\n')
        local msg = string.format('Error cloning %s\n%s', reponame, result)
        progress_handler.message = msg
        return
      end

      progress_handler.message = string.format('Done cloning %s. Initializing jj', reponame)

      Job:new({
        command = 'jj',
        args = { 'git', 'init', '--colocate' },
        cwd = path,
        on_exit = function(j, return_val)

          if return_val ~= 0 then
            local result = table.concat(j:result(), '\n')
            local msg = string.format('Error initializing jj for %s\n%s', reponame, result)
            progress_handler.message = msg
            return
          end

          progress_handler:finish()

          vim.schedule(function()
            M.open_project(path)
          end)
        end
      }):start()
    end,
  }):start()
end

local function fzf_lua_projects()
  local worktree_dirs = M.find_worktrees_dirs_decorated()
  local project_dirs = M.find_project_dirs_decorated()
  local clone_urls = M.find_clone_urls_decorated()

  coroutine.wrap(function()
    local fzf_fn = function(fzf_cb)
      local ids = {}

      local function add_entry(value, id)
        if ids[id] ~= nil then
          return
        end

        fzf_cb(value)
        ids[id] = true
      end

      -- Add worktrees
      for _, value in ipairs(worktree_dirs) do
        -- match ~/code-worktrees/{owner}/{repo}/{branch}
        local id =
          value:match('code%-worktrees/([%w%-_%.]+/[%w%-_%.]+/[%w%-_%.]+)')

        assert(
          id,
          string.format(
            'could not extract repo id from worktree entry %s',
            value
          )
        )
        add_entry(value, id)
      end

      -- Add local projects
      for _, value in ipairs(project_dirs) do
        local id

        -- Special case for dotfiles directory (check for .dotfiles in the path)
        print(value)
        if value:match('%~/.dotfiles') then
          id = 'rperryng/dotfiles'
        else
          -- Match ~/code/{owner}/{repo}
          id = value:match('code/([%w%-_%.]+/[%w-_%.]+)')

          -- (Legacy) Match ~/code/{repo}
          id = id or value:match('code/([%w%-_%.]+)')
        end

        assert(
          id,
          string.format('could not extract repo id from project dir %s', value)
        )
        add_entry(value, id)
      end

      -- Add any uncloned GitHub projects
      for _, value in ipairs(clone_urls) do
        local id = utils.uniconify(value)
        assert(id, 'could not extract id from github repo line', id)

        -- Only add the value if it's not already cloned
        -- TODO: this is handled by 'add_entry' anyway?
        if ids[id] == nil then
          add_entry(value, id)
        end
      end

      fzf_cb()
    end

    require('fzf-lua').fzf_exec(fzf_fn, {
      fzf_opts = {
        ['--tiebreak'] = 'end',
        ['--no-multi'] = '',
        ['--prompt'] = 'Projects❯ ',
        ['--preview-window'] = 'hidden:right:0',
      },
      actions = {
        ['default'] = function(selected, opts)
          if selected == nil or #selected == 0 then
            return
          end

          -- Extract the "value" (no icon) from the selected line
          local line = selected[1]
          local value = utils.uniconify(line)

          -- Open existing worktree dir
          if string.find(line, ICONS.GIT_WORKTREE) then
            local repo, branch = value:match(
              'code%-worktrees/[%w%.%-_]+/([%w%.%-_]+)/([%w%.%-_]+)'
            )
            M.open_project(value, {
              tab_name = repo .. '/' .. branch,
            })
            return
          end

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

            local full_reponame = string.format('%s/%s', owner, repo)

            local path = vim.fn.expand('~/code/' .. full_reponame)
            if vim.fn.empty(vim.fn.glob(path)) then
              local clone_url = 'git@github.com:' .. full_reponame .. '.git'
              job_clone_repo(clone_url, full_reponame, path)
            end
          end
        end,
      },
    })
  end)()
end

-- Change the working directory to a path inside the current working directory
local function inner_working_directory_picker() end

vim.keymap.set('n', '<space>cdi', function()
  require('fzf-lua').fzf_exec('fd --hidden --type d', {
    prompt = 'Directory❯ ',
    cwd = vim.fn.getcwd(),
    actions = {
      ['default'] = function(selected, _opts)
        if selected == nil or #selected == 0 then
          return
        end
        local dir = selected[1]
        if dir:find('/$') then
          dir = dir:match('(.+)/$')
        end

        local tab_name = vim.fn.fnamemodify(dir, ':t')
        vim.cmd('tchdir ' .. vim.fn.getcwd() .. '/' .. dir)
        vim.cmd('TabooRename ' .. tab_name)
      end,
      ['ctrl-t'] = function(selected, _opts)
        if selected == nil or #selected == 0 then
          return
        end
        local dir = selected[1]
        if dir:find('/$') then
          dir = dir:match('(.+)/$')
        end

        local tab_name = vim.fn.fnamemodify(dir, ':t')
        M.open_project(dir, tab_name)
      end,
    },
  })
end, { desc = 'Fuzzy search working directory' })

vim.keymap.set('n', '<space>cdp', function()
  local rev_parse = vim.system({ 'git', 'rev-parse', '--show-toplevel' }):wait()
  assert(rev_parse.code == 0)
  local dir = rev_parse.stdout
  assert(dir ~= nil)

  local tab_name = vim.fn.fnamemodify(dir, ':t')
  vim.cmd('tchdir ' .. dir)
  vim.cmd('TabooRename ' .. tab_name)
end, { desc = 'Change working directory to git root' })

vim.keymap.set('n', '<space>cdP', function()
  local starting_dir = vim.fn.fnamemodify(vim.fn.expand('%'), ':p:h')
  local project_root = nil

  -- Start searching from the starting directory
  local dir = starting_dir

  while dir ~= '/' do
    for _, file in ipairs(PROJECT_ROOT_FILES) do
      Log('checking for: ' .. dir .. '/' .. file)
      if vim.fn.glob(dir .. '/' .. file) ~= '' then
        Log('found root: ' .. dir)
        project_root = dir
        break
      end
    end
    if project_root then
      Log('found root, aborting' .. project_root)
      break
    end
    dir = vim.fn.fnamemodify(dir, ':h')
  end

  if not project_root then
    error('Could not determine a project root from ' .. starting_dir)
  end

  local tab_name = vim.fn.fnamemodify(dir, ':t')
  vim.cmd('tchdir ' .. dir)
  vim.cmd('TabooRename ' .. tab_name)
end, { desc = 'Change working directory to "project" root' })

vim.keymap.set(
  'n',
  '<space>fp',
  fzf_lua_projects,
  { desc = 'Fuzzy search projects' }
)

M.open_project = function(project_dir, opts)
  opts = opts or {}
  local project_name = M.get_project_name({project_dir = project_dir})
  local tab_name = opts.tab_name or project_name

  -- If an existing tab already uses this working directory, switch to it.
  local current_tabnr = vim.fn.tabpagenr()
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
  vim.cmd('TabooRename ' .. tab_name)
end

return M
