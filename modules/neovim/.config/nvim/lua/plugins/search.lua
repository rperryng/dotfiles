return {
  {
    'haya14busa/vim-asterisk',
    config = function()
      vim.keymap.set(
        'n',
        '*',
        function ()
          local utils = require('utils')
          utils.call_plug_map('<Plug>(asterisk-z*)')

          if vim.opt.hlsearch:get() ~= true then
            vim.opt.hlsearch = true
          end
        end,
        { desc = 'Search forward (do not move cursor)' }
      )
      vim.keymap.set(
        'n',
        '#',
        '<Plug>(asterisk-z#)',
        { desc = 'Search backwards (do not move cursor)' }
      )
    end,
  },
  {
    'haya14busa/incsearch-fuzzy.vim',
    dependencies = { 'haya14busa/incsearch.vim' },
    config = function()
      vim.keymap.set(
        'n',
        's/',
        '<Plug>(incsearch-fuzzy-/)',
        { desc = 'Fuzzy search forwards in current buffer' }
      )
      vim.keymap.set(
        'n',
        's?',
        '<Plug>(incsearch-fuzzy-?)',
        { desc = 'Fuzzy search backwards current buffer' }
      )
    end,
  },
}
