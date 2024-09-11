return {
  {
    'lewis6991/gitsigns.nvim',
    dependencies = { 'nvimtools/hydra.nvim' },
    config = function()
      local gitsigns = require('gitsigns')

      -- Hydra for navigating hunks.  Possibly staging them as well?
      local hydra = require('hydra')
      hydra({
        name = 'Git Hunk Navigation',
        config = {
          invoke_on_body = true,
          hint = {
            type = 'window',
          },
        },
        mode = 'n',
        body = '<space>HG',
        heads = {
          {
            ']',
            function()
              gitsigns.nav_hunk('next')
            end,
          },
          {
            '[',
            function()
              gitsigns.nav_hunk('previous')
            end,
          },

          -- Mimic "git add --patch" commands
          {
            'y',
            function()
              gitsigns.stage_hunk()
              gitsigns.nav_hunk('next')
            end,
          },
          {
            'n',
            function()
              gitsigns.stage_hunk()
              gitsigns.nav_hunk('next')
            end,
          },
          {
            'q',
            nil,
            {
              exit = true,
            }
          }
        }
      })

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
          end, { desc = 'Goto next git hunk'})

          map('n', '[c', function()
            if vim.wo.diff then
              vim.cmd.normal({ '[c', bang = true })
            else
              gitsigns.nav_hunk('prev')
            end
          end, { desc = 'Goto previous git hunk'})

          -- Actions
          map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'Stage hunk' })
          map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'Reset hunk' })
          map('v', '<leader>hs', function()
            gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
          end, { desc = 'Stage visual selection of hunk'})
          map('v', '<leader>hr', function()
            gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
          end, { desc = 'reset visual selection of hunk'})
          map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'Stage buffer' })
          map('n', '<leader>hu', gitsigns.undo_stage_hunk, { desc = 'Undo stage hunk' })
          map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'Git reset buffer' })
          map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'Preview git hunk'})
          map('n', '<leader>hP', gitsigns.preview_hunk_inline, { desc = 'Preview git hunk inline'})
          map('n', '<leader>hb', function()
            gitsigns.blame_line({ full = true })
          end, { desc = 'Blame line' })
          map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = 'Toggle current line blame'})
          map('n', '<leader>hD', function()
            gitsigns.diffthis('~')
          end, { desc = 'Diff this against "~"'})

          map('n', '<leader>td', gitsigns.toggle_deleted, { desc = 'Toggle deleted'})

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
    config = function()
      vim.keymap.set('n', 'sdd', '<cmd>DiffviewOpen<cr>', { desc = 'Diffview working tree' })
      vim.keymap.set('n', 'sdd', '<cmd>DiffviewOpen<cr>', { desc = 'Diffview working tree' })
      vim.keymap.set('n', 'sd%', '<cmd>DiffviewFileHistory %<cr>', { desc = 'Diffview against main' })
    end,
  },

  {
    'kdheepak/lazygit.nvim',
    config = function()
      vim.keymap.set('n', '<space>hg', '<cmd>LazyGit<cr>', { desc = 'LazyGit' })
    end
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
