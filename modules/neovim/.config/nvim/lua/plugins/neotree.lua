return {
  {
    'nvim-neo-tree/neo-tree.nvim',
    init = function()
      vim.g.neo_tree_remove_legacy_commands = 1
    end,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
    },
    keys = {
      {
        '<space>st',
        function()
          require('neo-tree.command').execute({ toggle = true })
        end,
      },
    },
    config = function()
      require('neo-tree').setup()
    end,
  }
}
