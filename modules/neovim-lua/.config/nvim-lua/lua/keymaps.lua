local utils = require('utils')

vim.g.mapleader = ' '

-- Saving
-- vim.keymap.set(
--   'n',
--   '<space>wa',
--   '<cmd>silent! wall<cr>',
--   { desc = 'Write all', silent = true }
-- )

-- Write all modified buffers
-- using ":wa" can be unintended when running an llm agent that slowly modifies a file.
-- I may end up accidentally overwriting changes made by the agent if the buffer is open
-- and I haven't reloaded the buffer by then.
vim.keymap.set('n', '<space>wa', function()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
      vim.api.nvim_buf_call(buf, function()
        if vim.bo.modified and vim.bo.modifiable and vim.fn.bufname() ~= '' then
          vim.cmd('write')
        end
      end)
    end
  end
end, { desc = 'Write all modified buffers' })


-- Quit
vim.keymap.set('n', '<space>q', '<cmd>quit<cr>', { desc = 'Close window' })
vim.keymap.set(
  'n',
  '<space>QQ',
  '<cmd>quitall!<cr>',
  { desc = 'Quit all (no confirm)' }
)

-- Beginning / End of line (no whitespace)
vim.keymap.set(
  'n',
  'sh',
  '^',
  { desc = 'Go to first non-whitespace character' }
)
vim.keymap.set(
  'x',
  'sh',
  '^',
  { desc = 'Go to first non-whitespace character' }
)
vim.keymap.set('n', 'sl', '$', { desc = 'Go to last character on line' })
vim.keymap.set('x', 'sl', '$h', { desc = 'Go to last character on line' })

-- j/k respect line linewrap
vim.keymap.set(
  'n',
  'j',
  "v:count == 0 ? 'gj' : 'j'",
  { expr = true, silent = true }
)
vim.keymap.set(
  'n',
  'k',
  "v:count == 0 ? 'gk' : 'k'",
  { expr = true, silent = true }
)

-- Sourcing
vim.keymap.set(
  'n',
  '<space>rl',
  '<cmd>source $MYVIMRC<cr>',
  { desc = 'Reload' }
)

-- Window Movements
vim.keymap.set('n', '<c-h>', '<c-w>h', { desc = 'Move to Left Window' })
vim.keymap.set('n', '<c-j>', '<c-w>j', { desc = 'Move to Lower Window' })
vim.keymap.set('n', '<c-k>', '<c-w>k', { desc = 'Move to Upper Window' })
vim.keymap.set('n', '<c-l>', '<c-w>l', { desc = 'Move to Right Window' })

-- Marks
-- vim.keymap.set('n', '\'', '`', { desc = 'Jump to mark' })
-- vim.keymap.set('n', '`', '\'', { desc = 'Jump to beginning of line of mark' })

vim.keymap.set('n', '<esc>', function()
  -- Simulate pressing <esc>
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes('<esc>', true, false, true),
    'n',
    true
  )

  -- Close floating window
  utils.close_floating_windows()

  -- Turn off hlsearch
  vim.opt.hlsearch = false
end, { desc = 'Esc (and close windows)' })

-- Last buffer
vim.keymap.set('n', '<space>l', '<c-^>', { desc = 'Jump to last Buffer' })

-- Move to env of selection after yanking in visual mode
vim.keymap.set('v', 'y', 'ygv`]<esc>')

-- Normal Mode
vim.keymap.set('n', '<c-s>', '<esc>', { desc = 'Normal mode' })
vim.keymap.set('i', '<c-s>', '<esc>', { desc = 'Normal mode' })
vim.keymap.set('t', '<c-s>', '<c-\\><c-n>', { desc = 'Normal mode' })

-- Navigate tabs
vim.keymap.set('n', '<space>1', '1gt', { desc = 'switch to tab 1' })
vim.keymap.set('n', '<space>2', '2gt', { desc = 'switch to tab 2' })
vim.keymap.set('n', '<space>3', '3gt', { desc = 'switch to tab 3' })
vim.keymap.set('n', '<space>4', '4gt', { desc = 'switch to tab 4' })
vim.keymap.set('n', '<space>5', '5gt', { desc = 'switch to tab 5' })
vim.keymap.set('n', '<space>6', '6gt', { desc = 'switch to tab 6' })
vim.keymap.set('n', '<space>7', '7gt', { desc = 'switch to tab 7' })
vim.keymap.set('n', '<space>8', '8gt', { desc = 'switch to tab 8' })
vim.keymap.set('n', '<space>9', '9gt', { desc = 'switch to tab 9' })

