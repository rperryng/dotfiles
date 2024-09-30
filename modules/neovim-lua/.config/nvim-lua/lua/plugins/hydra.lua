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
