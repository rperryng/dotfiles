return {
  {
    'ibhagwan/fzf-lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      vim.keymap.set('n', '<space>test', ':Lazy reload fzf-lua', { desc = '' })

      local fzf = require('fzf-lua')
      local actions = require('fzf-lua.actions')
      local utils = require('utils')

      fzf.setup({
        actions = {
          files = {
            -- explicitly declare defaults since 'actions.files' overwrites the table
            ['default'] = actions.file_edit_or_qf,
            ['ctrl-s'] = actions.file_split,
            ['ctrl-v'] = actions.file_vsplit,
            ['ctrl-t'] = actions.file_tabedit,
            ['ctrl-space'] = function(selected, _opts)
              local path = utils.uniconify(selected[1])
              if path == nil then
                vim.print('failed to extract path from: ' .. selected[1])
                return
              end
              vim.api.nvim_put({ path }, '', true, true)
            end,

            -- toggles
            ['ctrl-o'] = actions.toggle_ignore,
            ['ctrl-h'] = actions.toggle_hidden,
            ['ctrl-q'] = actions.file_sel_to_qf,
          },
        },

        winopts = {
          preview = {
            layout = 'vertical',
          },
        },

        lsp = {
          actions = {
            code_actions = {
              -- use 'git-delta' for diff
              previewer = 'codeaction_native',
            },
          },
        },

        grep = {
          rg_opts = '--hidden --follow --column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e',
        },
      })

      fzf.register_ui_select()

      local function keymap_with_resume(mode, lhs, rhs, opts)
        vim.keymap.set(mode, lhs, function()
          rhs.fn(rhs.fn_opts or {})

          vim.keymap.set('n', '<space>f.', function()
            rhs.fn({ resume = true })
          end, { desc = 'Resume last fzf search' })
        end, opts)
      end

      -- Builtin
      keymap_with_resume('n', '<space>fz', {
        fn = fzf.builtin,
      }, { desc = 'Fuzzy search builtin pickers' })

      -- Files
      keymap_with_resume('n', '<space>ff', {
        fn = fzf.files,
      }, { desc = 'Fuzzy search files' })
      keymap_with_resume('t', '<c-x><c-f>', {
        fn = fzf.files,
      }, { desc = 'Fuzzy search files' })

      keymap_with_resume('n', '<space>fof', {
        fn = fzf.oldfiles,
        fn_opts = {
          cwd_only = true,
          winopts = {
            preview = {
              vertical = 'down:70%',
            },
          },
        },
      }, {
        desc = 'Fuzzy search old files',
      })

      keymap_with_resume('n', '<space>foF', {
        fn = fzf.oldfiles,
        fn_opts = {
          cwd_only = true,
          winopts = {
            preview = {
              vertical = 'down:70%',
            },
          },
        },
      }, {
        desc = 'Fuzzy search old files',
      })

      -- Tabs
      keymap_with_resume('n', '<space>ft', {
        fn = fzf.tabs,
        fn_opts = {
          query = "'Tab ",
        },
      }, { desc = 'Fuzzy search tabs' })

      -- Buffers
      keymap_with_resume('n', '<space>fb', {
        fn = fzf.buffers,
        fn_opts = {
          cwd_only = true,
        },
      }, { desc = 'Fuzzy search buffers (current working directory only)' })

      keymap_with_resume('n', '<space>fB', {
        fn = fzf.buffers,
        fn_opts = {
          cwd_only = false,
        },
      }, { desc = 'Fuzzy search buffers' })

      -- Grep (Ripgrep)
      keymap_with_resume('n', '<space>rg', {
        fn = function()
          fzf.grep({ search = '', fzf_opts = { ['--nth'] = '..' } })
        end,
      }, { desc = 'Fuzzy search ripgrep (match on filenames as well)' })

      keymap_with_resume('n', '<space>rG', {
        fn = function()
          fzf.grep({ search = '', fzf_opts = { ['--nth'] = '2..' } })
        end,
      }, { desc = 'Fuzzy search ripgrep (do not match filenames)' })

      keymap_with_resume('n', '<space>RG', {
        fn = function()
          fzf.live_grep({ exec_empty_query = true })
        end,
      }, { desc = 'Search directly with ripgrep' })

      -- help
      keymap_with_resume('n', '<space>fh', {
        fn = fzf.helptags,
      }, { desc = 'Fuzzy search help tags' })

      -- filetypes
      keymap_with_resume('n', '<space>F', {
        fn = fzf.filetypes,
        fn_opts = {
          winopts = {
            height = 0.5,
            width = 0.3,
          },
        },
      }, { desc = 'Fuzzy search filetypes' })

      -- registers
      keymap_with_resume('n', '<space>fr', {
        fn = fzf.registers,
      }, { desc = 'Fuzzy search registers' })

      -- marks
      keymap_with_resume('n', '<space>fm', {
        fn = fzf.marks,
      }, { desc = 'Fuzzy search marks' })

      -- keymaps
      keymap_with_resume('n', '<space>fk', {
        fn = fzf.keymaps,
      }, { desc = 'Fuzzy search keymaps' })

      -- Commands
      keymap_with_resume('n', '<space>fc', {
        fn = fzf.commands,
      }, { desc = 'Fuzzy search commands' })

      keymap_with_resume('n', '<space>foc', {
        fn = fzf.command_history,
      }, { desc = 'Fuzzy search old commands' })

      -- Lines
      keymap_with_resume('n', '<space>flb', {
        fn = fzf.blines,
      }, { desc = 'Fuzzy search lines (current buffer only)' })

      keymap_with_resume('n', '<space>fla', {
        fn = fzf.lines,
      }, { desc = 'Fuzzy search lines (all open buffers)' })

      -- Search history
      keymap_with_resume('n', '<space>fo/', {
        fn = fzf.search_history,
      }, { desc = "Fuzzy search '/' search history" })

      -- Word under cursor
      keymap_with_resume('n', '<space>f*', {
        fn = fzf.grep_cword,
      }, { desc = 'Fuzzy search word under cursor' })

      keymap_with_resume('v', '<space>f*', {
        fn = fzf.grep_visual,
      }, { desc = 'Fuzzy search visual selection' })

      -- Git
      keymap_with_resume('n', '<space>fgf', {
        fn = fzf.git_files,
      }, { desc = 'Fuzzy search git files' })

      keymap_with_resume('n', '<space>fgs', {
        fn = fzf.git_status,
      }, { desc = 'Fuzzy search git status' })

      keymap_with_resume('n', '<space>fgcc', {
        fn = fzf.git_commits,
      }, { desc = 'Fuzzy search git commit log (project)' })

      keymap_with_resume('n', '<space>fgcb', {
        fn = fzf.git_bcommits,
      }, { desc = 'Fuzzy search git commit log (buffer)' })

      keymap_with_resume('n', '<space>fgb', {
        fn = fzf.git_branches,
      }, { desc = 'Fuzzy search git branches' })

      keymap_with_resume('n', '<space>fgt', {
        fn = fzf.git_tags,
      }, { desc = 'Fuzzy search git tags' })

      keymap_with_resume('n', '<space>fgS', {
        fn = fzf.git_stash,
      }, { desc = 'Fuzzy search git stash' })

      -- Treesitter
      keymap_with_resume('n', '<space>fir', {
        fn = fzf.lsp_references,
      }, { desc = 'Fuzzy search LSP References' })

      keymap_with_resume('n', '<space>fiD', {
        fn = fzf.lsp_definitions,
      }, { desc = 'Fuzzy search LSP definitions' })

      keymap_with_resume('n', '<space>fid', {
        fn = fzf.lsp_declarations,
      }, { desc = 'Fuzzy search LSP declarations' })

      keymap_with_resume('n', '<space>fitd', {
        fn = fzf.lsp_typedefs,
      }, { desc = 'Fuzzy search LSP type definitions' })

      keymap_with_resume('n', '<space>fii', {
        fn = fzf.lsp_implementations,
      }, { desc = 'Fuzzy search LSP implementations' })

      keymap_with_resume('n', '<space>fibs', {
        fn = fzf.lsp_document_symbols,
      }, { desc = 'Fuzzy search LSP document (buffer) symbols' })

      keymap_with_resume('n', '<space>fiwS', {
        fn = fzf.lsp_workspace_symbols,
      }, { desc = 'Fuzzy search LSP workspace symbols (live)' })

      keymap_with_resume('n', '<space>fiws', {
        fn = fzf.lsp_workspace_symbols,
      }, { desc = 'Fuzzy search LSP workspace symbols' })

      keymap_with_resume('n', '<space>find', {
        fn = fzf.lsp_finder,
      }, { desc = 'Fuzzy search LSP locations (all-in-one)' })

      keymap_with_resume('n', '<space>fix', { -- hehe
        fn = fzf.lsp_finder,
      }, { desc = 'Fuzzy search LSP diagnostics (document)' })

      keymap_with_resume('n', '<space>fiX', { -- hehe
        fn = fzf.lsp_finder,
      }, { desc = 'Fuzzy search LSP diagnostics (workspace)' })

      -- -- select file and past while in insert mode
      -- vim.keymap.set('t', '<ctrl-\\>t', function()
      --   local fzf = require('fzf-lua')
      --   fzf.fzf_exec(fzf.actions.files, {
      --     actions = {
      --       ['default'] = function(selected, _opts)
      --         print("selected item:", selected[1])
      --       end
      --     }
      --   })
      -- end, { desc = 'Insert filename' })
    end,
  },
}
