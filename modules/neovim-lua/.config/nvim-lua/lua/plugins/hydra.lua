local function setup_statusline()
  -- Reset Statusline
  vim.o.statusline = ''
  vim.o.laststatus = 3

  -- Statusline helper
  local function statusline(statusline_pattern)
    vim.o.statusline = vim.o.statusline .. statusline_pattern
  end

  -- Yield the current working directory name
  function StatusLineCwdName()
    return vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
  end

  function HydraStatusLineHelper()
    local hs = require('hydra.statusline')

    Log(vim.o.statusline)

    Log('definitely called')
    if not hs.is_active() then
      -- Use default status line config
      return ''
    end

    Log('hydra is active, returning other stuff')
    return '%#@none#'
  end

  statusline('%{%v:lua.HydraStatusLineHelper()%}')

  statusline('%#CursorLineNr#')
  statusline('%=(%{v:lua.StatusLineCwdName()})%=')
end

return {
  {
    'nvimtools/hydra.nvim',
    config = function()
      -- Hydra has no setup function.
      -- require('hydra').setup()

      -- TODO: Fix status line highlight colors for hydra
      -- setup_statusline()
    end
  }
}
