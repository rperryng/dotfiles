return {
  {
    'mcchrish/nnn.vim',
    config = function()
      local nnn_command = 'nnn -AH'
      if os.getenv('NNN_OPTS') and os.getenv('NNN_OPTS') ~= '' then
        nnn_command = 'nnn -' .. os.getenv('NNN_OPTS')
      end

      vim.g.nnn_command = nnn_command

      vim.g.nnn_action = {
        ['<c-t><c-t>'] = 'tab split',
        ['<c-s><c-s>'] = 'split',
        ['<c-v>'] = 'vsplit',
      }

      local layout_embedded = { layout = 'enew' }

      vim.keymap.set(
        'n',
        '<space>sn',
        function()
          vim.fn['nnn#pick'](vim.fn.getcwd(), { layout = 'enew' })
        end,
        { noremap = true, silent = true, desc = "nnn (use cwd)" }
      )
      vim.keymap.set(
        'n',
        '<space>sN',
        function()
          local buffer_directory = vim.fn.fnamemodify(vim.fn.expand('%'), ':p:h')
          vim.fn['nnn#pick'](buffer_directory, { layout = 'enew' })
        end,
        { noremap = true, silent = true, desc = "nnn (current buffer directory)" }
      )
    end,
  },
}
