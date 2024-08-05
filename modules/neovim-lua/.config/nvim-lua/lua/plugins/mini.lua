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
        }
      })

      local hydra = require('hydra')
      hydra({
        name = 'Move Visual Selection',
        hint = false,
        config = {
          foreign_keys = nil,
          on_exit = function()
            -- exit visual mode
            vim.cmd('normal Esc')
          end,
        },
        mode = 'x',
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
        },
        body = '<leader>m',
      })
    end
  }
}
