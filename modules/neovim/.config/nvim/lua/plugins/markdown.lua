return {
  {
    'MeanderingProgrammer/markdown.nvim',
    -- main = 'render-markdown',
    config = function()
      require('render-markdown').setup({
        enabled = false,
      })

      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'markdown',
        callback = function()
          vim.api.nvim_buf_set_keymap(
            0,
            'n',
            '<space>mt',
            ':RenderMarkdown toggle<cr>',
            { noremap = true, silent = true }
          )
        end,
      })
    end,
    name = 'render-markdown', -- Only needed if you have another plugin named markdown.nvim
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    }, -- if you prefer nvim-web-devicons
  },
}
