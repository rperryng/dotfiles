return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup({})
    end,
  },
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    branch = 'canary',
    dependencies = {
      { 'zbirenbaum/copilot.lua' },
      { 'nvim-lua/plenary.nvim' },
    },
    config = function()
      local chat = require('CopilotChat')
      chat.setup({
        debug = false,
        mappings = {
          reset = {
            normal ='<c-c><c-c>',
            insert = '<c-c><c-c>'
          },
        },
      })

      vim.keymap.set(
        'n',
        '<space>cot',
        chat.toggle,
        { desc = 'Toggle copilot chat window' }
      )
      vim.keymap.set(
        'n',
        '<space>cor',
        chat.reset,
        { desc = 'Reset copilot chat' }
      )

      vim.keymap.set(
        'n',
        '<space>cot',
        ':CopilotChatCommitStaged<cr>',
        { desc = 'Copilot commit staged' }
      )
    end,
  },
}
