-- Vertical tab panel: a persistent left-hand pane listing the tabpages,
-- similar to "vertical tabs" in browsers (and Vim 9.1's native :tabpanel,
-- which Neovim has not ported as of 0.12).
--
-- Implementation notes:
--   * In Neovim a window (split or float) lives in exactly ONE tabpage, so a
--     panel that appears "in every tab" has to be re-materialized per tab.
--   * We use a single shared scratch buffer displayed in a per-tab left split.
--     Rendering the buffer updates the panel in whatever tab is visible.
--   * The split is created lazily the first time a tab is entered (TabEnter),
--     so switching between tabs shows a consistent, persistent left pane.

local M = {}

local projects = require('local.projects')

local config = {
  width = 30,
  auto_open = true,
}

local AUGROUP = vim.api.nvim_create_augroup('TabPanel', { clear = true })
local NS = vim.api.nvim_create_namespace('TabPanel')

local state = {
  enabled = false,
  buf = nil,
  wins = {}, -- tabid -> winid (the panel window for that tabpage)
  line_to_tab = {}, -- panel buffer line (1-indexed) -> tab number
  saved_showtabline = nil,
}

-- ---------------------------------------------------------------------------
-- Highlights
-- ---------------------------------------------------------------------------

local function set_highlights()
  vim.api.nvim_set_hl(0, 'TabPanelSel', { link = 'TabLineSel', default = true })
  vim.api.nvim_set_hl(0, 'TabPanelNormal', { link = 'Normal', default = true })
  vim.api.nvim_set_hl(0, 'TabPanelModified', { link = 'WarningMsg', default = true })
end

-- ---------------------------------------------------------------------------
-- Helpers
-- ---------------------------------------------------------------------------

-- Display name for a tab: taboo name if set, else the project name derived
-- from the tab-local working directory, else a placeholder.
local function tab_display_name(tabnr)
  local name = vim.fn.gettabvar(tabnr, 'taboo_tab_name')
  if name ~= nil and name ~= '' then
    return name
  end

  local ok, cwd = pcall(vim.fn.getcwd, -1, tabnr)
  if ok and cwd and cwd ~= '' then
    return projects.get_project_name({ project_dir = cwd })
  end

  return 'NoName'
end

-- Does any window in the tab hold a modified buffer?
local function tab_is_modified(tabid)
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tabid)) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].modified then
      return true
    end
  end
  return false
end

-- First non-panel window in the given tab (a "content" window).
local function first_content_win(tabid)
  local panel = state.wins[tabid]
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tabid)) do
    if win ~= panel then
      return win
    end
  end
  return nil
end

-- ---------------------------------------------------------------------------
-- Buffer + window
-- ---------------------------------------------------------------------------

local function ensure_buf()
  if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
    return state.buf
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].buftype = 'nofile'
  vim.bo[buf].bufhidden = 'hide'
  vim.bo[buf].swapfile = false
  vim.bo[buf].buflisted = false
  vim.bo[buf].modifiable = false
  vim.bo[buf].filetype = 'tabpanel'
  pcall(vim.api.nvim_buf_set_name, buf, 'TabPanel')

  local opts = { buffer = buf, nowait = true, silent = true }
  vim.keymap.set('n', '<CR>', M.select_under_cursor, opts)
  vim.keymap.set('n', 'o', M.select_under_cursor, opts)
  vim.keymap.set('n', '<2-LeftMouse>', M.select_under_cursor, opts)
  vim.keymap.set('n', 'd', M.close_tab_under_cursor, opts)
  vim.keymap.set('n', 'r', M.rename_tab_under_cursor, opts)
  vim.keymap.set('n', 'q', M.close, opts)

  state.buf = buf
  return buf
end

local function setup_win_opts(win)
  local wo = vim.wo[win]
  wo.number = false
  wo.relativenumber = false
  wo.signcolumn = 'no'
  wo.foldcolumn = '0'
  wo.cursorline = true
  wo.winfixwidth = true
  wo.wrap = false
  wo.list = false
  wo.spell = false
  wo.winbar = '' -- our global winbar (lua/ui.lua) should not render here
  wo.fillchars = 'eob: ' -- hide the ~ end-of-buffer markers
  wo.winhighlight = 'Normal:TabPanelNormal,CursorLine:TabPanelSel'
