return {
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
  {
    'haya14busa/vim-asterisk',
    dependencies = { 'qxxxb/vim-searchhi' },
    config = function()
      vim.g.searchhi_clear_all_autocmds = 'InsertEnter'

      -- Basid search keymaps
      vim.keymap.set(
        'n',
        '/',
        '<Plug>(searchhi-/)',
        { desc = 'Search forwards' }
      )
      vim.keymap.set(
        'n',
        '?',
        '<Plug>(searchhi-?)',
        { desc = 'Search backwards' }
      )
      vim.keymap.set(
        'n',
        'n',
        '<Plug>(searchhi-n)',
        { desc = 'Go to next search match' }
      )
      vim.keymap.set(
        'n',
        'N',
        '<Plug>(searchhi-N)',
        { desc = 'Go to previous search match' }
      )
      vim.keymap.set(
        'n',
        '<space>sl',
        '<Plug>(searchhi-clear-all)',
        { silent = true, desc = 'clear all search highlighting' }
      )

      -- Visual mode mappings
      vim.keymap.set(
        'v',
        '/',
        '<Plug>(searchhi-v-/)',
        { desc = 'Search forwards' }
      )
      vim.keymap.set(
        'v',
        '?',
        '<Plug>(searchhi-v-?)',
        { desc = 'Search backwards' }
      )
      vim.keymap.set(
        'v',
        'n',
        '<Plug>(searchhi-v-n)',
        { desc = 'Search forwards' }
      )
      vim.keymap.set(
        'v',
        'N',
        '<Plug>(searchhi-v-N)',
        { desc = 'Search backwards' }
      )
      vim.keymap.set(
        'v',
        '<silent> <space>sl',
        '<Plug>(searchhi-v-clear-all)',
        { silent = true, desc = 'Clear search highlighting' }
      )

      -- Asterisk bindings
      vim.keymap.set('n', '*', '<Plug>(asterisk-z*)<Plug>(searchhi-update)', {
        desc = "Search forwards for word under cursor (don't move cursor if already on a search result)",
      })
      vim.keymap.set('n', '#', '<Plug>(asterisk-z#)<Plug>(searchhi-update)', {
        desc = "Search backwards for word under cursor (don't move cursor if already on a search result)",
      })
      vim.keymap.set(
        'v',
        '*',
        '<Plug>(asterisk-*)<Plug>(searchhi-update)',
        { desc = 'Search forwards for word under cursor' }
      )
      vim.keymap.set(
        'v',
        '#',
        '<Plug>(asterisk-#)<Plug>(searchhi-update)',
        { desc = 'Search backwards for word under cursor' }
      )
    end,
  },
}
