local utils = require('utils')

return {
  -- LSP Config
  {
    'williamboman/mason.nvim',
    config = function()
      require('mason').setup()
    end,
  },
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = {
      'williamboman/mason.nvim',
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
      local default_setup = function(server)
        require('lspconfig')[server].setup({
          capabilities = lsp_capabilities,
        })
      end

      require('mason-lspconfig').setup({
        ensure_installed = {
          'lua_ls',
          'tsserver',
          'denols',
          'bashls',
          -- 'ruby_lsp',
        },
        handlers = {
          default_setup,
        },
      })

      -- Disable tsserver in deno files
      local lsp_util = require('local.lsp-util')
      if lsp_util.get_config('denols') and lsp_util.get_config('tsserver') then
        local is_deno =
          require('lspconfig.util').root_pattern('deno.json', 'deno.jsonc')
        lsp_util.disable('tsserver', is_deno)
        lsp_util.disable('denols', function(root_dir)
          return not is_deno(root_dir)
        end)
      end
    end,
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim' },
    },
    config = function()
      vim.diagnostic.config({ virtual_text = false })

      -- LSP-like features that don't actually require a running language server
      vim.keymap.set(
        'n',
        'gl',
        '<cmd>lua vim.diagnostic.open_float()<cr>',
        { desc = 'View diagnostic under cursor' }
      )

      -- Default in nvim 0.10x
      -- vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
      -- vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')

      -- LSP bindings (buffer-local)
      vim.api.nvim_create_autocmd('LspAttach', {
        desc = 'LSP actions',
        callback = function(event)
          local keymap = function(mode, lhs, rhs, opts)
            opts = utils.table.deep_copy(opts)
            opts.buffer = event.buf
            vim.keymap.set(mode, lhs, rhs, opts)
          end

          keymap(
            'n',
            'K',
            '<cmd>lua vim.lsp.buf.hover()<cr>',
            { desc = 'Show LSP Hover' }
          )

          keymap(
            'n',
            '<space>gd',
            '<cmd>lua vim.lsp.buf.definition()<cr>',
            { desc = 'Go to definition' }
          )
          keymap(
            'n',
            '<space>gD',
            '<cmd>lua vim.lsp.buf.declaration()<cr>',
            { desc = 'Go to declaration' }
          )
          keymap(
            'n',
            '<space>go',
            '<cmd>lua vim.lsp.buf.type_definition()<cr>',
            { desc = 'Go to type definition' }
          )
          keymap(
            'n',
            '<space>gr',
            '<cmd>lua vim.lsp.buf.references()<cr>',
            { desc = 'Go to references' }
          )
          keymap(
            'n',
            '<space>gi',
            '<cmd>lua vim.lsp.buf.implementation()<cr>',
            { desc = 'Go to implementations' }
          )
          keymap(
            'n',
            '<space>gre',
            '<cmd>lua vim.lsp.buf.rename()<cr>',
            { desc = 'Rename (via LSP)' }
          )
          keymap(
            'n',
            '<space>gf',
            '<cmd>lua vim.lsp.buf.format({async = true})<cr>',
            { desc = 'Format (via LSP)' }
          )
          keymap(
            'n',
            '<space>gA',
            '<cmd>lua vim.lsp.buf.code_action()<cr>',
            { desc = 'Show Code Actions' }
          )

          keymap('n', '<space>gs', function()
            vim.diagnostic.enable(
              not vim.diagnostic.is_enabled({ bufnr = event.buf }),
              { bufnr = event.buf }
            )
          end, { desc = 'Toggle diagnostics' })
        end,
      })
    end,
  },

  -- Completion
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/cmp-buffer' },
  { 'hrsh7th/cmp-path' },
  { 'hrsh7th/cmp-cmdline' },
  { 'L3MON4D3/LuaSnip' },
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      },
    },
  },
  { 'Bilal2453/luvit-meta', lazy = true }, -- optional `vim.uv` typings
  {
    'hrsh7th/nvim-cmp',
    dependencies = { 'onsails/lspkind.nvim', 'nvim-web-devicons' },
    config = function()
      local cmp = require('cmp')
      cmp.setup({
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
          { name = 'lazydev' },
        }),

        mapping = cmp.mapping.preset.insert({
          ['<cr>'] = cmp.mapping.confirm({ select = false }),
          ['<c-space>'] = cmp.mapping.complete(),

          -- Tab always selects the first entry if none is already selected
          ['<tab>'] = cmp.mapping.confirm({ select = true }),
        }),

        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },

        formatting = {
          format = function(entry, vim_item)
            if vim.tbl_contains({ 'path' }, entry.source.name) then
              local icon, hl_group = require('nvim-web-devicons').get_icon(
                entry:get_completion_item().label
              )
              if icon then
                vim_item.kind = icon
                vim_item.kind_hl_group = hl_group
                return vim_item
              end
            end
            return require('lspkind').cmp_format({
              mode = 'symbol_text',
              with_text = false
            })(
              entry,
              vim_item
            )
          end,
        },
      })
    end,
  },
  {
    'ray-x/lsp_signature.nvim',
    config = function()
      require('lsp_signature').setup({
        toggle_key = '<c-k>',
        toggle_key_flip_floatwin_setting = true,
        hint_enable = false,
        floating_window_above_cur_line = true,
        always_trigger = false,
      })
    end,
  },

  {
    'hedyhli/outline.nvim',
    config = function()
      -- Example mapping to toggle outline
      vim.keymap.set(
        'n',
        '<space>o',
        '<cmd>Outline<CR>',
        { desc = 'Toggle Outline' }
      )

      require('outline').setup({})
    end,
  },
  {
    'folke/trouble.nvim',
    config = function()
      require('trouble').setup({
        warn_no_results = false,
        open_no_results = true,
      })

      vim.keymap.set(
        'n',
        '<space>xX',
        '<cmd>Trouble diagnostics toggle<cr>',
        { desc = 'Diagnostics (Trouble)' }
      )
      vim.keymap.set(
        'n',
        '<space>xx',
        '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
        { desc = 'Buffer Diagnostics (Trouble)' }
      )
      vim.keymap.set(
        'n',
        '<space>cs',
        '<cmd>Trouble symbols toggle focus=false<cr>',
        { desc = 'Symbols (Trouble)' }
      )
      vim.keymap.set(
        'n',
        '<space>cl',
        '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
        { desc = 'LSP Definitions / references / ... (Trouble)' }
      )
      vim.keymap.set(
        'n',
        '<space>xL',
        '<cmd>Trouble loclist toggle<cr>',
        { desc = 'Location List (Trouble)' }
      )
      vim.keymap.set(
        'n',
        '<space>xQ',
        '<cmd>Trouble qflist toggle<cr>',
        { desc = 'Quickfix List (Trouble)' }
      )
    end,
  },
}
