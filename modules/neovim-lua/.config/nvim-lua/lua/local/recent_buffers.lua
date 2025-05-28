local M = {}

-- Cache file location
local cache_file = vim.fn.stdpath('cache') .. '/recent_buffers.json'

-- Data structure: { global = {...}, projects = { [cwd] = {...} } }
local data = { global = {}, projects = {} }

-- Private function to add entry to list with limit
local function add_to_list(list, entry, limit)
  -- Remove existing entry with same path if exists
  for i, item in ipairs(list) do
    if item.path == entry.path then
      table.remove(list, i)
      break
    end
  end

  -- Add to front
  table.insert(list, 1, entry)

  -- Trim to limit
  while #list > limit do
    table.remove(list)
  end
end

-- Private function to save data
local function save_data()
  -- Ensure cache directory exists
  local cache_dir = vim.fn.stdpath('cache')
  if vim.fn.isdirectory(cache_dir) == 0 then
    vim.fn.mkdir(cache_dir, 'p')
  end

  local ok, json = pcall(vim.json.encode, data)
  if not ok then
    vim.notify('Failed to encode recent buffers data', vim.log.levels.WARN)
    return
  end

  local ok_write = pcall(vim.fn.writefile, { json }, cache_file)
  if not ok_write then
    vim.notify('Failed to save recent buffers cache', vim.log.levels.WARN)
  end
end

-- Private function to load data
local function load_data()
  local ok, content = pcall(vim.fn.readfile, cache_file)
  if not ok then
    -- File doesn't exist yet, that's fine
    return
  end

  if #content == 0 then
    return
  end

  local ok_parse, parsed = pcall(vim.json.decode, table.concat(content, '\n'))
  if not ok_parse then
    vim.notify('Failed to parse recent buffers cache, starting fresh', vim.log.levels.WARN)
    return
  end

  -- Validate the structure
  if type(parsed) == 'table' and type(parsed.global) == 'table' and type(parsed.projects) == 'table' then
    data = parsed
  else
    vim.notify('Invalid recent buffers cache format, starting fresh', vim.log.levels.WARN)
  end
end

-- Private function to track buffer
local function track_buffer(bufnr)
  -- Skip invalid buffers
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end

  local name = vim.api.nvim_buf_get_name(bufnr)
  -- Skip unnamed buffers
  if name == '' then
    return
  end

  -- Skip special buffers like quickfix, help, etc. if they don't have a real file
  -- But since the requirement is to include all buffer types, we'll track them all

  local cwd = vim.fn.getcwd()
  local entry = {
    path = name,
    timestamp = os.time()
  }

  -- Initialize project list if needed
  data.projects[cwd] = data.projects[cwd] or {}

  -- Update project-specific list
  add_to_list(data.projects[cwd], entry, 10)

  -- Update global list
  add_to_list(data.global, entry, 10)

  -- Save to disk
  save_data()
end

-- Private function to show recent buffers with fzf
local function show_recent_buffers(project_only)
  local fzf = require('fzf-lua')
  local buffers = project_only and M.get_project_buffers() or M.get_global_buffers()

  -- Check if we have any buffers to show
  if #buffers == 0 then
    vim.notify('No recent buffers found', vim.log.levels.INFO)
    return
  end

  fzf.fzf_exec(function(fzf_cb)
    for _, buf in ipairs(buffers) do
      -- Format: "filename.ext ~/path/to/file"
      local filename = vim.fn.fnamemodify(buf.path, ':t')
      local filepath = vim.fn.fnamemodify(buf.path, ':~')
      local display = filename .. ' ' .. filepath
      fzf_cb(display)
    end
    fzf_cb() -- EOF
  end, {
    prompt = project_only and 'Recent Buffers (Project)> ' or 'Recent Buffers (Global)> ',
    winopts = {
      relative = 'cursor',
      row = 1,
      col = 0,
      height = 0.4,
      width = 0.6,
      preview = { hidden = 'hidden' },
    },
    actions = {
      ['default'] = function(selected)
        if not selected or #selected == 0 then return end
        -- Extract path from "filename.ext ~/path/to/file" format
        local path = selected[1]:match('%S+%s+(.+)$')
        if path then
          -- Expand ~ to home directory
          path = vim.fn.expand(path)
          vim.cmd('edit ' .. vim.fn.fnameescape(path))
        end
      end,
      ['ctrl-s'] = function(selected)
        if not selected or #selected == 0 then return end
        local path = selected[1]:match('%S+%s+(.+)$')
        if path then
          path = vim.fn.expand(path)
          vim.cmd('split ' .. vim.fn.fnameescape(path))
        end
      end,
      ['ctrl-v'] = function(selected)
        if not selected or #selected == 0 then return end
        local path = selected[1]:match('%S+%s+(.+)$')
        if path then
          path = vim.fn.expand(path)
          vim.cmd('vsplit ' .. vim.fn.fnameescape(path))
        end
      end,
      ['ctrl-t'] = function(selected)
        if not selected or #selected == 0 then return end
        local path = selected[1]:match('%S+%s+(.+)$')
        if path then
          path = vim.fn.expand(path)
          vim.cmd('tabedit ' .. vim.fn.fnameescape(path))
        end
      end,
    }
  })
end

-- Public function to get project buffers
function M.get_project_buffers()
  local cwd = vim.fn.getcwd()
  return data.projects[cwd] or {}
end

-- Public function to get global buffers
function M.get_global_buffers()
  return data.global or {}
end

-- Public function to show project recent buffers
function M.show_project_buffers()
  show_recent_buffers(true)
end

-- Public function to show global recent buffers
function M.show_global_buffers()
  show_recent_buffers(false)
end

-- Initialize: Load data and set up autocmd
load_data()

vim.api.nvim_create_autocmd('BufEnter', {
  group = vim.api.nvim_create_augroup('RecentBuffers', { clear = true }),
  callback = function(args)
    -- Use vim.schedule to avoid issues in autocmd context
    vim.schedule(function()
      track_buffer(args.buf)
    end)
  end,
  desc = 'Track recently visited buffers'
})

-- Set up keymaps
vim.keymap.set('n', '<space>frb', M.show_project_buffers, { desc = 'Fuzzy search recent buffers (project)' })
vim.keymap.set('n', '<space>frB', M.show_global_buffers, { desc = 'Fuzzy search recent buffers (global)' })

return M
