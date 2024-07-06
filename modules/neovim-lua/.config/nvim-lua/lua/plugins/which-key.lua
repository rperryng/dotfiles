return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {},
  triggers_nowait = {
    -- marks
    "`",
    "'",
    "g`",
    "g'",
    -- spelling
    "z=",

    -- Remove nowait for registers
    -- '"',
    -- "<c-r>",
  },
}
