vim.g.mapleader = ' '

-- Saving
vim.keymap.set('n', '<space>q', '<cmd>quit!<cr>', { desc = 'Quit' })
vim.keymap.set(
  'n',
  '<space>wa',
  '<cmd>silent! wall<cr><cmd>set nohlsearch<cr>',
  { desc = 'Write all', silent = true }
)

-- Quit
vim.keymap.set(
  'n',
  '<space>sq',
  '<cmd>qall!<cr>',
  { desc = 'Write all', silent = true }
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
vim.keymap.set(
  'n',
  '<space>sl',
  '<cmd>set nohlsearch<cr>',
  { desc = 'Set No Search Highlight' }
)

-- Window Movements
vim.keymap.set('n', '<c-h>', '<c-w>h', { desc = 'Move to Left Window' })
vim.keymap.set('n', '<c-j>', '<c-w>j', { desc = 'Move to Lower Window' })
vim.keymap.set('n', '<c-k>', '<c-w>k', { desc = 'Move to Upper Window' })
vim.keymap.set('n', '<c-l>', '<c-w>l', { desc = 'Move to Right Window' })

-- Marks
-- vim.keymap.set('n', '\'', '`', { desc = 'Jump to mark' })
-- vim.keymap.set('n', '`', '\'', { desc = 'Jump to beginning of line of mark' })

-- Last buffer
vim.keymap.set('n', '<space>l', '<c-^>', { desc = 'Jump to last Buffer' })

-- Move to env of selection after yanking in visual mode
vim.keymap.set('v', 'y', '')

-- Normal Mode
vim.keymap.set('n', '<c-s>', '<esc>', { desc = 'Normal mode' })
vim.keymap.set('i', '<c-s>', '<esc>', { desc = 'Normal mode' })
vim.keymap.set('t', '<c-s>', '<c-\\><c-n>', { desc = 'Normal mode' })

-- Switch to tab by index
vim.keymap.set('n', '<space>1', '1gt', { desc = 'switch to tab 1' })
vim.keymap.set('n', '<space>2', '2gt', { desc = 'switch to tab 2' })
vim.keymap.set('n', '<space>3', '3gt', { desc = 'switch to tab 3' })
vim.keymap.set('n', '<space>4', '4gt', { desc = 'switch to tab 4' })
vim.keymap.set('n', '<space>5', '5gt', { desc = 'switch to tab 5' })
vim.keymap.set('n', '<space>6', '6gt', { desc = 'switch to tab 6' })
vim.keymap.set('n', '<space>7', '7gt', { desc = 'switch to tab 7' })
vim.keymap.set('n', '<space>8', '8gt', { desc = 'switch to tab 8' })
vim.keymap.set('n', '<space>9', '9gt', { desc = 'switch to tab 9' })

-- Utility Keymaps

-- Yank-based utils
local utils = require('utils')
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

vim.keymap.set('n', '<space>yb', function()
  vim.fn.setreg('+', utils.getCurrentFileAbsolutePath())
end, { desc = 'Yank buffer contents' })

-- Eval
vim.keymap.set('x', '<space>e', function()
  -- :{range}lua
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes(':lua<cr>', true, false, true),
    'm',
    false
  )
end, { desc = 'Evaluate visual selection as neovim lua' })
