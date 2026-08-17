return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,

  ---@type snacks.Config
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    bigfile = { enabled = false },
    dashboard = { enabled = false },
    explorer = { enabled = false },
    indent = { enabled = false },
    input = { enabled = false },
    picker = { enabled = false },
    notifier = { enabled = false },
    quickfile = { enabled = false },
    scope = { enabled = false },
    scroll = { enabled = false },
    statuscolumn = { enabled = false },
    words = { enabled = false },
  },
  keys = {
    -- gitbrowse
    {
      '<space>oghb',
      function()
        Snacks.gitbrowse()
      end,
      desc = 'Git browse',
    },
    {
      '<space>oghx',
      function()
        print('nope')
        -- Snacks.gitbrowse.open(opts)
      end,
      desc = 'Git open',
    },
  },
}
