return {
  {
    'mhartington/formatter.nvim',
    event = 'VeryLazy',
    config = function()
      local util = require('formatter.util')

      require('formatter').setup({
        filetype = {
          lua = {
            require('formatter.filetypes.lua').stylua,
          },

          json = {
            require('formatter.filetypes.json').jq,
          },

          ruby = {
            require('formatter.filetypes.ruby').rubocop,
          },

          javascript = {
            require('formatter.filetypes.javascript').prettier,
          },

          typescript = {
            function()
              local cwd = vim.fn.getcwd()
              local is_deno = vim.fn.filereadable(cwd .. '/deno.json')
                or vim.fn.filereadable(cwd .. '/deno.jsonc ')

              if is_deno then
                return {
                  exe = 'deno',
                  args = { 'fmt', '-' },
                  stdin = true,
                }
              else
                return {
                  exe = "prettier",
                  args = {
                    "--stdin-filepath",
                    util.escape_path(util.get_current_buffer_file_path()),
                    "--parser",
                    'typescript',
                  },
                  stdin = true,
                  try_node_modules = true,
                }
              end
            end,
            -- require('formatter.filetypes.typescript').prettier,
          },

          ['*'] = {
            require('formatter.filetypes.any').remove_trailing_whitespace,
          },
        },
      })

      vim.keymap.set(
        'n',
        '<space>fo',
        '<cmd>Format<cr>',
        { desc = 'Format Buffer' }
      )
    end,
  },
}
