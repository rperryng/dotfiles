vim.on_key(function(char)
  if vim.fn.mode() == 'n' then
    local new_hlsearch = vim.tbl_contains(
      { '<CR>', 'n', 'N', '*', '#', '?', '/' },
      vim.fn.keytrans(char)
    )

    -- Don't turn off hlsearch automatically
    -- Use <esc> mapping to turn it off
    if new_hlsearch == false then
      return
    end

    if vim.opt.hlsearch:get() ~= true then
      vim.opt.hlsearch = true
    end
  end
end, vim.api.nvim_create_namespace('auto_hlsearch'))
