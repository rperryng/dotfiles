return {
  'Almo7aya/openingh.nvim',
  init = function()
    -- Needs to be set before plugin is loaded
    vim.g.openingh_copy_to_register = true
  end,
  config = function()
    vim.keymap.set(
      'n',
      '<space>oghr',
      ':OpenInGHRepo<cr>',
      {silent = true, noremap = true, desc = 'Open GitHub repo',}
    )

    vim.keymap.set('n', '<space>oghf', ':OpenInGHFile<cr>', {
      silent = true,
      noremap = true,
      desc = 'Open file on GitHub',
    })

    vim.keymap.set('v', '<space>oghf', ':OpenInGHFileLines<cr>', {
      silent = true,
      noremap = true,
      desc = 'Open file and lines on GitHub',
    })

    vim.keymap.set('v', '<space>ygh', ':OpenInGHFileLines! +<cr>', {
      silent = true,
      noremap = true,
      desc = 'Yank GitHub link to system clipboard',
    })
  end,
}
