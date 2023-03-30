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
    opts = {
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_hidden = false,
        }
      }
    },
    config = function(_, opts)
      require('neo-tree').setup(opts)

      local cmd = require('neo-tree.command')

      vim.keymap.set('n', '<space>sto', '', {
        desc = 'Open neotree',
        callback = function()
          cmd.execute({ toggle = true })
        end,
      })

      vim.keymap.set('n', '<space>str', '', {
        desc = 'Open neotree',
        callback = function()
          cmd.execute({ toggle = true, reveal = true })
        end,
      })
    end,
  }
}
