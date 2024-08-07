return {
  {
    'echasnovski/mini.splitjoin',
    config = function()
      require('mini.splitjoin').setup()
    end,
  },
  {
    'echasnovski/mini.move',
    dependencies = { 'anuvyklack/hydra.nvim' },
    config = function()
      require('mini.move').setup({
        -- Disable default mappings
        mappings = {
          left = '',
          right = '',
          down = '',
          up = '',
          line_left = '',
          line_right = '',
          line_down = '',
          line_up = '',
        },
      })

      local hydra = require('hydra')
      hydra({
        name = 'Move Visual Selection',
        config = {
          invoke_on_body = true,
          foreign_keys = nil,
          hint = {
            type = 'window',
          },
        },
        mode = 'x',
        body = '<space>HM',
        heads = {
          {
            'j',
            function()
              MiniMove.move_selection('down')
            end,
          },
          {
            'k',
            function()
              MiniMove.move_selection('up')
            end,
          },
          {
            'h',
            function()
              MiniMove.move_selection('left')
            end,
          },
          {
            'l',
            function()
              MiniMove.move_selection('right')
            end,
          },
          {
            -- By default <esc> will only exit the 'hydra' mode
            -- Remap esc to exit hydra mode _and_ exit visual mode
            '<esc>',
            function()
              local esc =
                vim.api.nvim_replace_termcodes('<esc>', true, false, true)
              vim.api.nvim_feedkeys(esc, 'x', false)
            end,
            {
              exit_before = true,
              exit = true,
            },
          },
        },
      })

      hydra({
        name = 'Move Line',
        config = {
          invoke_on_body = true,
          foreign_keys = nil,
          hint = {
            type = 'window',
          },
        },
        mode = 'n',
        body = '<space>HM',
        heads = {
          {
            'j',
            function()
              MiniMove.move_line('down')
            end,
          },
          {
            'k',
            function()
              MiniMove.move_line('up')
            end,
          },
          {
            'h',
            function()
              MiniMove.move_line('left')
            end,
          },
          {
            'l',
            function()
              MiniMove.move_line('right')
            end,
          },
        },
      })
    end,
  },
}
