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
      local hydra = require('hydra')
      local utils = require('utils')

      hydra({
        name = 'Quickfix navigation',
        config = {
          invoke_on_body = true,
          hint = false,
        },
        mode = 'n',
        body = '<space>HQ',
        heads = {
          {
            'n',
            function()
              vim.cmd('silent! cnext')
            end,
          },
          {
            'p',
            function()
              vim.cmd('silent! cprevious')
            end,
          },
        },
      })

      hydra({
        name = 'Diagnostic Navigation',
        config = {
          hint = false,
        },
        mode = 'n',
        body = '<space>HD',
        on_exit = function()
          utils.close_floating_windows()
        end,
        heads = {
          {
            'n',
            function()
              utils.close_floating_windows()
              vim.diagnostic.goto_next()
              vim.diagnostic.open_float()
            end,
          },
          {
            'p',
            function()
              utils.close_floating_windows()
              vim.diagnostic.goto_prev()
              vim.diagnostic.open_float()
            end,
          },
        },
      })
    end,
  },
}
