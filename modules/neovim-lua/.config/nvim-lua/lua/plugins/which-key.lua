local utils = require('utils')

if utils.is_wsl() then
  return {}
end

return {
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      delay = function(_ctx)
        return 200
      end,
    },
    keys = {
      {
        "'",
        function()
          require('which-key').show('`')
        end,
        desc = 'Marks',
      },
    },
  },
}
