-- {{{ lsp
-- require(vim.env.DOTFILES_SOURCE .. 'nvim/lsp.lua')
-- }}}
-- {{{ TreeSitter
do
  require('nvim-treesitter')
  require('nvim-treesitter.configs').setup {
    ensure_installed = "maintained",
    highlight = {
      enable = true,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "gnn",
        node_incremental = "grn",
        scope_incremental = "grc",
        node_decremental = "grm",
      },
    },
  }
end
-- }}}
-- {{{ Diffview
do
  local cb = require('diffview.config').diffview_callback
  require('diffview').setup {
    diff_binaries = false,    -- Show diffs for binaries
    use_icons = false,         -- Requires nvim-web-devicons
    file_panel = {
      width = 35,
    },
    key_bindings = {
      -- The `view` bindings are active in the diff buffers, only when the current
      -- tabpage is a Diffview.
      view = {
        ["<tab>"]    = cb("select_next_entry"),  -- Open the diff for the next file
        ["<s-tab>"]  = cb("select_prev_entry"),  -- Open the diff for the previous file
        ["<space>"]  = cb("focus_files"),        -- Bring focus to the files panel
        ["<space>b"] = cb("toggle_files"),       -- Toggle the files panel.
      },
      file_panel = {
        ["j"]        = cb("next_entry"),         -- Bring the cursor to the next file entry
        ["k"]        = cb("prev_entry"),         -- Bring the cursor to the previous file entry.
        ["<cr>"]     = cb("select_entry"),       -- Open the diff for the selected entry.
        ["o"]        = cb("select_entry"),
        ["R"]        = cb("refresh_files"),      -- Update stats and entries in the file list.
        ["<tab>"]    = cb("select_next_entry"),
        ["<s-tab>"]  = cb("select_prev_entry"),
        ["<space>e"] = cb("focus_files"),
        ["<space>b"] = cb("toggle_files"),
      }
    }
  }
end
-- }}}
-- {{{ tabout
do
  require('tabout').setup {
    tabkey = '<Tab>', -- key to trigger tabout, set to an empty string to disable
    backwards_tabkey = '<S-Tab>', -- key to trigger backwards tabout, set to an empty string to disable
    act_as_tab = true, -- shift content if tab out is not possible
    act_as_shift_tab = false, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
    enable_backwards = true, -- well ...
    completion = true, -- if the tabkey is used in a completion pum
    tabouts = {
      {open = "'", close = "'"},
      {open = '"', close = '"'},
      {open = '`', close = '`'},
      {open = '(', close = ')'},
      {open = '[', close = ']'},
      {open = '{', close = '}'}
    },
    ignore_beginning = true, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
    exclude = {} -- tabout will ignore these filetypes
  }
end
-- }}}