end

-- Ensure a panel window exists in the current tabpage, creating it if needed.
local function ensure_win_in_current_tab()
  local tabid = vim.api.nvim_get_current_tabpage()
  local existing = state.wins[tabid]
  if existing and vim.api.nvim_win_is_valid(existing) then
    return existing
  end

  local prev_win = vim.api.nvim_get_current_win()
  local buf = ensure_buf()

  -- Full-height split pinned to the far left. noautocmd avoids recursing into
  -- our own autocmds and the winbar/filetype machinery.
  vim.cmd('noautocmd topleft vsplit')
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(win, buf)
  setup_win_opts(win)
  vim.api.nvim_win_set_width(win, config.width)
  state.wins[tabid] = win

  if vim.api.nvim_win_is_valid(prev_win) then
    vim.api.nvim_set_current_win(prev_win)
  end

  return win
end

-- ---------------------------------------------------------------------------
-- Rendering
-- ---------------------------------------------------------------------------

function M.render()
  if not (state.buf and vim.api.nvim_buf_is_valid(state.buf)) then
    return
  end

  local current_tabid = vim.api.nvim_get_current_tabpage()
  local lines = {}
  local modified_lines = {}
  state.line_to_tab = {}
  local active_line = 1

  for i, tabid in ipairs(vim.api.nvim_list_tabpages()) do
    local tabnr = vim.api.nvim_tabpage_get_number(tabid)
    local name = tab_display_name(tabnr)
    local is_active = tabid == current_tabid
    local prefix = is_active and '▍' or ' '
    local modified = tab_is_modified(tabid)
    local marker = modified and ' ●' or ''

    lines[i] = string.format('%s%d %s%s', prefix, tabnr, name, marker)
    state.line_to_tab[i] = tabnr
    if modified then
      modified_lines[i] = true
    end
    if is_active then
      active_line = i
    end
  end

  vim.bo[state.buf].modifiable = true
  vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, lines)
  vim.bo[state.buf].modifiable = false

  vim.api.nvim_buf_clear_namespace(state.buf, NS, 0, -1)
  -- Highlight the active tab line across its full width.
  vim.api.nvim_buf_set_extmark(state.buf, NS, active_line - 1, 0, {
    end_row = active_line,
    hl_group = 'TabPanelSel',
    hl_eol = true,
  })
  -- Tint modified markers.
  for line, _ in pairs(modified_lines) do
    vim.api.nvim_buf_set_extmark(state.buf, NS, line - 1, 0, {
      end_row = line - 1,
      end_col = #lines[line],
      hl_group = 'TabPanelModified',
    })
  end

  -- Keep the current tab's panel cursor on the active tab.
  local win = state.wins[current_tabid]
  if win and vim.api.nvim_win_is_valid(win) then
    pcall(vim.api.nvim_win_set_cursor, win, { active_line, 0 })
  end
end

local function schedule_render()
  if not state.enabled then
    return
  end
  vim.schedule(function()
    if state.enabled then
      M.render()
    end
  end)
end

-- ---------------------------------------------------------------------------
-- Public API
-- ---------------------------------------------------------------------------

function M.is_open()
  local tabid = vim.api.nvim_get_current_tabpage()
  local win = state.wins[tabid]
  return win ~= nil and vim.api.nvim_win_is_valid(win)
end

function M.open()
  if state.enabled and M.is_open() then
    return
  end

  if not state.enabled then
    state.saved_showtabline = vim.o.showtabline
    vim.o.showtabline = 0
    state.enabled = true
  end

  ensure_win_in_current_tab()
  M.render()
end

function M.close()
  state.enabled = false

  for tabid, win in pairs(state.wins) do
    if vim.api.nvim_win_is_valid(win) then
      pcall(vim.api.nvim_win_close, win, false)
    end
    state.wins[tabid] = nil
  end

  if state.saved_showtabline ~= nil then
    vim.o.showtabline = state.saved_showtabline
    state.saved_showtabline = nil
  end
