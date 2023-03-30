-- Misc
vim.opt.timeout = true
vim.opt.timeoutlen = 500
vim.opt.mouse = 'a'

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

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = 'split'

if (vim.fn.executable('rg')) then
  vim.opt.grepprg='rg --vimgrep'
  vim.opt.grepformat:prepend{"%f:%l:%c:%m"}
end
