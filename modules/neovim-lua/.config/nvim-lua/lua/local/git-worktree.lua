local M = {}

local WORKTREES_DIR = os.getenv('HOME') .. '/code-worktrees'
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

local existing_worktrees = function()
  local output = vim
    .system({ 'git', 'worktree', 'list', '--porcelain' }, { text = true })
    :wait().stdout
  assert(output ~= nil, 'Failed to run "git worktree list"')

  local worktrees = {}
  local entries = vim.split(output, '\n\n', { trimempty = true })
  for _, entry in ipairs(entries) do
    entry = entry .. '\n'
    local worktree_path = entry:match('worktree ([%w%.-_/]+)\n')
    local head = entry:match('HEAD ([%w]+)\n')
    local branch = entry:match('branch refs/heads/([%w-_]+)\n')

    table.insert(worktrees, {
      worktree_path = worktree_path,
      head = head,
      branch = branch or 'detached',
    })
  end

  return worktrees
end

M.find_existing_working_dirs_decorated = function()
  local entries = existing_worktrees()
  local ansi_codes = require('fzf-lua.utils').ansi_codes
  local dir_icon = ansi_codes['blue'](ICONS.DIR)

  for i, entry in ipairs(entries) do
    Log(entry.worktree_path)

    local name = vim.fn.fnamemodify(entry.worktree_path, ':t')
    assert(
      name,
      'failed to parse name from worktree_path: ' .. entry.worktree_path
    )
    entries[i] = iconify(name, dir_icon)
  end

  return entries
end

local function remote_refs()
  local output = vim
    .system({ 'git', 'for-each-ref', '--format=%(refname)', 'refs/remotes' })
    :wait().stdout
  assert(output)
  local lines = vim.split(output, '\n', { trimempty = true })
  local entries = {}
  for _, line in ipairs(lines) do
    local ref = line:match('refs/remotes/(.+)$')
    assert(ref, 'failed to parse ref name from ref: ' .. line)
    table.insert(entries, ref)
  end

  return entries
end

M.find_remote_refs_decorated = function()
  local entries = remote_refs()
  local ansi_codes = require('fzf-lua.utils').ansi_codes
  local dir_icon = ansi_codes['yellow'](ICONS.GITHUB)

  for i, entry in ipairs(entries) do
    entries[i] = iconify(entry, dir_icon)
  end

  return entries
end

local get_owner_repo = function()
  local output = vim
    .system({ 'git', 'config', '--get', 'remote.origin.url' }, { text = true })
    :wait().stdout
  assert(output)

  local owner, repo = output:match('github.com:([%w-_]+)/([%w-_]+)%.git')
  return owner, repo
end

local build_worktree_path = function(worktree_name)
  local owner, repo = get_owner_repo()
  return WORKTREES_DIR .. '/' .. owner .. '/' .. repo .. '/' .. worktree_name
end

M.worktrees_picker = function()
  local _existing_worktrees = existing_worktrees()
  local entries = {}

  for _, value in ipairs(M.find_existing_working_dirs_decorated()) do
    table.insert(entries, value)
  end
  for _, value in ipairs(M.find_remote_refs_decorated()) do
    local branch = value:match('[%w-_]+/(.+)$')
    local already_exists = false
    for _, v in ipairs(_existing_worktrees) do
      if v.branch == branch then
        already_exists = true
        break
      end
    end

    if not already_exists then
      table.insert(entries, value)
    end
  end

  require('fzf-lua').fzf_exec(entries, {
    fzf_opts = {
      ['--prompt'] = 'Worktrees❯ ',
    },
    actions = {
      ['default'] = function(selected, opts)
        local line = selected[1]
        local value = uniconify(line)
        local projects = require('local.projects')
        local _, repo = get_owner_repo()

        local worktree_path = nil
        if string.find(line, ICONS.GITHUB) then
          -- If git ref selected, add a new worktree to the canoncal worktree path
          local branch_name = value:match('%w+/(.+)$')
          worktree_path = build_worktree_path(branch_name)
          vim.system({
            'git',
            'worktree',
            'add',
            '-b',
            branch_name,
            worktree_path,
            value,
          })
        elseif string.find(line, ICONS.DIR) then
          worktree_path = build_worktree_path(value)
        end
        assert(
          worktree_path ~= nil,
          "Don't know how to handle worktree selection entry: " .. value
        )

        -- Now, open the worktree dir
        projects.open_project(worktree_path, {
          tab_name = repo .. '/' .. value,
        })
      end,
    },
  })
end

vim.keymap.set('n', '<space>wt', function()
  M.worktrees_picker()
end, { desc = 'Switch to worktree' })

return M