end

function M.toggle()
  if state.enabled then
    M.close()
  else
    M.open()
  end
end

function M.select_under_cursor()
  local win = vim.api.nvim_get_current_win()
  local row = vim.api.nvim_win_get_cursor(win)[1]
  local tabnr = state.line_to_tab[row]
  if not tabnr then
    return
  end

  -- Move focus off the panel in the source tab first, so returning to it later
  -- lands on a content window rather than the panel.
  local cur_tabid = vim.api.nvim_get_current_tabpage()
  local content = first_content_win(cur_tabid)
  if content then
    vim.api.nvim_set_current_win(content)
  end

  vim.cmd(tabnr .. 'tabnext')
end

function M.close_tab_under_cursor()
  local win = vim.api.nvim_get_current_win()
  local row = vim.api.nvim_win_get_cursor(win)[1]
  local tabnr = state.line_to_tab[row]
  if not tabnr then
    return
  end

  local ok, err = pcall(vim.cmd, tabnr .. 'tabclose')
  if not ok then
    vim.notify('TabPanel: ' .. tostring(err), vim.log.levels.WARN)
    return
  end
  M.render()
end

function M.rename_tab_under_cursor()
  local win = vim.api.nvim_get_current_win()
  local row = vim.api.nvim_win_get_cursor(win)[1]
  local tabnr = state.line_to_tab[row]
  if not tabnr then
    return
  end

  M.select_under_cursor()
  local project_name = projects.get_project_name()
  vim.fn.feedkeys(':TabooRename ' .. project_name)
end

-- ---------------------------------------------------------------------------
-- Autocmds
-- ---------------------------------------------------------------------------

vim.api.nvim_create_autocmd({ 'TabEnter', 'TabNewEntered' }, {
  group = AUGROUP,
  callback = function()
    if not state.enabled then
      return
    end
    ensure_win_in_current_tab()
    M.render()
  end,
})

vim.api.nvim_create_autocmd(
  { 'TabClosed', 'TabLeave', 'BufEnter', 'BufModifiedSet', 'BufWritePost' },
  {
    group = AUGROUP,
    callback = schedule_render,
  }
)

vim.api.nvim_create_autocmd('WinClosed', {
  group = AUGROUP,
  callback = function(args)
    local closed = tonumber(args.match)

    -- Drop stale window references.
    for tabid, win in pairs(state.wins) do
      if win == closed or not vim.api.nvim_win_is_valid(win) then
        state.wins[tabid] = nil
      end
    end

    if not state.enabled then
      return
    end

    -- If the panel is the only window left in the current tab, close it too so
    -- we don't get stuck in a lone, non-editing pane.
    vim.schedule(function()
      if not state.enabled then
        return
      end
      local tabid = vim.api.nvim_get_current_tabpage()
      local wins = vim.api.nvim_tabpage_list_wins(tabid)
      local panel = state.wins[tabid]
      if panel and vim.api.nvim_win_is_valid(panel) and #wins == 1 and wins[1] == panel then
        state.wins[tabid] = nil
        pcall(vim.api.nvim_win_close, panel, false)
      end
    end)
  end,
})

vim.api.nvim_create_autocmd('ColorScheme', {
  group = AUGROUP,
  callback = set_highlights,
})

-- ---------------------------------------------------------------------------
-- Commands, keymaps, init
-- ---------------------------------------------------------------------------

vim.api.nvim_create_user_command('TabPanelToggle', M.toggle, {})
vim.api.nvim_create_user_command('TabPanelOpen', M.open, {})
vim.api.nvim_create_user_command('TabPanelClose', M.close, {})

vim.keymap.set('n', '<space>tp', M.toggle, { desc = 'Toggle vertical tab panel' })

set_highlights()

if config.auto_open then
  vim.api.nvim_create_autocmd('VimEnter', {
    group = AUGROUP,
    once = true,
    callback = function()
      vim.schedule(M.open)
    end,
  })
end

return M
