return {
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    -- NOTE: If you are having trouble with this installation,
    --       refer to the README for telescope-fzf-native for more instructions.
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },
  {
    'nvim-telescope/telescope.nvim',
    version = '*',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      defaults = {
        mappings = {
          i = {
            ['<c-u>'] = false,
            ['<c-d>'] = false,
          }
        }
      }
    },
    config = function(_, opts)
      -- Setup telescope
      local telescope = require('telescope')
      telescope.setup(opts)
      telescope.load_extension('fzf')
      local builtin = require('telescope.builtin')

      local function find_files()
        local home_dir = vim.fn.expand('$HOME')
        local current_working_directory = vim.fn.expand('%:p:h')

        if current_working_directory == home_dir then
          print("cwd is $HOME, skipping")
          return
        end

        builtin.find_files()
      end

      local function fuzzy_find_files_and_text()
        builtin.grep_string({
          path_display = { 'smart' },
          only_sort_text = false,
          word_match = "-w",
          search = '',
        })
      end

      local function fuzzy_find_text_only()
        builtin.grep_string({
          path_display = { 'smart' },
          only_sort_text = true,
          word_match = "-w",
          search = '',
        })
      end

      local keymaps = {
        n = {
          ['<space>fi'] = { func = find_files, desc = '[F]uzzy F[i]les' },
          ['<space>fa'] = { func = fuzzy_find_files_and_text, desc = '[F]uzzy in [A]ll files' },
          ['<space>fA'] = { func = fuzzy_find_text_only, desc = '[F]uzzy in [A]ll files' },
          ['<space>frg'] = { func = builtin.live_grep, desc = '[F]uzzy [R]ipgrep' },
          ['<space>frf'] = { func = builtin.oldfiles, desc = '[F]uzzy [R]ecently opened files' },
          ['<space>ftr'] = { func = builtin.treesitter, desc = '[F]uzzy [R]ecently opened files' },
          ['<space>fb'] = { func = builtin.buffers, desc = '[F]uzzy [Tr]eesitter' },
          ['<space>fh'] = { func = builtin.help_tags, desc = '[F]uzzy [H]elp' },
          ['<space>fw'] = { func = builtin.grep_string, desc = '[F]uzzy current [W]ord' },
          ['<space>fd'] = { func = builtin.diagnostics, desc = '[F]uzzy [D]iagnostics' },
          ['<space>fc'] = { func = builtin.commands, desc = '[F]uzzy [C]ommands' },
          ['<space>fC'] = { func = builtin.command_history, desc = '[F]uzzy [C]ommand history' },
          ['<space>fs'] = { func = builtin.search_history, desc = '[F]uzzy Search History' },
          ['<space>fm'] = { func = builtin.keymaps, desc = '[F]uzzy [M]appings' },
          ['<space>fM'] = { func = builtin.marks, desc = '[F]uzzy [M]arks' },
          ['<space>fgb'] = { func = builtin.git_branches, desc = '[F]uzzy [G]it [B]ranches' },
        }
      }

      -- Function to create keymap bindings
      local function set_keymaps(keymaps)
        for mode, mappings in pairs(keymaps) do
          for key, value in pairs(mappings) do
            vim.keymap.set(mode, key, value.func, { desc = value.desc })
          end
        end
      end
      set_keymaps(keymaps)
    end,
  },
}
