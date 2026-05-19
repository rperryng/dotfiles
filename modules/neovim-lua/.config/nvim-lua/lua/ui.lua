-- Show buffer name in winbar
-- Use statusline to show project name

-- Yield the current working directory (used for StatusLine pattern)
function StatusLineCwdName()
  local projects = require('local.projects')
  return projects.get_project_name()
end

vim.o.laststatus = 3

-- Statusline helper. Build into a local string and assign once at the end —
-- reading `vim.o.statusline` after setting it to '' returns Neovim's default
-- (as of 0.12), so appending to it would concatenate onto the default.
local statusline_value = ''
local function statusline(statusline_pattern)
  statusline_value = statusline_value .. statusline_pattern
end

statusline('%#CursorLineNr#')
statusline('%=(%{v:lua.StatusLineCwdName()})%=')

vim.o.statusline = statusline_value

function WinBarHighlightExpr()
  if vim.fn.win_getid() == vim.g.actual_curwin then
    return '%#StatusLine#'
  else
    return '%#StatusLineNC#'
  end
end

-- Winbar helper. Same pattern as statusline above — assign once at the end
-- to avoid concatenating onto whatever default Neovim returns.
local winbar_value = ''
local function winbar(winbar_pattern)
  winbar_value = winbar_value .. winbar_pattern
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

vim.o.winbar = winbar_value
