local M = {}

-- TODO
-- local function toggleTerminal()
--   local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
--   local current_buf_name = vim.fn.bufname()
--   local terminal_buf_name = 'term-' .. project_name
--
--   vim.cmd('wincmd b')
--
--   -- vim.fn.bufname().match('terminal')
--   -- vim.fn.bufname().match('terminal')
-- end
--
-- vim.keymap.set(
--   'n',
--   '<space>T',
--   toggleTerminal,
--   { noremap = true, silent = true, desc = 'nnn (use cwd)' }
-- )

return M
