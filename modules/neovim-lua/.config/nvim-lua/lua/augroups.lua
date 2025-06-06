local function augroup(name)
  return vim.api.nvim_create_augroup('rpn_' .. name, { clear = true })
end

-- Reload files automatically
vim.api.nvim_create_autocmd(
  { 'FocusGained', 'BufEnter', 'TermClose', 'TermLeave' },
  {
    group = augroup('checktime'),
    command = 'checktime',
  }
)

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd('BufReadPost', {
  group = augroup('last_loc'),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Disable line numbers for terminal buffers
vim.api.nvim_create_autocmd('TermOpen', {
  group = augroup('terminal_buffers'),
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.scrollback = 50000
  end,
});

vim.api.nvim_create_autocmd('FileType', {
  group = augroup('c'),
  pattern = { 'c' },
  callback = function()
    vim.bo.commentstring = '// %s'
  end,
})

local function set_diff_highlights()
  local is_dark = vim.o.background == 'dark'

  if is_dark then
    vim.api.nvim_set_hl(0, 'DiffAdd', { fg = 'none', bg = '#2e4b2e', bold = true })
    vim.api.nvim_set_hl(0, 'DiffDelete', { fg = 'none', bg = '#4c1e15', bold = true })
    vim.api.nvim_set_hl(0, 'DiffChange', { fg = 'none', bg = '#45565c', bold = true })
    vim.api.nvim_set_hl(0, 'DiffText', { fg = 'none', bg = '#996d74', bold = true })
  else
    vim.api.nvim_set_hl(0, 'DiffAdd', { fg = 'none', bg = 'palegreen', bold = true })
    vim.api.nvim_set_hl(0, 'DiffDelete', { fg = 'none', bg = 'tomato', bold = true })
    vim.api.nvim_set_hl(0, 'DiffChange', { fg = 'none', bg = 'lightblue', bold = true })
    vim.api.nvim_set_hl(0, 'DiffText', { fg = 'none', bg = 'lightpink', bold = true })
  end
end

set_diff_highlights()

vim.api.nvim_create_autocmd('ColorScheme', {
  group = augroup('diff_colors'),
  callback = set_diff_highlights
})
