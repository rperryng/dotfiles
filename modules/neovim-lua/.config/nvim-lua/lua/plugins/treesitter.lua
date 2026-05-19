return {

  -- Parser manager. nvim-treesitter was archived (2026-04); this is a small
  -- replacement that wraps the `tree-sitter` CLI (installed via mise). It
  -- ensures parsers are present and turns on `vim.treesitter.start()` for
  -- supported filetypes.
  {
    'romus204/tree-sitter-manager.nvim',
    config = function()
      -- Filetype detection for helm/gotmpl. tree-sitter-manager only attaches
      -- highlighting via FileType autocmds, so files under templates/ must be
      -- detected as `helm` (not `yaml`) for the helm parser to be applied.
      vim.filetype.add({
        extension = {
          gotmpl = 'gotmpl',
        },
        pattern = {
          ['.*/templates/.*%.tpl'] = 'helm',
          ['.*/templates/.*%.ya?ml'] = 'helm',
          ['helmfile.*%.ya?ml'] = 'helm',
        },
      })

      require('tree-sitter-manager').setup({
        ensure_installed = {
          'bash',
          'c',
          'cpp',
          'cue',
          'go',
          'gotmpl', -- needed for helm queries (helm/highlights.scm inherits from gotmpl)
          'graphql',
          'http',
          'helm',
          'javascript',
          'json',
          'lua',
          'python',
          'ruby',
          'rust',
          'terraform',
          'tsx',
          'typescript',
          'vim',
          'vimdoc',
          'yaml',
        },
        highlight = true,
        auto_install = false,
        border = 'rounded',
      })
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    event = 'VeryLazy',
    config = function()
      require('nvim-treesitter-textobjects').setup({
        select = {
          lookahead = true,
        },
        move = {
          set_jumps = true,
        },
      })

      local select = require('nvim-treesitter-textobjects.select')
      local move = require('nvim-treesitter-textobjects.move')
      local swap = require('nvim-treesitter-textobjects.swap')

      -- Select
      local select_map = {
        aa = '@parameter.outer',
        ia = '@parameter.inner',
        af = '@function.outer',
        ['if'] = '@function.inner',
        ac = '@class.outer',
        ic = '@class.inner',
      }
      for lhs, query in pairs(select_map) do
        vim.keymap.set({ 'x', 'o' }, lhs, function()
          select.select_textobject(query, 'textobjects')
        end, { desc = 'Select ' .. query })
      end

      -- Move
      local function goto_map(fn, map)
        for lhs, query in pairs(map) do
          vim.keymap.set({ 'n', 'x', 'o' }, lhs, function()
            move[fn](query, 'textobjects')
          end, { desc = fn .. ' ' .. query })
        end
      end
      goto_map('goto_next_start', { [']m'] = '@function.outer', [']]'] = '@class.outer' })
      goto_map('goto_next_end', { [']M'] = '@function.outer', [']['] = '@class.outer' })
      goto_map('goto_previous_start', { ['[m'] = '@function.outer', ['[['] = '@class.outer' })
      goto_map('goto_previous_end', { ['[M'] = '@function.outer', ['[]'] = '@class.outer' })

      -- Swap
      vim.keymap.set('n', '<space>a', function()
        swap.swap_next('@parameter.inner')
      end, { desc = 'Swap parameter next' })
      vim.keymap.set('n', '<space>A', function()
        swap.swap_previous('@parameter.inner')
      end, { desc = 'Swap parameter previous' })
    end,
  },
}
