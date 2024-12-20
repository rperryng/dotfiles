-- Mouse
vim.opt.mouse = 'a'

-- Timeout
vim.opt.timeout = true
vim.opt.timeoutlen = 500

-- :)
vim.opt.swapfile = false

-- Folds?
vim.opt.foldopen = 'hor,mark,percent,quickfix,search,tag,undo'
vim.opt.foldmethod = 'marker'

-- Spaces & Tabs
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.breakindent = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.tabstop = 2

-- Wildmenu
vim.opt.wildmode = 'list:longest'
vim.opt.wildignorecase = true

-- UI
vim.opt.list = true
vim.opt.lazyredraw = true
vim.opt.wrap = false
vim.opt.signcolumn = 'yes'
vim.opt.equalalways = false
vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 0
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.number = true
vim.opt.showtabline = 2
vim.opt.updatetime = 200
vim.opt.pumheight = 20

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = 'split'

if vim.fn.executable('rg') then
  vim.opt.grepprg = 'rg --vimgrep'
  vim.opt.grepformat:prepend({ '%f:%l:%c:%m' })
end

if vim.fn.has('wsl') == 1 then
  vim.g.clipboard = {
    name = 'WslClipboard',
    copy = {
      ['+'] = 'clip.exe',
      ['*'] = 'clip.exe',
    },
    paste = {
      ['+'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      ['*'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cache_enabled = 0,
  }
end
