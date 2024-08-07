return {
  -- {
  --   'airblade/vim-gitgutter',
  --   init = function()
  --     vim.g.gitgutter_map_keys = 0
  --   end,
  --   config = function()
  --     vim.cmd([[
  --       highlight! link GitGutterAdd GruvboxGreenSign
  --     ]])
  --
  --     -- Hunk Navigation
  --     vim.keymap.set(
  --       'n',
  --       '<space>gqg',
  --       ':GitGutterQuickFix | copen | cfirst<cr>',
  --       { desc = 'Load git hunks into quickfix list' }
  --     )
  --     vim.keymap.set(
  --       'n',
  --       ']g',
  --       '<Plug>(GitGutterNextHunk)',
  --       { desc = 'Next git hunk', noremap = false }
  --     )
  --     vim.keymap.set(
  --       'n',
  --       '[g',
  --       '<Plug>(GitGutterPrevHunk)',
  --       { desc = 'Next git hunk', noremap = false }
  --     )
  --
  --     -- Hunk Operations
  --     vim.keymap.set(
  --       'n',
  --       '<space>ghp',
  --       ':GitGutterPreviewHunk<cr>',
  --       { desc = 'Preview git diff hunk' }
  --     )
  --     vim.keymap.set(
  --       'n',
  --       '<space>ghu',
  --       ':GitGutterUndoHunk<cr>',
  --       { desc = 'Undo git diff hunk' }
  --     )
  --
  --     -- Text objects
  --     vim.keymap.set(
  --       'o',
  --       'igh',
  --       '<Plug>(GitGutterTextObjectInnerPending)',
  --       { desc = 'Git hunk inner' }
  --     )
  --     vim.keymap.set(
  --       'o',
  --       'agh',
  --       '<Plug>(GitGutterTextObjectOuterPending)',
  --       { desc = 'Git hunk inner' }
  --     )
  --     vim.keymap.set(
  --       'x',
  --       'igh',
  --       '<Plug>(GitGutterTextObjectInnerVisual)',
  --       { desc = 'Git hunk inner' }
  --     )
  --     vim.keymap.set(
  --       'x',
  --       'agh',
  --       '<Plug>(GitGutterTextObjectOuterVisual)',
  --       { desc = 'Git hunk inner' }
  --     )
  --   end,
  -- },

  {
    'lewis6991/gitsigns.nvim',
    dependencies = { 'nvimtools/hydra.nvim' },
    config = function()
      local gitsigns = require('gitsigns')

      vim.cmd([[
        highlight! link GitSignsAdd GruvboxGreenSign
        highlight! link GitSignsChange GruvboxYellowSign
        highlight! link GitSignsChangedelete GruvboxYellowSign
        highlight! link GitSignsDelete GruvboxRedSign
      ]])

      gitsigns.setup({
        on_attach = function(bufnr)
          -- local gitsigns = require('gitsigns')

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map('n', ']c', function()
            if vim.wo.diff then
              vim.cmd.normal({ ']c', bang = true })
            else
              gitsigns.nav_hunk('next')
            end
          end)

          map('n', '[c', function()
            if vim.wo.diff then
              vim.cmd.normal({ '[c', bang = true })
            else
              gitsigns.nav_hunk('prev')
            end
          end)

          -- Actions
          map('n', '<leader>hs', gitsigns.stage_hunk)
          map('n', '<leader>hr', gitsigns.reset_hunk)
          map('v', '<leader>hs', function()
            gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
          end)
          map('v', '<leader>hr', function()
            gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
          end)
          map('n', '<leader>hS', gitsigns.stage_buffer)
          map('n', '<leader>hu', gitsigns.undo_stage_hunk)
          map('n', '<leader>hR', gitsigns.reset_buffer)
          map('n', '<leader>hp', gitsigns.preview_hunk)
          map('n', '<leader>hb', function()
            gitsigns.blame_line({ full = true })
          end)
          map('n', '<leader>tb', gitsigns.toggle_current_line_blame)
          map('n', '<leader>hd', gitsigns.diffthis)
          map('n', '<leader>hD', function()
            gitsigns.diffthis('~')
          end)
          map('n', '<leader>td', gitsigns.toggle_deleted)

          -- Text object
          map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        end,
      })

      vim.keymap.set(
        'n',
        '<space>tqg',
        ':Gitsigns setqflist<cr>',
        { desc = 'Add git hunks to quickfix list' }
      )
    end,
  },

  {
    'sindrets/diffview.nvim',
    config = function() end,
  },

  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim',
      'ibhagwan/fzf-lua',
    },
    config = function()
      local neogit = require('neogit')
      neogit.setup({})

      vim.keymap.set('n', '<space>ghs', ':Neogit<cr>', { desc = 'Open neogit'})
    end
  }
}
