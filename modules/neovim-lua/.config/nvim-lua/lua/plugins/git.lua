return {
  {
    'airblade/vim-gitgutter',
    init = function()
      vim.g.gitgutter_map_keys = 0
    end,
    config = function()
      vim.cmd([[
        highlight! link GitGutterAdd GruvboxGreenSign
      ]])

      -- Hunk Navigation
      vim.keymap.set(
        'n',
        '<space>gqg',
        ':GitGutterQuickFix | copen | cfirst<cr>',
        { desc = 'Load git hunks into quickfix list' }
      )
      vim.keymap.set(
        'n',
        ']g',
        '<Plug>(GitGutterNextHunk)',
        { desc = 'Next git hunk', noremap = false }
      )
      vim.keymap.set(
        'n',
        '[g',
        '<Plug>(GitGutterPrevHunk)',
        { desc = 'Next git hunk', noremap = false }
      )

      -- Hunk Operations
      vim.keymap.set(
        'n',
        '<space>ghp',
        ':GitGutterPreviewHunk<cr>',
        { desc = 'Preview git diff hunk' }
      )
      vim.keymap.set(
        'n',
        '<space>ghu',
        ':GitGutterUndoHunk<cr>',
        { desc = 'Undo git diff hunk' }
      )

      -- Text objects
      vim.keymap.set(
        'o',
        'igh',
        '<Plug>(GitGutterTextObjectInnerPending)',
        { desc = 'Git hunk inner' }
      )
      vim.keymap.set(
        'o',
        'agh',
        '<Plug>(GitGutterTextObjectOuterPending)',
        { desc = 'Git hunk inner' }
      )
      vim.keymap.set(
        'x',
        'igh',
        '<Plug>(GitGutterTextObjectInnerVisual)',
        { desc = 'Git hunk inner' }
      )
      vim.keymap.set(
        'x',
        'agh',
        '<Plug>(GitGutterTextObjectOuterVisual)',
        { desc = 'Git hunk inner' }
      )
    end,
  },
}
