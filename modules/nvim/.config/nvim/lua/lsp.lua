-- {{{ null-ls
-- Must be run before 'lspconfig'
do
  local null_ls = require('null-ls')
  local sources = {
    null_ls.builtins.formatting.eslint_d,
    null_ls.builtins.formatting.fixjson,
    null_ls.builtins.diagnostics.eslint_d,
    null_ls.builtins.diagnostics.pylint,
    null_ls.builtins.diagnostics.yamllint,
  }
  null_ls.config({ sources = sources })
end
-- }}}
-- {{{ lspconfig
do
  local lspconfig = require('lspconfig')
  local lsp_signature = require "lsp_signature"
  local saga = require('lspsaga')
  local null_ls = require("null-ls")

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  saga.init_lsp_saga()

  function bufmap(buffer, mode, lhs, rhs)
    options = { noremap = true, silent = true }
    vim.api.nvim_buf_set_keymap(buffer, mode, lhs, rhs, options)
  end

  local set_bindings = function(client, buffer)
    vim.api.nvim_buf_set_option(buffer, "omnifunc", "v:lua.vim.lsp.omnifunc")

    bufmap(buffer, "n", "<space>A", ":Lspsaga code_action<CR>")
    bufmap(buffer, "v", "<space>A", ":<C-u>Lspsaga range_code_action<CR>")
    bufmap(buffer, "n", "<space>F", "<cmd>lua vim.lsp.buf.formatting()<CR>")
    bufmap(buffer, "n", "<space>gD", "<cmd>lua vim.lsp.buf.implementation()<CR>")
    bufmap(buffer, "n", "<space>re", ":Lspsaga rename<CR>")
    bufmap(buffer, "n", "K", ":Lspsaga hover_doc<CR>")
    bufmap(buffer, "i", "<c-k>", "<C-O>:Lspsaga hover_doc<CR>")
    bufmap(buffer, "n", "gk", ":Lspsaga show_line_diagnostics<CR>")
    bufmap(buffer, "n", "gp", ":Lspsaga diagnostic_jump_prev<CR>")
    bufmap(buffer, "n", "gn", ":Lspsaga diagnostic_jump_next<CR>")
    bufmap(buffer, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
    bufmap(buffer, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
    bufmap(buffer, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
    bufmap(buffer, "n", "gy", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
    bufmap(buffer, "n", "<space>gd", ":Lspsaga preview_definition<CR>")
  end

  local custom_on_attach = function(client, buffer)
    set_bindings(client, buffer)
    lsp_signature.on_attach()
  end

  require('lspconfig').tsserver.setup({
    on_attach = custom_on_attach,
    capabilities = capabilities,
  })

  require('lspconfig').solargraph.setup({
    on_attach = custom_on_attach,
    capabilities = capabilities,
  })

  require('lspconfig').rust_analyzer.setup({
    on_attach = custom_on_attach,
    capabilities = capabilities,
  })

  require("lspconfig")["null-ls"].setup({
    on_attach = custom_on_attach,
    capabilities = capabilities,
  })

  -- You will likely want to reduce updatetime which affects CursorHold
  -- note: this setting is global and should be set only once

  vim.diagnostic.config({
    float = {
      source = 'always',
      border = border,
    },
    virtual_text = false,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = false,
  })
end
-- }}}
-- {{{ nvim-lsp

-- }}}
-- {{{ nvim-cmp
do
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

  local cmp = require('cmp')
  cmp.setup {
    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      end,
    },
    mapping = {
      ['<C-p>'] = cmp.mapping.select_prev_item(),
      ['<C-n>'] = cmp.mapping.select_next_item(),
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<ESC>'] = cmp.mapping.close(),
      ['<C-s>'] = cmp.mapping.close(),
      ['<CR>'] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      },
      ['<Tab>'] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      },
    },
    sources = {
      { name = 'nvim_lsp' },
      { name = 'buffer' },
      { name = 'path' },
      { name = 'buffer' },
    },
  }
end
-- }}}
