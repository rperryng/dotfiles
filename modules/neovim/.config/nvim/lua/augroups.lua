local focusgroup = vim.api.nvim_create_augroup("focusGroup", { clear = true })

-- Automatically re-read file on re-entry
vim.api.nvim_create_autocmd(
  { "FocusGained", "BufEnter" },
  { pattern = "*", command = "silent! checkt", group = focusGroup }
)

