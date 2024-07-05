-- Show buffer name in winbar
-- Use statusline to show project name

-- Yield the current working directory (used for StatusLine pattern)
function StatusLineCwdName()
  return vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
end

-- Reset Statusline
vim.o.statusline = ''
vim.o.laststatus = 3

-- Statusline helper
local function statusline(statusline_pattern)
  vim.o.statusline = vim.o.statusline .. statusline_pattern
end

statusline('%#CursorLineNr#')
statusline('%=(%{v:lua.StatusLineCwdName()})%=')

function WinBarHighlightExpr()
  if vim.fn.win_getid() == vim.g.actual_curwin then
    return '%#StatusLine#'
  else
    return '%#StatusLineNC#'
  end
end

-- Reset Winbar
vim.o.winbar = ''

-- Winbar helper
local function winbar(winbar_pattern)
  vim.o.winbar = vim.o.winbar .. winbar_pattern
end

-- Set WinBar Highlight Group
winbar('%{%v:lua.WinBarHighlightExpr()%}')

-- File name and buffer flags ([Help], [RO], [+] (modified) etc)
winbar(' %f')
winbar(' %m')
winbar(' %h')
winbar(' %w')
winbar(' %q')

-- filetype set (e.g. [vim])
winbar('%=')
winbar('%y')
winbar(' ')
