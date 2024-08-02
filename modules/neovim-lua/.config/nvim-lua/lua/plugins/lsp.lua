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

          opts = { buffer = event.buf }

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
          -- Enter key confirms completion item
          ['<CR>'] = cmp.mapping.confirm({ select = false }),

          ['<C-Space>'] = cmp.mapping.complete(),
        }),
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
      })

      -- cmp.setup.cmdline({ '/', '?' }, {
      --   mapping = cmp.mapping.preset.cmdline(),
      --   sources = {
      --     { name = 'buffer' },
      --   },
      -- })
    end,
  },
  {
    'ray-x/lsp_signature.nvim',
    opts = {},
    config = function(_, opts)
      require('lsp_signature').setup(opts)
    end,
  },
}
