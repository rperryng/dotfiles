return {
  {
    -- justfile syntax highlighting
    'NoahTheDuke/vim-just',
  },
  {
    'ellisonleao/gruvbox.nvim',
    priority = 1000,
    lazy = false,
    config = true,
    opts = {
      italic = {
        strings = false,
        emphasis = false,
        comments = false,
        operators = false,
        folds = false,
      },
      contrast = 'hard',
      -- transparent_mode = true,
    },
    init = function()
      vim.cmd('colorscheme gruvbox')
    end,
  },
}
