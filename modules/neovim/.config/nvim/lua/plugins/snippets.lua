return {
  {
    'L3MON4D3/LuaSnip',
    dependencies = { 'rafamadriz/friendly-snippets' },
    config = function()
      local luasnip = require('luasnip')

      luasnip.filetype_extend('ruby', { 'rails' })
      luasnip.filetype_extend('typescript', { 'javascript', 'tsdoc' })

      require('luasnip.loaders.from_vscode').lazy_load()
      -- require('luasnip.loaders.from_snipmate').lazy_load()
      -- require('luasnip.loaders.from_lua').lazy_load()
    end,
  },
}
