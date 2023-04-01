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
        find_by_full_path_words = true,
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_hidden = false,
        },
        window = {
          mappings = {
            ['/'] = 'none',
            ['<space>/'] = 'fuzzy_finder',
            ['?'] = 'none',
            ['<space>?'] = 'show_help',
          }
        }
      }
    },
    config = function(_, opts)
      require('neo-tree').setup(opts)

      local cmd = require('neo-tree.command')

      vim.keymap.set('n', '<space>E', '', {
        desc = 'Open neotree',
        callback = function()
          cmd.execute({ toggle = true })
        end,
      })

      vim.keymap.set('n', '<space>str', '', {
        desc = 'Reveal file in neotree',
        callback = function()
          cmd.execute({ reveal = true })
        end,
      })
    end,
  }
}
