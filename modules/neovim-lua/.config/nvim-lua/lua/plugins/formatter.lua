return {
  {
    'mhartington/formatter.nvim',
    event = 'VeryLazy',
    config = function()
      local formatter_utils = require('formatter.util')

      require('formatter').setup({
        filetype = {
          lua = {
            require('formatter.filetypes.lua').stylua,
          },

          json = {
            require('formatter.filetypes.json').jq,
          },

          jsonc = {
            function()
              return {
                exe = 'deno',
                args = { 'fmt', },
                -- stdin not working on standalone jsonc file for some reason...
                stdin = false,
              }
            end
          },

          ruby = {
            require('formatter.filetypes.ruby').rubocop,
          },

          javascript = {
            require('formatter.filetypes.javascript').prettier,
          },

          toml = {
            require('formatter.filetypes.toml').taplo,
          },

          sh = {
            function()
              -- shfmt will only use the editorconfig file if:
              --   * passing a real filepath (not stdin)
              --   * no parser / printer arguments are provided

              -- Build default args, which will be used if an .editorconfig
              -- file doesn't exist
              local indent = vim.opt.shiftwidth:get()
              local expandtab = vim.opt.expandtab:get()
              if not expandtab then
                indent = 0
              end
              local default_shfmt_args = {
                '--case-indent',
                '--indent',
                indent,
              }

              local buffer_path = formatter_utils.get_current_buffer_file_path()
              local buffer_is_file = vim.fn.filereadable(buffer_path) == 1
              if not buffer_is_file then
                return {
                  exe = 'shfmt',
                  args = default_shfmt_args,
                  stdin = true,
                }
              end

              -- Use the .editorconfig file if it exists
              local has_editorconfig = vim.fs.find('.editorconfig', {
                path = formatter_utils.get_current_buffer_file_path(),
                upward = true,
              })[1] ~= nil

              -- don't pass parser/printer flags since it will disable the
              -- .editorconfig integration from shfmt
              if has_editorconfig then
                return {
                  exe = 'shfmt',
                  -- '--filename' is required for shfmt to be able to resolve
                  -- the editorconfig path.
                  args = { '--filename', buffer_path },
                  stdin = true,
                }
              else
                return {
                  exe = 'shfmt',
                  args = default_shfmt_args,
                  stdin = true,
                }
              end
            end,
          },

          typescript = {
            function()
              local cwd = vim.fn.getcwd()
              local is_node = vim.fn.filereadable(cwd .. '/package.json') == 1
              if is_node then
                return {
                  exe = 'prettier',
                  args = {
                    '--stdin-filepath',
                    formatter_utils.escape_path(
                      formatter_utils.get_current_buffer_file_path()
                    ),
                    '--parser',
                    'typescript',
                  },
                  stdin = true,
                  try_node_modules = true,
                }
              end

              local has_deno_config = (vim.fn.filereadable(cwd .. '/deno.json') == 1)
                or (vim.fn.filereadable(cwd .. '/deno.jsonc') == 1)

              local args = { 'fmt' }
              if not has_deno_config then
                table.insert(args, '--single-quote')
              end
              table.insert(args, '-')
              return {
                exe = 'deno',
                args = args,
                stdin = true,
              }
            end,
          },

          ['*'] = {
            require('formatter.filetypes.any').remove_trailing_whitespace,
          },
        },
      })

      vim.keymap.set(
        'n',
        '<space>ef',
        '<cmd>Format<cr>',
        { desc = 'Format Buffer' }
      )
    end,
  },
}
