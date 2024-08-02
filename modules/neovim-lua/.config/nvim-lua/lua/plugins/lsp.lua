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
      -- LSP-like features that don't actually require a running language server
      vim.keymap.set('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')
      -- Default in nvim 0.10x
      -- vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
      -- vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')

      -- LSP bindings (buffer-local)
      vim.api.nvim_create_autocmd('LspAttach', {
        desc = 'LSP actions',
        callback = function(event)
          local opts = { buffer = event.buf }

          -- these will be buffer-local keybindings
          -- because they only work if you have an active language server
          vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)

          vim.keymap.set(
            'n',
            '<space>gd',
            '<cmd>lua vim.lsp.buf.definition()<cr>',
            opts
          )
          vim.keymap.set(
            'n',
            '<space>gD',
            '<cmd>lua vim.lsp.buf.declaration()<cr>',
            opts
          )
          vim.keymap.set(
            'n',
            '<space>gi',
            '<cmd>lua vim.lsp.buf.implementation()<cr>',
            opts
          )
          vim.keymap.set(
            'n',
            '<space>go',
            '<cmd>lua vim.lsp.buf.type_definition()<cr>',
            opts
          )
          vim.keymap.set(
            'n',
            '<space>gr',
            '<cmd>lua vim.lsp.buf.references()<cr>',
            opts
          )
          vim.keymap.set(
            'n',
            '<space>gs',
            '<cmd>lua vim.lsp.buf.signature_help()<cr>',
            opts
          )
          vim.keymap.set(
            'n',
            '<space>gre',
            '<cmd>lua vim.lsp.buf.rename()<cr>',
            opts
          )
          vim.keymap.set(
            'n',
            '<space>gf',
            '<cmd>lua vim.lsp.buf.format({async = true})<cr>',
            opts
          )
          vim.keymap.set(
            'n',
            '<space>gA',
            '<cmd>lua vim.lsp.buf.code_action()<cr>',
            opts
          )
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
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
  { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
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
}
