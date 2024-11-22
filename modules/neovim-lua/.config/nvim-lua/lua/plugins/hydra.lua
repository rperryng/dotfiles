return {
  {
    'nvimtools/hydra.nvim',
    config = function()
      local hydra = require('hydra')
      local utils = require('utils')

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

      -- Quickfix navigation
      local quickfix_next = function()
        vim.cmd('silent! cnext')
      end
      local quickfix_previous = function()
        vim.cmd('silent! cprevious')
      end
      hydra({
        name = 'Quickfix Navigation (forwards)',
        config = {
          invoke_on_body = true,
          hint = false,
          on_enter = function()
            quickfix_next()
          end,
        },
        mode = 'n',
        body = ']q',
        heads = {
          {
            'n',
            function()
              quickfix_next()
            end,
          },
          {
            'N',
            function()
              quickfix_previous()
            end,
          },
        },
      })
      hydra({
        name = 'Quickfix Navigation (backwards)',
        config = {
          invoke_on_body = true,
          hint = false,
          on_enter = function()
            quickfix_previous()
          end,
        },
        mode = 'n',
        body = '[q',
        heads = {
          {
            'n',
            function()
              quickfix_previous()
            end,
          },
          {
            'N',
            function()
              quickfix_next()
            end,
          },
        },
      })

      local scroll_up = function()
        vim.api.nvim_feedkeys(
          vim.api.nvim_replace_termcodes('<c-y>', true, false, true),
          'n',
          true
        )
      end

      local scroll_down = function()
        vim.api.nvim_feedkeys(
          vim.api.nvim_replace_termcodes('<c-e>', true, false, true),
          'n',
          true
        )
      end

      local scroll_right = function ()
        vim.cmd('normal zl')
      end

      local scroll_left = function ()
        vim.cmd('normal zh')
      end

      hydra({
        name = 'Scroll',
        config = {
          invoke_on_body = true,
          hint = false,
          on_enter = function() end,
        },
        mode = 'n',
        body = '<space>zs',
        heads = {
          {
            'j',
            function()
              scroll_down()
            end,
          },
          {
            '<right>',
            function ()
              scroll_down()
            end
          },
          {
            'k',
            function()
              scroll_up()
            end,
          },
          {
            '<up>',
            function ()
              scroll_up()
            end
          },
          {
            'h',
            function()
              scroll_left()
            end,
          },
          {
            '<left>',
            function()
              scroll_left()
            end,
          },
          {
            'l',
            function()
              scroll_right()
            end,
          },
          {
            '<right>',
            function()
              scroll_right()
            end,
          },
        },
      })
    end,
  },
}
