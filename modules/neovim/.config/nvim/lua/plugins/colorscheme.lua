return {
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = { style = "night" },
  },

  {
    'sainnhe/gruvbox-material',
    config = function()
      vim.opt.termguicolors = true
      vim.opt.background = 'dark'

      vim.g.gruvbox_material_foreground = 'original'
      vim.g.gruvbox_material_background = 'hard'
      vim.g.gruvbox_material_better_performance = 0

      vim.cmd('colorscheme gruvbox-material')
    end,
  }
}
