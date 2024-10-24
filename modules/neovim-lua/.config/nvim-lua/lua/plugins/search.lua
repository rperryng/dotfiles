return {
  {
    'backdround/improved-search.nvim',
    config = function()
      -- Search without moving from current match
      local search = require('improved-search')
      vim.keymap.set('n', '*', search.current_word)
      vim.keymap.set('x', '*', search.in_place)
    end,
  },
  {
    'asiryk/auto-hlsearch.nvim',

    -- ensure auto-hlsearch loads after improved-search, since it extends
    -- existings default binds
    dependencies = { 'backdround/improved-search.nvim' },
    config = function()
      require('auto-hlsearch').setup()
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
