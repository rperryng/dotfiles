return {
  {
    'ibhagwan/fzf-lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      vim.keymap.set('n', '<space>test', ':Lazy reload fzf-lua', { desc = '' })

      local fzf = require('fzf-lua')
      local actions = require('fzf-lua.actions')
      fzf.setup({
        actions = {
          files = {
            -- explicitly declare defaults since 'actions.files' overwrites the table
            ['default'] = actions.file_edit_or_qf,
            ['ctrl-s'] = actions.file_split,
            ['ctrl-v'] = actions.file_vsplit,
            ['ctrl-t'] = actions.file_tabedit,
            ['alt-l'] = actions.file_sel_to_ll,

            -- rebind qw to ctrl-q instead of alt-q
            ['ctrl-q'] = actions.file_sel_to_qf,
          },
        },
        winopts = {
          preview = {
            layout = 'vertical',
          },
        },

        grep = {
          rg_opts = '--hidden --follow --column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e',
        },
      })

      fzf.register_ui_select()

      -- Builtins
      vim.keymap.set(
        'n',
        '<space>fd',
        fzf.builtin,
        { desc = 'Fuzzy search builtin pickers' }
      )

      -- Files
      vim.keymap.set(
        'n',
        '<space>ff',
        fzf.files,
        { desc = 'Fuzzy search files' }
      )

      vim.keymap.set(
        'n',
        '<space>fof',
        fzf.files,
        { desc = 'Fuzzy search old files' }
      )

      -- Buffers
      vim.keymap.set(
        'n',
        '<space>fb',
        fzf.buffers,
        { desc = 'Fuzzy search buffers' }
      )

      -- Grep
      vim.keymap.set('n', '<space>fg', function()
        -- fzf.grep({ search = '', fzf_opts = { ['--nth'] = '..' } })
        fzf.grep({ search = '' })
        fzf.grep({ search = '', debug = 'true' })

        vim.keymap.set('n', '<space>f.', function()
          fzf.grep({ resume = true })
        end, { desc = 'Resume last fuzzy search' })
      end, { desc = 'Fuzzy search grep (match on filenames as well)' })

      vim.keymap.set('n', '<space>fG', function()
        fzf.grep({ search = '', fzf_opts = { ['--nth'] = '2..' } })

        vim.keymap.set('n', '<space>f.', function()
          fzf.grep({ resume = true })
        end, { desc = 'Resume last fuzzy search' })
      end, { desc = 'Fuzzy search grep (do not match filenames)' })

      vim.keymap.set('n', '<space>rg', function()
        fzf.live_grep({ exec_empty_query = true, debug = true })

        vim.keymap.set('n', '<space>f.', function()
          fzf.live_grep({ resume = true })
        end, { desc = 'Resume last fuzzy search' })
      end, { desc = 'Search with ripgrep' })

      -- help
      vim.keymap.set(
        'n',
        '<space>fh',
        fzf.helptags,
        { desc = 'Fuzzy search help tags' }
      )

      -- registers
      vim.keymap.set(
        'n',
        '<space>fr',
        fzf.registers,
        { desc = 'Fuzzy search registers' }
      )

      -- marks
      vim.keymap.set(
        'n',
        '<space>fm',
        fzf.registers,
        { desc = 'Fuzzy search marks' }
      )

      -- keymaps
      vim.keymap.set(
        'n',
        '<space>fk',
        fzf.keymaps,
        { desc = 'Fuzzy search keymaps' }
      )

      -- Commands
      vim.keymap.set(
        'n',
        '<space>fc',
        fzf.commands,
        { desc = 'Fuzzy search commands' }
      )

      vim.keymap.set(
        'n',
        '<space>foc',
        fzf.command_history,
        { desc = 'Fuzzy search old commands' }
      )

      -- Lines
      vim.keymap.set(
        'n',
        '<space>flb',
        fzf.blines,
        { desc = 'Fuzzy search lines (current buffer only)' }
      )

      vim.keymap.set(
        'n',
        '<space>fla',
        fzf.lines,
        { desc = 'Fuzzy search lines (all open buffers)' }
      )

      -- Search history
      vim.keymap.set(
        'n',
        '<space>fo/',
        fzf.search_history,
        { desc = "Fuzzy search '/' search history" }
      )
    end,
  },
}
