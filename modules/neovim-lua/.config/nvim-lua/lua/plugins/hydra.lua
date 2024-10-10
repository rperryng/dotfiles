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

      -- Navigate diagnostics with 'n'/ 'N' similar to navigatin `/` search results
      local diagnostic_next = function()
        utils.close_floating_windows()
        Log('diagnostic next ...')
        Log(vim)
        vim.diagnostic.goto_next()
        vim.diagnostic.open_float()
      end
      local diagnostic_previous = function()
        utils.close_floating_windows()
        vim.diagnostic.goto_prev()
        vim.diagnostic.open_float()
      end
      hydra({
        name = 'Diagnostic Navigation (forwards)',
        config = {
          invoke_on_body = true,
          hint = false,
          on_enter = function()
            diagnostic_next()
          end,
          on_exit = function()
            utils.close_floating_windows()
          end,
        },
        mode = 'n',
        body = ']d',
        heads = {
          {
            'n',
            function()
              diagnostic_next()
            end,
          },
          {
            'N',
            function()
              diagnostic_previous()
            end,
          },
        },
      })
      hydra({
        name = 'Diagnostic Navigation (backwards)',
        config = {
          invoke_on_body = true,
          hint = false,
          on_enter = function()
            diagnostic_previous()
          end,
          on_exit = function()
            utils.close_floating_windows()
          end,
        },
        mode = 'n',
        body = '[d',
        heads = {
          {
            'n',
            function()
              diagnostic_previous()
            end,
          },
          {
            'N',
            function()
              diagnostic_next()
            end,
          },
        },
      })

      -- hydra({
      --   name = 'Diagnostic Navigation',
      --   config = {
      --     invoke_on_body = true,
      --     hint = false,
      --   },
      --   mode = 'n',
      --   body = '<space>HD',
      --   on_exit = function()
      --     utils.close_floating_windows()
      --   end,
      --   heads = {
      --     {
      --       'n',
      --       function()
      --         utils.close_floating_windows()
      --         vim.diagnostic.goto_next()
      --         vim.diagnostic.open_float()
      --       end,
      --     },
      --     {
      --       'p',
      --       function()
      --         utils.close_floating_windows()
      --         vim.diagnostic.goto_prev()
      --         vim.diagnostic.open_float()
      --       end,
      --     },
      --   },
      -- })
    end,
  },
}
