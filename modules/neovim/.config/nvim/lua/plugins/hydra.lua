return {
  {
    'nvimtools/hydra.nvim',
    config = function()
      local hydra = require('hydra')
      local utils = require('utils')

      -- Factory: create a simple n/N jumper hydra
      -- opts: { name, hint, forward, backward, on_exit? }
      local function make_simple_jumper(opts)
        return hydra({
          name = opts.name,
          config = {
            invoke_on_body = false,
            color = 'pink',
            hint = false,
            -- hint = {
            --   type = 'statusline',
            -- },
            on_exit = opts.on_exit,
          },
          mode = 'n',
          hint = opts.hint,
          heads = {
            { 'n', opts.forward, { desc = 'next' } },
            { 'N', opts.backward, { desc = 'prev' } },
            { '<Esc>', nil, { exit = true, desc = 'exit' } },
          },
        })
      end

      -- Factory: create treesitter jumper hydra
      local function make_treesitter_jumper()
        local last_forward = nil
        local last_backward = nil

        local function ts_goto(direction, capture)
          local ts_move = require('nvim-treesitter.textobjects.move')
          if direction == 'next' then
            ts_move.goto_next_start(capture)
          else
            ts_move.goto_previous_start(capture)
          end
        end

        local function make_pair(capture)
          local forward = function()
            ts_goto('next', capture)
          end
          local backward = function()
            ts_goto('prev', capture)
          end
          return forward, backward
        end

        local func_fwd, func_bwd = make_pair('@function.outer')
        local class_fwd, class_bwd = make_pair('@class.outer')
        local param_fwd, param_bwd = make_pair('@parameter.inner')

        return hydra({
          name = 'Treesitter Navigation',
          config = {
            invoke_on_body = false,
            color = 'pink',
            -- hint = {
            --   type = 'statusline',
            -- },
          },
          mode = 'n',
          hint = '_f_/_F_: function  _c_/_C_: class  _a_/_A_: arg  _n_/_N_: repeat  _<Esc>_: exit',
          heads = {
            {
              'f',
              function()
                last_forward = func_fwd
                last_backward = func_bwd
                func_fwd()
              end,
              { desc = 'next function' },
            },
            {
              'F',
              function()
                last_forward = func_fwd
                last_backward = func_bwd
                func_bwd()
              end,
              { desc = 'prev function' },
            },
            {
              'c',
              function()
                last_forward = class_fwd
                last_backward = class_bwd
                class_fwd()
              end,
              { desc = 'next class' },
            },
            {
              'C',
              function()
                last_forward = class_fwd
                last_backward = class_bwd
                class_bwd()
              end,
              { desc = 'prev class' },
            },
            {
              'a',
              function()
                last_forward = param_fwd
                last_backward = param_bwd
                param_fwd()
              end,
              { desc = 'next arg' },
            },
            {
              'A',
              function()
                last_forward = param_fwd
                last_backward = param_bwd
                param_bwd()
              end,
              { desc = 'prev arg' },
            },
            {
              'n',
              function()
                if last_forward then
                  last_forward()
                end
              end,
              { desc = 'repeat forward' },
            },
            {
              'N',
              function()
                if last_backward then
                  last_backward()
                end
              end,
              { desc = 'repeat backward' },
            },
            { '<Esc>', nil, { exit = true, desc = 'exit' } },
          },
        })
      end

      -- Diagnostics
      local diagnostic_next = function()
        utils.close_floating_windows()
        vim.diagnostic.jump({ count = 1, float = true })
        vim.diagnostic.open_float()
      end
      local diagnostic_previous = function()
        utils.close_floating_windows()
        vim.diagnostic.jump({ count = -1, float = true })
        vim.diagnostic.open_float()
      end
      local diagnostics_jumper = make_simple_jumper({
        name = 'Diagnostics',
        hint = '_n_: next  _N_: prev  _<Esc>_: exit',
        forward = diagnostic_next,
        backward = diagnostic_previous,
        on_exit = function()
          utils.close_floating_windows()
        end,
      })

      -- Quickfix
      local quickfix_jumper = make_simple_jumper({
        name = 'Quickfix',
        hint = '_n_: next  _N_: prev  _<Esc>_: exit',
        forward = function()
          vim.cmd('silent! cnext')
        end,
        backward = function()
          vim.cmd('silent! cprevious')
        end,
      })

      -- Git Hunks
      local hunks_jumper = make_simple_jumper({
        name = 'Git Hunks',
        hint = '_n_: next  _N_: prev  _<Esc>_: exit',
        forward = function()
          require('gitsigns').nav_hunk('next')
        end,
        backward = function()
          require('gitsigns').nav_hunk('prev')
        end,
      })

      -- Treesitter
      local treesitter_jumper = make_treesitter_jumper()

      -- Picker hydra at <space>hh
      local function activate(target_hydra)
        return function()
          target_hydra:activate()
        end
      end

      hydra({
        name = 'Jumper Picker',
        config = {
          invoke_on_body = true,
          hint = {
            type = 'statusline',
          },
        },
        mode = 'n',
        body = '<space>hh',
        hint = '_d_: diagnostics  _q_: quickfix  _g_: git hunks  _t_: treesitter  _<Esc>_: exit',
        heads = {
          {
            'd',
            activate(diagnostics_jumper),
            { exit = true, private = true, desc = 'diagnostics' },
          },
          {
            'q',
            activate(quickfix_jumper),
            { exit = true, private = true, desc = 'quickfix' },
          },
          {
            'g',
            activate(hunks_jumper),
            { exit = true, private = true, desc = 'git hunks' },
          },
          {
            't',
            activate(treesitter_jumper),
            { exit = true, private = true, desc = 'treesitter' },
          },
          { '<Esc>', nil, { exit = true, desc = 'exit' } },
        },
      })

      -- Scroll hydra (kept from previous config)
      local scroll_up = function()
        vim.api.nvim_feedkeys(
          vim.api.nvim_replace_termcodes('<c-y>', true, false, true),
          'n',
          true
        )
      end

      local scroll_down = function()
        vim.api.nvim_feedkeys(
          vim.api.nvim_replace_termcodes('<c-e>', true, false, true),
          'n',
          true
        )
      end

      local scroll_right = function()
        vim.cmd('normal zl')
      end

      local scroll_left = function()
        vim.cmd('normal zh')
      end

      hydra({
        name = 'Scroll',
        config = {
          invoke_on_body = true,
          hint = false,
          on_enter = function() end,
        },
        mode = 'n',
        body = '<space>zs',
        heads = {
          {
            'j',
            function()
              scroll_down()
            end,
          },
          {
            '<down>',
            function()
              scroll_down()
            end,
          },
          {
            'k',
            function()
              scroll_up()
            end,
          },
          {
            '<up>',
            function()
              scroll_up()
            end,
          },
          {
            'h',
            function()
              scroll_left()
            end,
          },
          {
            '<left>',
            function()
              scroll_left()
            end,
          },
          {
            'l',
            function()
              scroll_right()
            end,
          },
          {
            '<right>',
            function()
              scroll_right()
            end,
          },
        },
      })
    end,
  },
}
