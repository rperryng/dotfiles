return {
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
    },
    deactivate = function()
      vim.cmd([[Neotree close]])
    end,
    config = function()
      require('neo-tree').setup({
        sources = { 'filesystem', 'buffers', 'git_status', 'document_symbols' },
        close_if_last_window = true,
        filesystem = {
          filtered_items = {
            visible = true,
            hide_dotfiles = false,
          },
        },
      })

      vim.keymap.set('n', '<space>st', function()
        require('neo-tree.command').execute({
          toggle = true,
          dir = vim.uv.cwd(),
        })
      end, { desc = 'NeoTree (current working directory)' })

      vim.keymap.set('n', '<space>sT', function()
        require('neo-tree.command').execute({
          toggle = true,
          reveal = true
        })
      end, { desc = 'NeoTree (reveal current file)' })
    end,
  },
}