vim.keymap.set('n', '<c-n>', ':tabnext<cr>', { desc = 'Go to next tab' })
vim.keymap.set('n', '<c-p>', ':tabprevious<cr>', { desc = 'Go to next tab' })
vim.keymap.set('n', '<space>tc', ':tabclose<cr>', { desc = 'Close tab' })

-- vim.keymap.set('n', '<space>tq', '<cmd>tabedit %<cr>', { desc = 'Open buffer in new tab' })
vim.keymap.set('n', '<space>t%', function()
  vim.cmd('tabedit %')

  local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
  local filename = vim.fn.fnamemodify(vim.fn.expand('%'), ':t')
  local tab_name = string.format('%s (%s)', project_name, filename)
  vim.cmd('TabooRename ' .. tab_name)
end, { desc = 'Open buffer in new tab' })

-- Open visual selection in external app
vim.keymap.set('v', '<space>oo', function()
  -- TODO: support wsl
  local program = 'open'

  vim.system({ program, utils.getVisualSelectionContents() }):wait()
end, { desc = 'Open in external app' })

-- Quickfix movements
vim.keymap.set('n', ']q', ':cnext<cr>', { desc = 'Go to next quickfix entry' })
vim.keymap.set(
  'n',
  '[q',
  ':cprevious<cr>',
  { desc = 'Go to previous quickfix entry' }
)
vim.keymap.set(
  'n',
  ']Q',
  ':clast<cr>',
  { desc = 'Go to the last quickfix entry' }
)
vim.keymap.set(
  'n',
  '[Q',
  ':cfirst<cr>',
  { desc = 'Go to the first quickfix entry' }
)

vim.keymap.set('n', '<space>gqq', function()
  local quickfix_is_open = false
  local current_tabnr = vim.api.nvim_tabpage_get_number(0)
  local current_winnr = vim.api.nvim_win_get_number(0)

  for _, win in ipairs(vim.fn.getwininfo()) do
    if win.tabnr == current_tabnr and win.quickfix == 1 then
      quickfix_is_open = true
      break
    end
  end

  if quickfix_is_open then
    vim.cmd('cclose')
  else
    vim.cmd('copen')
  end

  vim.cmd(current_winnr .. 'wincmd w')
end, { desc = 'Toggle quickfix terminal' })

-- Paste from specified register in terminal mode
vim.keymap.set('t', '<C-x><C-r>', function()
  local register = vim.fn.nr2char(vim.fn.getchar())
  return '<C-\\><C-N>"' .. register .. 'pi'
end, { expr = true, desc = 'Paste from register' })

-- Copy this binding to normal/insert mode in case muscle memory takes over
vim.api.nvim_set_keymap(
  'i',
  '<C-\\><C-r>',
  '<C-r>',
  { noremap = true, desc = 'Paste from register' }
)
vim.api.nvim_set_keymap(
  'c',
  '<C-\\><C-r>',
  '<C-r>',
  { noremap = true, desc = 'Paste from register' }
)

-- Rename buffer
vim.keymap.set('n', '<space>reb', function()
  if string.match(vim.fn.bufname(), '[term]') then
    local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
    vim.fn.feedkeys(':keepalt file [term] (' .. project_name .. ') ')
  else
    vim.fn.feedkeys(':keepalt file ')
  end
end, { desc = 'Rename buffer' })

-- Utility Keymaps

-- Yank-based utils
vim.keymap.set('x', '<space>yv', function()
  vim.fn.setreg('+', utils.getVisualSelectionContents())

  -- Exit visual mode
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes('<esc>', true, false, true),
    'm',
    true
  )
end, { desc = 'Yank visual selection' })

vim.keymap.set('n', '<space>yfr', function()
  vim.fn.setreg('+', utils.getCurrentFileRelativePath())
end, { desc = 'Yank file (relative to cwd)' })

vim.keymap.set('n', '<space>yfa', function()
  vim.fn.setreg('+', utils.getCurrentFileAbsolutePath())
end, { desc = 'Yank file (absolute path)' })

vim.keymap.set('n', '<space>YY', function()
  vim.fn.setreg('+', utils.getCurrentBufferContents())
end, { desc = 'Yank file content' })

-- Eval
vim.keymap.set('x', '<space>e', function()
  local s = utils.getVisualSelectionContents()
  local result = assert(loadstring(s))()

  result = result
    or "loadstring() result was nil\n(does it end with a 'return' statement?)"

  local n = require('notify')
  n.notify(vim.inspect(result), vim.log.levels.INFO, { render = 'minimal' })
end, { desc = 'Evaluate visual selection as neovim lua' })
