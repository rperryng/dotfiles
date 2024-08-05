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
        return 1000
      end,
      filter = function(mapping)
        -- Hydra "move visual selection"
        if (mapping.mode == 'x' and mapping.lhs:match(' m')) then
          return false
        end

        return true
      end
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
