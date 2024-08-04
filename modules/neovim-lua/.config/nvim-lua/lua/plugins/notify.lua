local MARGIN_VERTICAL = 1

local function fade_with_margin(direction)
  local stages_util = require('notify.stages.util')
  direction = direction or stages_util.DIRECTION.TOP_DOWN
  return {
    function(state)
      local next_height = state.message.height + 2
      local next_row =
        stages_util.available_slot(state.open_windows, next_height, direction)
      if not next_row then
        return nil
      end

      -- Add a margin if this is the "first" notification
      local is_first_window = #state.open_windows == 0
      if is_first_window then
        if direction == stages_util.DIRECTION.TOP_DOWN then
          next_row = next_row + MARGIN_VERTICAL
        elseif direction == stages_util.DIRECTION.BOTTOM_UP then
          next_row = next_row - MARGIN_VERTICAL
        end
      end

      return {
        relative = 'editor',
        anchor = 'NE',
        width = state.message.width,
        height = state.message.height,
        col = vim.opt.columns:get(),
        row = next_row,
        border = 'rounded',
        style = 'minimal',
        opacity = 0,
      }
    end,
    function()
      return {
        opacity = { 100 },
        col = { vim.opt.columns:get() },
      }
    end,
    function()
      return {
        col = { vim.opt.columns:get() },
        time = true,
      }
    end,
    function()
      return {
        opacity = {
          0,
          frequency = 2,
          complete = function(cur_opacity)
            return cur_opacity <= 4
          end,
        },
        col = { vim.opt.columns:get() },
      }
    end,
  }
end

return {
  {
    'rcarriga/nvim-notify',
    config = function()
      local stages_util = require('notify.stages.util')
      require('notify').setup({
        timeout = 1500,
        stages = fade_with_margin(stages_util.DIRECTION.TOP_DOWN),
      })
    end,
  },

  {
    'j-hui/fidget.nvim',
    tag = 'v1.4.5',
    config = function()
      require('fidget').setup({
      })
    end
  },
}
