return {
  {
    'stevearc/oil.nvim',
    config = function()
      require('oil').setup()
      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
    end,
  },
}
