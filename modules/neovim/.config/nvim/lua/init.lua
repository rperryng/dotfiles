-- {{{ TreeSitter
-- do
--   require('nvim-treesitter')
--   require('nvim-treesitter.configs').setup {
--     ensure_installed = "all",
--     highlight = {
--       enable = true,
--     },
--     incremental_selection = {
--       enable = true,
--       keymaps = {
--         init_selection = "gnn",
--         node_incremental = "grn",
--         scope_incremental = "grc",
--         node_decremental = "grm",
--       },
--     },
--   }
-- end
-- }}}
-- {{{ Diffview
do
  local cb = require('diffview.config').diffview_callback
  require('diffview').setup {
    diff_binaries = false,    -- Show diffs for binaries
    use_icons = false,         -- Requires nvim-web-devicons
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
-- {{{ CopilotChat
do
  require("CopilotChat").setup {
    -- debug = true, -- Enable debugging
    -- See Configuration section for rest
  }
end
-- }}}
