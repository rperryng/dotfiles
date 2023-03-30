-- Saving
vim.keymap.set('n', '<space>q', '<cmd>quit!<cr>', { desc = '[q] Quit' })
vim.keymap.set('n', '<space>wa', '<cmd>wall<cr><cmd>set nohlsearch<cr>', { desc = '[wa] Write all' })

-- Sourcing
vim.keymap.set('n', '<space>rl', '<cmd>source $MYVIMRC<cr>', { desc = '[rl] Reload' })
vim.keymap.set('n', '<space>sl', '<cmd>set nohlsearch<cr>', { desc = '[sl] Set No Search Highlight' })

-- Window Movements
vim.keymap.set('n', '<c-h>', '<c-w>h', { desc = 'Move to Left Window' })
vim.keymap.set('n', '<c-j>', '<c-w>j', { desc = 'Move to Lower Window' })
vim.keymap.set('n', '<c-k>', '<c-w>k', { desc = 'Move to Upper Window' })
vim.keymap.set('n', '<c-l>', '<c-w>l', { desc = 'Move to Right Window' })

-- Marks
vim.keymap.set('n', '\'', '`', { desc = 'Jump to mark' })
vim.keymap.set('n', '`', '\'', { desc = 'Jump to beginning of line of mark' })

-- Tabs
vim.keymap.set('n', '`', '\'', { desc = 'Jump to beginning of line of mark' })

-- Last buffer
vim.keymap.set('n', '<space>l', '<c-^>', { desc = 'Jump to last Buffer' })

-- Normal Mode
vim.keymap.set('n', '<c-s>', '<esc>', { desc = 'Normal mode' })
vim.keymap.set('i', '<c-s>', '<esc>', { desc = 'Normal mode' })
vim.keymap.set('t', '<c-s>', '<c-\\><c-n>', { desc = 'Normal mode' })
