"  avoid code execution vulnerability
set nomodeline

let mapleader="\<Space>"

" {{{ misc startup
function! s:warn(message)
  echohl WarningMsg
  echom a:message
  echohl None
  return 0
endfunction
" }}}
"{{{ Plugins

" {{{ vim-plug snapshot
let g:vim_plug_snapshot_path=expand('$XDG_CONFIG_HOME').'/nvim/.vim_plug_snapshot'

function! LoadVimPlugSnapshot()
  if !filereadable(g:vim_plug_snapshot_path)
    echoerr "Vim plug snapshot '".g:vim_plug_snapshot_path."' does not exist"
    return
  endif

  execute 'source '.g:vim_plug_snapshot_path
endfunction
command! LoadVimPlugSnapshot call LoadVimPlugSnapshot()

function! UpdatePlugSnapshot()
  execute ':PlugSnapshot! '.g:vim_plug_snapshot_path
endfunction

command! UpdatePlugSnapshot call UpdatePlugSnapshot()
" }}}

call plug#begin('~/.local/share/nvim/plugged')

" :CocInstall coc-snippets
" :CocInstall coc-rust-analyzer
" :CocInstall coc-tsserver
" :CocInstall coc-solargraph
" :CocInstall coc-kotlin
" :CocInstall coc-java
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" LSP
" Plug 'folke/trouble.nvim'
" Plug 'hrsh7th/cmp-nvim-lsp'
" Plug 'hrsh7th/cmp-vsnip'
" Plug 'hrsh7th/cmp-path'
" Plug 'hrsh7th/cmp-buffer'
" Plug 'hrsh7th/nvim-cmp'
" Plug 'hrsh7th/vim-vsnip'
" Plug 'jose-elias-alvarez/null-ls.nvim'
" Plug 'neovim/nvim-lspconfig'
" Plug 'nvim-lua/popup.nvim'
" Plug 'ray-x/lsp_signature.nvim'
" Plug 'simrat39/rust-tools.nvim'
" Plug 'tami5/lspsaga.nvim'
" Plug 'MunifTanjim/nui.nvim'

" Functionality
" Plug 'michal-h21/vim-zettel'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'Julian/vim-textobj-variable-segment'
Plug 'KKPMW/vim-sendtowindow'
Plug 'Matt-A-Bennett/surround-funk.vim'
Plug 'MattesGroeger/vim-bookmarks'
Plug 'NoahTheDuke/vim-just'
Plug 'abecodes/tabout.nvim'
Plug 'alvan/vim-closetag'
Plug 'arthurxavierx/vim-caser'
Plug 'christoomey/vim-tmux-navigator'
Plug 'dbakker/vim-projectroot'
Plug 'editorconfig/editorconfig-vim'
Plug 'gcmt/taboo.vim'
Plug 'gisphm/vim-gitignore'
Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
Plug 'habamax/vim-winlayout'
Plug 'haya14busa/incsearch-fuzzy.vim'
Plug 'haya14busa/incsearch.vim'
Plug 'iamcco/vim-language-server'
Plug 'inkarkat/vim-AdvancedSorters'
Plug 'inkarkat/vim-ingo-library'
Plug 'janko-m/vim-test'
Plug 'jeetsukumaran/vim-indentwise'
Plug 'jesseleite/vim-agriculture'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/fzf', { 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/gv.vim'
Plug 'junegunn/vader.vim'
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/vim-peekaboo'
Plug 'kana/vim-textobj-user'
Plug 'kassio/neoterm'
Plug 'ludovicchabant/vim-gutentags'
Plug 'machakann/vim-swap'
Plug 'mcchrish/nnn.vim'
Plug 'michaeljsmith/vim-indent-object'
Plug 'moll/vim-bbye'
Plug 'nelstrom/vim-textobj-rubyblock'
Plug 'nvim-lua/plenary.nvim'
Plug 'pbogut/fzf-mru.vim'
Plug 'prettier/vim-prettier'
Plug 'puremourning/vimspector'
Plug 'rperryng/nvim-contabs'
Plug 'segeljakt/vim-isotope'
Plug 'simeji/winresizer'
Plug 'sindrets/diffview.nvim'
Plug 'sjl/gundo.vim'
Plug 'tamton-aquib/duck.nvim'
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-rake'
Plug 'tpope/vim-rbenv'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-scriptease'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vim-ruby/vim-ruby'
Plug 'vimwiki/vimwiki'
Plug 'vmchale/just-vim'
Plug 'wellle/targets.vim'
Plug 'wsdjeg/vim-fetch'

" Copilot
Plug 'zbirenbaum/copilot.lua'
Plug 'CopilotC-Nvim/CopilotChat.nvim', { 'branch': 'canary' }

" Plug 'github/copilot.vim'
" Plug 'Olical/aniseed'
" Plug 'Olical/conjure'

" To show tree style views for coworkers not used to buffer based workflows
Plug 'preservim/nerdtree'

" UI
Plug 'arzg/seoul8'
Plug 'jjo/vim-cue'
Plug 'chriskempson/base16-vim'
Plug 'drewtempelmeyer/palenight.vim'
Plug 'folke/lsp-colors.nvim', { 'branch': 'main' }
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
Plug 'folke/zen-mode.nvim', { 'branch': 'main' }
Plug 'hashivim/vim-terraform'
Plug 'haya14busa/vim-asterisk'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install' }
Plug 'joshdick/onedark.vim'
Plug 'jparise/vim-graphql'
Plug 'junegunn/seoul256.vim'
Plug 'junegunn/vim-journal'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'machakann/vim-highlightedyank'
Plug 'mhinz/vim-signify'
Plug 'patstockwell/vim-monokai-tasty'
Plug 'qxxxb/vim-searchhi'
Plug 'rakr/vim-one'
Plug 'rebelot/kanagawa.nvim'
Plug 'rust-lang/rust.vim'
Plug 'udalov/kotlin-vim'
Plug 'webdevel/tabulous'
Plug 'wlangstroth/vim-racket'

" Plug 'morhetz/gruvbox'
Plug 'ellisonleao/gruvbox.nvim'

" Requires lush
" Need to figure out terminal green color messed up
" Plug 'rktjmp/lush.nvim'
" Plug 'npxbr/gruvbox.nvim'

" Plug 'andymass/vim-matchup'
" Load last, as required in the README
" Plug 'ryanoasis/vim-devicons'

" 'Maybe' pile
" Plug 'TaDaa/vimade'
" Plug 'romainl/vim-cool'
" Plug 'itchyny/lightline.vim'
" Plug 'vim-airline/vim-airline'
" Plug 'vim-airline/vim-airline-themes'
" Plug 'christoomey/vim-tmux-navigator'

call plug#end()
" }}}
" {{{ Host programs
" ===========
" https://github.com/deoplete-plugins/deoplete-jedi/wiki/Setting-up-Python-for-Neovim

function! GetRuntimeVersion(runtime)
    let tool_versions_file = $HOME.'/.config/asdf/tool-versions'
    let runtime_pattern = '\v^'.a:runtime.'\s+\zs\d+\.\d+\.\d+'

    let file = readfile(tool_versions_file)
    for line in file
        let l:version = matchstr(line, runtime_pattern)
        if !empty(l:version)
            return l:version
        endif
    endfor

    return 'Runtime not found'
endfunction

" Python
if isdirectory($XDG_OPT_HOME.'/nvim/virtualenvs/neovim3')
  let g:python3_host_prog=$XDG_OPT_HOME.'/nvim/virtualenvs/neovim3/bin/python'
else
  echom "No python 3 host set."
endif

" Ruby
if executable('asdf')
  let ruby_version = GetRuntimeVersion('ruby')
  let ruby_path = trim(system('asdf where ruby '.ruby_version))
  let g:ruby_host_prog = ruby_path.'/bin/ruby'
else
  echom "No ruby host set."
endif

" Node
if executable('asdf')
  let yarn_global_dir = trim(system('yarn global dir'))
  let g:node_host_prog = yarn_global_dir.'/node_modules/neovim/bin/cli.js'

  let nodejs_version = GetRuntimeVersion('nodejs')
  let nodejs_path = trim(system('asdf where nodejs '.nodejs_version))

  " TODO: This should point to the project node version? :thinking:
  let g:coc_node_path = nodejs_path.'/bin/node'
else
  echom "No node host set."
endif

" }}}
" {{{ OS Specific Settings

" {{{ WSL 2 (Windows 10)
function IsWsl()
  let l:version_file_path = '/proc/version'
  return filereadable(l:version_file_path) && system('cat /proc/version') =~ 'Microsoft'
endfunction

if IsWsl()
  inoremap <c-v> <c-r>+
  tmap <c-v> <c-\><c-r>+

  if len(trim(system('command -v win32yank.exe'))) == 0
    call s:warn("Detected WSL environment but 'win32yank.exe' not on $PATH.  No clipboard support.")
  else
    let g:clipboard = {
          \ 'name': 'wsl2-clipboard',
          \   'copy': {
          \      '+': 'win32yank.exe -i --crlf',
          \      '*': 'win32yank.exe -i --crlf',
          \    },
          \   'paste': {
          \      '+': 'win32yank.exe -o --lf',
          \      '*': 'win32yank.exe -o --lf',
          \   },
          \   'cache_enabled': 0,
          \ }
  endif
endif
" }}}

" }}}
" {{{ Autocmd

augroup focusgroup
  autocmd!
  " Preserve cursor location when switching buffers
  " autocmd BufLeave * let b:winview = winsaveview()
  " autocmd BufEnter * if(exists('b:winview')) | call winrestview(b:winview) | endif
  autocmd FocusGained,BufEnter * :silent! checkt
augroup end

augroup filetypes
  autocmd!
  autocmd BufNewFile,BufReadPost *.md set filetype=markdown
  autocmd BufNewFile,BufReadPost *.jshintrc set filetype=javascript
  autocmd BufNewFile,BufReadPost *.zshrc set filetype=zsh
  autocmd BufNewFile,BufReadPost *.org set filetype=org
  autocmd BufNewFile,BufReadPost *.journal set filetype=journal

  autocmd FileType vim,markdown,json setlocal conceallevel=0

  autocmd FileType netrw setlocal nosmartindent shiftwidth=4 tabstop=4 softtabstop=4
  autocmd FileType python setlocal nosmartindent
  autocmd FileType ruby setlocal colorcolumn=101
  autocmd FileType ruby setlocal textwidth=100
  autocmd FileType tsx setlocal commentstring=//\ %s
  autocmd FileType yaml setlocal commentstring=#\ %s
  autocmd FileType markdown setlocal textwidth=80

  " autocmd FileType typescript setlocal shiftwidth=4 tabstop=4 softtabstop=4
  autocmd FileType org setlocal shiftwidth=4 tabstop=4 softtabstop=4
  autocmd FileType rust setlocal shiftwidth=4 tabstop=4 softtabstop=4
  autocmd FileType typescript setlocal shiftwidth=2 tabstop=2 softtabstop=2
  autocmd FileType xml setlocal shiftwidth=4 tabstop=4 softtabstop=4
  autocmd Filetype yaml setlocal shiftwidth=2 tabstop=2 softtabstop=2

  autocmd FileType rust nnoremap <buffer> <space>fo :RustFmt<CR>
  autocmd FileType typescript nnoremap <buffer> <space>fo :Prettier<CR>
  autocmd FileType typescriptreact nnoremap <buffer> <space>fo :Prettier<CR>
  autocmd FileType typescriptreact nnoremap <buffer> <space>fo :Prettier<CR>

  " Help prevent accidentally modifying external source code resolved via
  " ctags or LSP functionality.
  autocmd BufReadPost */.cargo/*,*/.rustup/* setlocal readonly
augroup end

" Move to left tab when tab is closed
let s:prev_tab_count=tabpagenr('$')
let s:previous_tab_was_not_last_tab=1
function! s:tab_enter_autocmd_handler()
  let less_tabs_than_before = tabpagenr('$') < s:prev_tab_count
  let current_tab_is_not_first_tab = tabpagenr() != 1
  if less_tabs_than_before && current_tab_is_not_first_tab && s:previous_tab_was_not_last_tab
    tabprevious
  else
  endif
  let s:prev_tab_count=tabpagenr('$')
  let s:previous_tab_was_not_last_tab = tabpagenr() != tabpagenr('$')
endfunction

augroup TabClosedMoveLeft()
  autocmd!

  autocmd TabEnter * call s:tab_enter_autocmd_handler()
augroup end

augroup NeovimTerminal()
  autocmd!

  autocmd TermOpen * setlocal scrollback=50000
  autocmd TermOpen * setlocal nonumber
augroup end


function! s:enable_fzf_maps()
  tnoremap <buffer> <C-j> <down><down><down><down><down>
  tnoremap <buffer> <C-k> <up><up><up><up><up>
endfunction

augroup fzf_maps
  autocmd!

  autocmd TermOpen *fzf/bin/fzf* call s:enable_fzf_maps()
augroup end

" always open help in a vertical split

function! s:bufreadpost_help_buftype()
  if &buftype == 'help'
    wincmd L
    setlocal nonumber
  endif
endfunction

augroup vimrc_help
  autocmd!

  autocmd BufReadPost *.txt call s:bufreadpost_help_buftype()
augroup end

" }}}
" {{{ Colors

" Colors
if has('nvim')
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

if (has("termguicolors"))
  set termguicolors
endif

function! ApplyColorSchemeTweaks()
  if g:colorscheme ==# 'gruvbox'
    " highlight DiffAdd     gui=none guifg=none    guibg=#15420e
    " highlight DiffDelete  gui=none guifg=#4b0000 guibg=#4b0000
    " highlight DiffChange  gui=none guifg=none    guibg=#516c5b
    " highlight DiffText    gui=none guifg=none    guibg=#a7722c

    highlight DiffAdd guibg=#282828 ctermbg=235 guifg=#8ec07c ctermfg=142 cterm=NONE gui=NONE
    highlight DiffChange guibg=#282828 ctermbg=235 guifg=#fdba48 ctermfg=108 cterm=NONE gui=NONE
    highlight DiffDelete guibg=#282828 ctermbg=235 guifg=#fb4934 ctermfg=167 cterm=NONE gui=NONE

    highlight DiffAdd  guifg = none guibg=#4b5632
    highlight DiffText gui   = none guifg=none    guibg=#47330b
  endif
endfunction

nnoremap <space>hi :echo 
      \ "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
      \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
      \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

augroup init_colors
    autocmd!
    autocmd ColorScheme * call ApplyColorSchemeTweaks()
augroup END

let g:gruvbox_contrast_dark='hard'
let g:gruvbox_contrast_light='medium'
let g:tokyonight_style = 'storm'

let g:colorscheme = 'gruvbox'
" let g:colorscheme = 'kanagawa'
" let g:colorscheme = 'catppuccin'

" gruvbox-lua related setup
lua dofile(vim.env.XDG_CONFIG_HOME .. "/nvim/lua/colors.lua")

execute('colorscheme ' . g:colorscheme)
set background=dark

" hi normal guibg=NONE ctermbg=NONE
""" }}}
" {{{ Options

" Misc
set hidden
set noswapfile " ;)
set timeoutlen=500
set mouse=a
set foldopen-=block
set foldmethod=marker

" Spaces & tabs
set expandtab
set shiftwidth=2
set smartindent
set softtabstop=2
set tabstop=2

" UI
set lazyredraw
set colorcolumn=81
set synmaxcol=500
set signcolumn=yes
set scrolloff=5
set sidescrolloff=0
set showcmd
set splitbelow
set splitright
set wildmode=list:longest
set nowrap
set noequalalways
set showtabline=2
set number

set list
" set listchars=tab:>-,trail:~

" Statusline
" set statusline=
" set statusline+=%#PmenuSel#
" set statusline+=%#LineNr#
" set statusline+=\ %f
" set statusline+=%m\
" set statusline+=%=
" set statusline+=%#CursorColumn#
" set statusline+=\ %y
" set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
" set statusline+=\[%{&fileformat}\]
" set statusline+=\ %p%%
" set statusline+=\ %l:%c
" set statusline+=\ 

" Use one status line per window, make it show the cwd
function! StatusLineCwdName()
  return fnamemodify(getcwd(),':t')
endfunction

set laststatus=3
set statusline=
set statusline+=%#CursorLineNr#
set statusline+=%=(%{StatusLineCwdName()})%=

function! WinBarHighlightExpr()
  if win_getid() == g:actual_curwin
    return '%#StatusLine#'
  else
    return '%#StatusLineNC#'
  endif
endfunction

function! WinBarOutsideWorkingDirectory()
  let l:token = ''
  if win_getid() == g:actual_curwin
    l:token = '%#StatusLine#'
  else
    l:token '%#StatusLineNC#'
  endif

  let l:actual_bufname = getbufinfo(g:actual_curbuf)[0].name
  let l:actual_bufwd
endfunction

" Reset Winbar
set winbar=

" Set WinBar Highlight Group
set winbar+=%{%WinBarHighlightExpr()%}

" File name and buffer flags ([Help], [RO], [+] (modified) etc)
set winbar+=\ %f
set winbar+=\ %m
set winbar+=\ %h
set winbar+=\ %w
set winbar+=\ %q

" filetype set (e.g. [vim])
set winbar+=%=
set winbar+=%y
set winbar+=\ 

" highlight link StatusLineNC WinBarNC
" highlight link WinBarNC StatusLineNC

function! GetHighlightGroupUnderCursor()
  let id = synID(line('.'), col('.'), 1)
  echo synIDattr(id, 'name') . '; translated: ' . synIDattr(synIDtrans(id), 'name')
endfunction

nmap <space>ghl :call GetHighlightGroupUnderCursor()<CR>

" Show trailing whitespace with error highlighting group
" highlight! link Whitespace Error

" Searching
set ignorecase
set smartcase
set inccommand=split
" }}}
" {{{ Functions/Commands

" Redirect vim command into register
command! -nargs=+ -complete=command Redir let s:reg = @@ | redir @"> | silent execute <q-args> | redir END | new | pu | 1,2d_ | let @@ = s:reg

function! MatchStrAll(str, pat)
    let l:res = []
    call substitute(a:str, a:pat, '\=add(l:res, submatch(0))', 'g')
    return l:res
endfunction

" Eval vimscript contents
xnoremap <space>: y:@"<CR>

" Join lines and remove whitespace
" Like gJ, but always remove spaces
function! JoinSpaceless()
  execute 'normal gJ'

  " Character under cursor is whitespace?
  if matchstr(getline('.'), '\%' . col('.') . 'c.') =~ '\s'
    " When remove it!
    execute 'normal dw'
  endif
endfun

command! -nargs=0 JoinSpaceless call JoinSpaceless()
nnoremap <space>gJ :call JoinSpaceless()<CR>
xnoremap <space>gJ :call JoinSpaceless()<CR>

" Strip Whitespace
""""""""""""""""""
" TODO: work with ranges
command! StripWhitespace %s/\s\+$//e

" Change working directory using z.sh
"""""""""""""""""""""""""""""""""""""
function! ZLookup(z_arg, scope)
  let z_resolved_directory = system('. ~/code/tools/z/z.sh && _z -e ' . a:z_arg)
  if a:scope == 2
    execute 'lcd ' . z_resolved_directory
  elseif a:scope == 1
    execute 'tcd ' . z_resolved_directory
  else
    execute 'cd ' . z_resolved_directory
  endif

  " Strip empty newline so that command line doesn't grow when echoing
  let z_resolved_directory = substitute(z_resolved_directory, "\n", "", "")
  echo z_resolved_directory
endfunction

command! -nargs=1 Z call ZLookup(<q-args>, 0)
command! -nargs=1 TZ call ZLookup(<q-args>, 1)
command! -nargs=1 LZ call ZLookup(<q-args>, 2)

" Make bottom window occupy specific size and maintain window focus
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! TerminalResize()
  let currwin=winnr()
  execute winnr("$") . 'wincmd w'

  let new_size = min([20, &lines / 3])
  execute "resize" . new_size
  execute currwin . 'wincmd w'
endfunction

nnoremap <space>w= :silent call TerminalResize()<CR>

function! OpenAndSendCmdToProjectTerminal(cmd, ...)
  let l:append_enter = a:0 >= 1 ? a:1 : 1

  let l:project_name = fnamemodify(getcwd(), ':t')
  let l:current_buf_name = bufname()
  let l:terminal_buf_name = 'term-' . l:project_name
  let l:channel_id = -1
  let l:current_win = nvim_get_current_win()

  wincmd b
  if bufname() !~ "term-"
    botright split
    call TerminalResize()
  endif

  if !buflisted(l:terminal_buf_name)
    terminal
    execute 'keepalt file ' . l:terminal_buf_name
    call TerminalResize()
  elseif bufname() !~ l:terminal_buf_name
    execute 'edit ' . l:terminal_buf_name
  endif

  let l:cmd = l:append_enter ? a:cmd . "\<cr>" : a:cmd
  call chansend(b:terminal_job_id, l:cmd)
  normal G
  wincmd p
endfunction

function! ToggleProjectTerminal()
  let l:project_name = fnamemodify(getcwd(), ':t')
  let l:current_buf_name = bufname()
  let l:terminal_buf_name = 'term-' . l:project_name

  wincmd b
  if bufname() !~ "term-"
    botright split
    call TerminalResize()
  endif

  if !buflisted(l:terminal_buf_name)
    terminal
    execute 'keepalt file ' . l:terminal_buf_name
  elseif match(bufname(), '^'.l:terminal_buf_name.'$')
    execute 'edit ' . l:terminal_buf_name
  else
    quit
  endif
endfunction

command! -nargs=0 ToggleProjectTerminal call ToggleProjectTerminal()

function! RestartProjectTerminal()
  let l:project_name = fnamemodify(getcwd(), ':t')
  let l:current_buf_name = bufname()
  let l:terminal_buf_name = 'term-' . l:project_name

  wincmd b
  if bufname() !~ "term-"
    botright split
    call TerminalResize()
  endif

  if buflisted(l:terminal_buf_name)
    execute 'Bdelete! ' . l:terminal_buf_name
  endif

  terminal
  execute 'keepalt file ' . l:terminal_buf_name
endfunction

command! -nargs=0 RestartProjectTerminal call RestartProjectTerminal()

" Remove all buffers from other projects
function! ClearOtherBuffers()
  bdelete bdelete ~/code/<C-a>
endfunction

command! -nargs=0 ClearOtherBuffers call ClearOtherBuffers()

" Format JSON
"""""""""""""
command! FormatJson :%!jq .

function! CopyBufferContents()
  let l:current_pos = getpos(".")
  normal gg"+yG
  call setpos('.', l:current_pos)
endfunction
command! CopyBufferContents call CopyBufferContents()
nnoremap <space>Y :CopyBufferContents<CR>

" Profile Vim
function! ProfileStart()
profile start profile.log
profile func *
profile file *
echo "Do the slow thing, and then run :ProfileEnd().  Output will be saved to 'profile.log'"
endfunction
command! ProfileStart call ProfileStart()

function! ProfileEnd()
  profile pause
  noautocmd qall!
endfunction
command! ProfileEnd call ProfileEnd()

" Clear Terminal Scrollback history
"""""""""""""""""""""""""""""""""""
function! ClearScrollback()
let current_scrollback=&scrollback
setlocal scrollback=1
let &l:scrollback=current_scrollback
endfunction
command! ClearScrollback :call ClearScrollback()

" Insert todays date
""""""""""""""""""""

" Create an entry in my standup log, e.g.
" = Thursday - March 14 2019 =
" * asdf

function! Today()
  if expand('%:t') != 'Standup.wiki'
    split ~/vimwiki/Standup.wiki
  endif

  execute "normal! gg"
  let l:date_formatted = strftime('= %A - %B %d %Y =')

  if search(l:date_formatted) == 0
    execute "normal! G{{}"
    put! =strftime('= %A - %B %d %Y =')
    startinsert!
  elseif search(l:date_formatted . '\n\%(\*.*\)\{1,}\n$', 'e') != 0
    execute 'normal! G{{}O*\<Space>'
    startinsert!
  else
    execute "normal! zvj$"
    startinsert!
  endif
endfunction
command! Today :call Today()

function! PToday()
  put! =strftime('= %A - %B %d %Y =')
endfunction
command! PToday :call PToday()

function! Scratch()
  split ~/vimwiki/ruby_scratchpad.rb
  execute "normal! gg"
  let l:date_formatted = strftime('= %A - %B %d %Y =')

  if search(l:date_formatted) == 0
    execute "normal! Gzo{{}"
    put! =strftime('= %A - %B %d %Y =')
    execute "normal! o*\<Space>"
    startinsert!
  elseif search(l:date_formatted . '\n\%(\*.*\)\{1,}\n$', 'e') != 0
    execute "normal! Gzo{{}O*\<Space>"
    startinsert!
  else
    execute "normal! zvj$"
    startinsert!
  endif
  endfunction
command! Scratch :call Scratch()

function! GetVisualSelection()
  " Why is this not a built-in Vim script function?!
  let [line_start, column_start] = getpos("'<")[1:2]
  let [line_end, column_end] = getpos("'>")[1:2]
  let lines = getline(line_start, line_end)
  if len(lines) == 0
      return ''
  endif
  let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
  let lines[0] = lines[0][column_start - 1:]
  return join(lines, "\n")
endfunction

function! DeleteCwdBuffers()
  call feedkeys(":bdelete " . getcwd() . "\<C-\>\<C-a>\<CR>")
  " execute "bd " . getcwd() . ""
endfunction

command! DeleteCwdBuffers call DeleteCwdBuffers()
nnoremap <space>BD :DeleteCwdBuffers<CR>

function! NStart()
  edit $MYVIMRC
  vsplit
  execute 'edit'.expand("$XDG_CONFIG_HOME/nvim/lua/init.lua")
  cd $DOTFILES_DIR
  botright split
  terminal
  file term-.dotfiles
  call TerminalResize()
  TabooRename .dotfiles
endfunction

function! VimTestVimspectorStrategy(cmd)
  if !filereadable(".vimspector.json")
    echo "No '.vimspector.json' found, starting with vscode-node sample"
    call system('cp ~/.vimspector.json.sample ./.vimspector.json')
  endif

  let l:vimspector_config = json_decode(join(readfile('.vimspector.json')))

  " Assign program
  let l:program = split(a:cmd, ' ')[0]
  let l:vimspector_config['configurations']['run']['configuration']['program'] =
        \ '${workspaceFolder}/' . l:program

  " Assign program_args
  " Remove the program from the string
  let l:program_args = join(split(a:cmd, " ")[1:], " ")

  " split by spaces unless within quotes.  No good way to do this with vimscript
  " TODO: is this escaping enough?
  let l:split_cmd = 'printf "%s" "' . escape(l:program_args, '"') . '" | xargs -n 1 printf "%s\n"'
  let l:print_output = system(l:split_cmd)
  let l:program_args = split(l:print_output, "\n")

  " Re-quote strings with spaces in them
  call map(l:program_args, { _, arg -> match(arg, ' ') >= 0 ? "'" . arg . "'" : arg })

  " vimspector uses python template strings, escape '$' with '$$'
  call map(l:program_args, { _, arg -> substitute(arg, '\$', '$$', 'g') })

  let l:vimspector_config['configurations']['run']['configuration']['args'] = l:program_args

  call writefile(split(json_encode(l:vimspector_config), "\n"), glob('.vimspector.json'), 'b')

  " Start the debugger
  call vimspector#Continue()
endfunction

function! CreateCenteredFloatingWindow() abort
    let width = min([&columns - 4, max([80, &columns - 20])])
    let height = min([&lines - 4, max([20, &lines - 10])])
    let top = ((&lines - height) / 2) - 1
    let left = (&columns - width) / 2
    let opts = {'relative': 'editor', 'row': top, 'col': left, 'width': width, 'height': height, 'style': 'minimal'}

    let top = "╭" . repeat("─", width - 2) . "╮"
    let mid = "│" . repeat(" ", width - 2) . "│"
    let bot = "╰" . repeat("─", width - 2) . "╯"
    let lines = [top] + repeat([mid], height - 2) + [bot]
    let s:buf = nvim_create_buf(v:false, v:true)
    call nvim_buf_set_lines(s:buf, 0, -1, v:true, lines)
    call nvim_open_win(s:buf, v:true, opts)
    set winhl=Normal:Floating
    let opts.row += 1
    let opts.height -= 2
    let opts.col += 2
    let opts.width -= 4
    let l:textbuf = nvim_create_buf(v:false, v:true)
    call nvim_open_win(l:textbuf, v:true, opts)
    au BufWipeout <buffer> exe 'bw '.s:buf
    return l:textbuf
endfunction

function! IsWsl()
  return system('cat /proc/version') =~ 'Microsoft'
endfunction

function! Open(input)
  let l:program = 'open'
  if IsWsl()
    let l:program = 'wslview'
  endif

  let l:cmd = l:program." '".escape(a:input, "'")."'"
  call system(l:cmd)
endfunction
vnoremap <space>o :<C-U>call Open(GetVisualSelection())<CR>

function! RenameBuffer()
  let l:project_name = fnamemodify(getcwd(), ':t')
  let l:current_buf_name = bufname()
  let l:terminal_buf_name = 'term-' . l:project_name

  if bufname() =~ l:terminal_buf_name
    call feedkeys(":keepalt file ".l:terminal_buf_name."-", 'n')
  elseif bufname() =~ 'term-'
    call feedkeys(":keepalt file term-", 'n')
  else
    call feedkeys(":keepalt file ", 'n')
  endif
endfunction
nnoremap <space>brn :call RenameBuffer()<CR>

" lazygit
function! OpenLazyGit()
  let l:project_name = fnamemodify(getcwd(), ':t')
  let l:lazygit_buffer_name = 'term-'.l:project_name.'-lazygit'
  let l:lazygit_window_search = win_findbuf(bufnr('term-.dotfiles-lazygit'))

  if len(l:lazygit_window_search) > 0
    call win_gotoid(l:lazygit_window_search[0])
  elseif buflisted(l:lazygit_buffer_name)
    tabedit
    execute ':TabooRename '.l:project_name. ' (git)'
    execute 'buffer '.l:lazygit_buffer_name

    " calling :bdlete does not trigger 'TabLeave' for some reason.
    autocmd TermClose <buffer> lua vim.api.nvim_input("<CR>")
  else
    tabedit
    terminal lazygit
    execute ':keepalt file '.l:lazygit_buffer_name
    execute ':TabooRename '.l:project_name. ' (git)'
    autocmd TermClose <buffer> lua vim.api.nvim_input("<CR>")
  endif

  startinsert
endfunction
nnoremap <space>git :call OpenLazyGit()<CR>

function! ToggleQuickFixWindow()
    if empty(filter(getwininfo(), 'v:val.quickfix'))
        copen
    else
        cclose
    endif
endfunction
nnoremap <space>Q :call ToggleQuickFixWindow()<CR>
" {{{ vim github links
function! GetGithubOwnerRepo()
  let l:remote_output = trim(system('git remote -v'))

  " SSH links
  let l:remote_reponame = matchstr(l:remote_output, 'github.com.*:\zs[a-zA-Z0-9-_]\+\/[a-zA-Z0-9-_]\+\ze\.git')
  if !empty(l:remote_reponame)
    return l:remote_reponame
  endif

  " https links
  let l:remote_reponame = matchstr(g:remote_output, 'github.com/\zs[a-zA-Z0-9-_]\+\/[a-zA-Z0-9-_]\+\ze\.git')
  if !empty(l:remote_reponame)
    return l:remote_reponame
  endif

  echomsg 'could not parse organization/repository name from remote: '.l:remote_output
endfunction

function! GetGithubRepoLink()
  if trim(system('git rev-parse --is-inside-work-tree')) != 'true'
    echomsg getcwd().' is not in a git repository.'
    return
  endif

  let l:remote_reponame = GetGithubOwnerRepo()
  let l:base_url = 'https://github.com'
  let l:url = join([l:base_url, l:remote_reponame], '/')
  echom "opening ".l:url
  return l:url
endfunction

function! GetGithubBlameLink()
  if trim(system('git rev-parse --is-inside-work-tree')) != 'true'
    echomsg getcwd().' is not in a git repository.'
    return
  endif

  let l:remote_reponame = GetGithubOwnerRepo()
  let l:line_number = line('.')
  let l:file_path = expand('%:.')
  let l:commit_hash = matchstr(system('git rev-parse HEAD'), '^\zs[0-9a-f]\+')
  " let l:blame_output = trim(system('git blame -L '.l:line_number.','.l:line_number.' --porcelain '.l:file_path))
  " let l:commit_hash = matchstr(l:blame_output, '^\zs[0-9a-f]\+')

  let l:base_url = 'https://github.com'
  let l:file_path_line = l:file_path.'#L'.l:line_number
  let l:url = join([l:base_url, l:remote_reponame, 'blame', l:commit_hash, l:file_path_line], '/')
  return l:url
endfunction

function! GetGithubLink()
  if trim(system('git rev-parse --is-inside-work-tree')) != 'true'
    echomsg getcwd().' is not in a git repository.'
    return
  endif

  let l:remote_reponame = GetGithubOwnerRepo()
  let l:remote_output = trim(system('git remote -v'))

  let l:remote_ref_output = trim(system('git rev-parse --abref-ref --symbolic-full-name @{u}'))
  let l:remote_ref = matchstr(l:remote_ref_output, 'refs\/remotes\/\zs[a-zA-Z0-9-_]*\/[0-9a-zA-Z-@]*')

  " Default to default branch if local branch doesn't exist on remote
  if empty(l:remote_ref)
    let l:remote_name = trim(system('git remote'))

    if empty(l:remote_name)
      echomsg 'could not find remote for this repo'
      return
    endif

    let l:remote_name = split(l:remote_name)[0]
    let l:remote_ref = trim(system('git rev-parse --abbrev-ref '.l:remote_name.'/HEAD'))

    if empty(l:remote_name)
      echomsg 'could not find default remote branch for this repo'
      return
    endif
  endif

  let l:git_root = fnamemodify(trim(system(('git rev-parse --show-toplevel'))), ':p')
  let l:current_file = fnamemodify(expand('%'), ':p')
  let l:relative_path = substitute(l:current_file, escape(l:git_root, '/'), '', '')
  let l:line = line('.')
  let l:location = l:relative_path.'#L'.l:line

  let [l:remote, l:ref] = split(l:remote_ref, '/')
  let l:base_url = 'https://github.com'
  let l:url = join([l:base_url, l:remote_reponame, 'blob', l:ref, l:location], '/')

  return l:url
endfunction

nmap <space>ghro :call Open(GetGithubRepoLink())<CR>

nmap <space>gho :call Open(GetGithubLink())<CR>
nmap <space>ghc :let @+ = GetGithubLink()<CR>
" }}}
" }}}
" {{{ Mappings

cnoremap <c-\><c-f> <c-f>
cnoremap <c-\><c-a> <c-a>

nnoremap sh ^
xnoremap sh ^
nnoremap sl $
xnoremap sl $h

" :)
nnoremap s <Nop>
nnoremap Q <nop>

" Insert mode maps
inoremap jk <Esc>
inoremap <C-s> <Esc>
cnoremap <C-s> <Esc>

" no need for man
nnoremap K :echo "No binding set"<CR>

" Window movements (Replaced with tmux-navigator)
" nnoremap <C-h> <C-w>h
" nnoremap <C-j> <C-w>j
" nnoremap <C-k> <C-w>k
" nnoremap <C-l> <C-w>l

" inoremap <C-h> <Esc><C-w>h
" inoremap <C-j> <Esc><C-w>j
" inoremap <C-k> <Esc><C-w>k
" inoremap <C-l> <Esc><C-w>l
" inoremap <C-h> <Esc><C-w>h

" Line text-objects
" onoremap <silent> <expr> al v:count==0 ? ":<c-u>normal! 0V$h<cr>" : ":<c-u>normal! V" . (v:count) . "jk<cr>"
" vnoremap <silent> <expr> al v:count==0 ? ":<c-u>normal! 0V$h<cr>" : ":<c-u>normal! V" . (v:count) . "jk<cr>"
" onoremap <silent> <expr> il v:count==0 ? ":<c-u>normal! ^vg_<cr>" : ":<c-u>normal! ^v" . (v:count) . "jkg_<cr>"
" vnoremap <silent> <expr> il v:count==0 ? ":<c-u>normal! ^vg_<cr>" : ":<c-u>normal! ^v" . (v:count)

" Close all folds except the current one, set cursor to middle of screen
nnoremap <space>z zMzvzz

" Default swaps
"""""""""""""""

" make ' jump to column of mark instead of beginning of line
nnoremap ' `
nnoremap ` '

" yank in a visual block leaves cursor at end of yanked block
xnoremap y y`]

" If matchiing tag is ambiguous, show list instead of jumping to first
nnoremap <c-]> g<c-]>
vnoremap <c-]> g<c-]>
nnoremap g<c-]> <c-]>
vnoremap g<c-]> <c-]>

nnoremap Y yg_
nnoremap y% :let @+ = @%<CR>
nnoremap <space>y% :let @+ = fnamemodify(expand('%'), ':p')<CR>

"Ruby:t Ruby methods can commonly contain word boundary characters like ! or ?
" Add helpers for motions that operate on the word under the cursor to include
" these tokens
nnoremap <space><c-]> viwlg<c-]>
nnoremap <space>* viwl*

" Match current input
cnoremap <c-n> <down>
cnoremap <c-p> <up>

" vim-rsi overwrites the very useful c_<c-a> mapping.
cnoremap <c-\><c-a> <c-a>
cnoremap <c-\><c-l> <c-l>

" Up and down traverse into wrapped lines
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

" Search for text under visual selection
vnoremap // y/<C-R>"<CR>

" Go to end of pattern match
nnoremap <space>e //e<CR>

" file-Replace
nnoremap <space>gr :%s/<C-r>=expand('<cword>')<CR>//g<left><left>
xnoremap <space>gr y:%s/<C-r>0//g<left><left>

" Open buffer in new tab and go to current position
function! ReopenInNewTab()
  let l:project_name = fnamemodify(getcwd(), ':t')
  let l:current_buffer = bufnr('%')

  normal ml
  tabedit
  execute ':buffer '.l:current_buffer
  execute ':TabooRename '.l:project_name
  normal 'lzz
endfunction
nnoremap st :call ReopenInNewTab()<CR>

" Make windows equal but shrink the bottommost window to 20 lines (usually a
" terminal buffer)
" nnoremap <space>w= <C-w>=<C-w>j:res 20<CR><C-w>k

" Weird hack.  Sometimes the scrolloff option breaks for a terminal buffer
" if the terminal buffer was present in another window with different
" dimensions.
nnoremap <space>w<space> :resize +1<CR>:resize -1<CR>

" Reload vimrc
nnoremap <space>E :edit $MYVIMRC<CR>
nnoremap <space>rl :source $MYVIMRC<CR>

" Toggle scrolloff
" nnoremap <space>zz :let &scrolloff=999-&scrolloff<CR>

nnoremap <space>l <C-^>
nnoremap <space>sl :nohlsearch<CR>
nnoremap set :buffer term-<C-d>

nnoremap <space>= vip:sort<CR>

nnoremap <space>1 1gt
nnoremap <space>2 2gt
nnoremap <space>3 3gt
nnoremap <space>4 4gt
nnoremap <space>5 5gt
nnoremap <space>6 6gt
nnoremap <space>7 7gt
nnoremap <space>8 8gt
nnoremap <space>9 9gt

nnoremap <space>y "+y
nnoremap <space>p "+p
vnoremap <space>y "+y
vnoremap <space>p "+p

nnoremap <space>tq :tabclose<CR>
nnoremap <space>q :q<CR>
" nnoremap <space>bd :bprevious <bar> bdelete! #<CR>
nnoremap <C-n> :tabnext<CR>
nnoremap <C-p> :tabprevious<CR>
nnoremap sn :tabnext<CR>
nnoremap sp :tabprevious<CR>

nnoremap sf :set filetype=

nnoremap \e :edit!<CR>

nmap <silent><space>@ @@ :silent call repeat#set("@@", -1)<CR>
      \ :silent! call repeat#set("@@", -1)<CR>
" }}}
" {{{ Plugin Config

" {{{ Nnn

let g:nnn#command = 'nnn -AH'
if !empty($NNN_OPTS)
  let g:nnn#command = 'nnn -'.$NNN_OPTS
endif

let g:nnn#action = {
      \ '<c-t><c-t>': 'tab split',
      \ '<c-s><c-s>': 'split',
      \ '<c-v>': 'vsplit' }

let g:layout_floating = { 'layout': { 'window': { 'width': 0.9, 'height': 0.6 } } }
let g:layout_embedded = { 'layout': 'enew' }

nnoremap <space>n :call nnn#pick(getcwd(), g:layout_floating)<CR>
nnoremap <space>N :call nnn#pick(fnamemodify(expand('%'), ':p:h'), g:layout_floating)<CR>
nnoremap <space>sn :call nnn#pick(getcwd(), g:layout_embedded)<CR>
nnoremap <space>sN :call nnn#pick(fnamemodify(expand('%'), ':p:h'), g:layout_embedded)<CR>
" }}}
" {{{ send-to-window
let g:sendtowindow_use_defaults=0
nmap <space>wl <Plug>SendRight
xmap <space>wl <Plug>SendRightV
nmap <space>wh <Plug>SendLeft
xmap <space>wh <Plug>SendLeftV
nmap <space>wk <Plug>SendUp
xmap <space>wk <Plug>SendUpV
nmap <space>wj <Plug>SendDown
xmap <space>wj <Plug>SendDownV
" }}}
" {{{ Taboo
let taboo_tab_format=' [%N-NoName]%m '
let taboo_renamed_tab_format=' [%N-%l]%m '

function! TabRename()
  let l:project_name = fnamemodify(getcwd(), ':t')

  call feedkeys(":TabooRename ".l:project_name)
endfunction
command! -nargs=0 TabRename call TabRename()
nnoremap <space>tr :TabRename<CR>
" }}}
" {{{ gundo
nnoremap <space>gu :GundoToggle<CR>
" }}}
" {{{ vim-easy-align
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
" }}}
" {{{ FZF
let $FZF_DEFAULT_OPTS .= ' --border --no-height --layout=reverse'
let g:fzf_default_rg_opts= '--hidden --follow --glob "!.git/**"'

if executable('rg')
  let $FZF_DEFAULT_COMMAND = 'rg --files '.g:fzf_default_rg_opts.' '
  set grepprg=rg\ --vimgrep
  command! -bang -nargs=* Find
    \ call fzf#vim#grep(
    \   'rg '.g:fzf_default_rg_opts.' --column --line-number --no-heading --fixed-strings --ignore-case --color "always" '.shellescape(<q-args>).'| tr -d "\017"',
    \   1,
    \   <bang>0
    \ )
endif

let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.8 } }

" :like :Rg but only search file content, i.e. do not match directories
command! -bang -nargs=* RG
  \ call fzf#vim#grep(
  \   "rg".g:fzf_default_rg_opts." --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>),
  \   1,
  \   fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}),
  \   <bang>0)

command! -bang -nargs=* RgNoIgnore
  \ call fzf#vim#grep(
  \   'rg '.g:fzf_default_rg_opts.' --glob ".git/**" --no-ignore --column --line-number --no-heading --fixed-strings --smart-case --color "always" '.shellescape(<q-args>).'| tr -d "\017"',
  \   1,
  \   <bang>0
  \ )

function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --no-ignore --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)
" mnemonic: straight up ripgrep with no fzf syntax support accross all files

function! s:project_buffer_open(buffer)
  execute ':buffer ' . bufnr(bufname(a:buffer))
endfunction

" :Project buffers
function! ProjectBuffers()
  let l:project_root = ProjectRootGet()
  let l:buffers = filter(range(1, bufnr('$')), 'bufloaded(v:val)')
  let l:project_buffers = filter(l:buffers, { _, val ->
        \   stridx(fnamemodify(bufname(val), ':p'), l:project_root) > -1
        \ })
  let l:names = sort(map(copy(l:project_buffers), { _, val -> bufname(val) }))

  call fzf#run(fzf#wrap(fzf#vim#with_preview({
        \    'source': l:names,
        \    'sink': function('s:project_buffer_open'),
        \ })))
endfunction
command! -nargs=* ProjectBuffers call ProjectBuffers()

function! s:fuzzy_tab_open_handler(tab_name)
  let l:tabnr = matchstr(a:tab_name, '[0-9]\+')
  call feedkeys(l:tabnr . 'gt')
endfunction
function! FuzzyTabs()
  let l:tabs = sort(copy(MatchStrAll(TabooTabline(), '\[[0-9]\+-[^]]\+\]')))

  " workaround: an autocmd from searchhi throws an error when the
  " searchhighlight is active and we navigate away from a terminal buffer
  execute "normal \<Plug>(searchhi-clear-all)"

  call fzf#run(fzf#wrap({
        \    'source': l:tabs,
        \    'sink': function('s:fuzzy_tab_open_handler'),
        \ }))
endfunction

function! s:fuzzy_project_selector_handler(project_name)
  echom 'received ' . a:project_name

  let l:path = expand("$HOME") . '/code/' . a:project_name

  if !isdirectory(l:path)
    if match(a:project_name, '/') == -1
      echo "don't know how to clone: '".a:project_name."'"
      return
    endif

    echo 'cloning '.a:project_name.' into '.l:path

    let l:clone_url = 'git@github.com:'.a:project_name.'.git'
    call system('git clone '.l:clone_url.' '.l:path)
  endif

  call ContabsNewTab(v:null, [v:null, l:path])
  call system('refresh_clone_urls')
endfunction

function! FuzzyProjectSelector()
  let l:cloneable_entries = []
  if filereadable($DOTFILES_CLONE_URLS_PATH)
    let l:cloneable_entries = map(
          \ copy(readfile($DOTFILES_CLONE_URLS_PATH)),
          \ { _line, clone_url -> matchstr(clone_url, ':\zs.*\ze\.git')},
          \ )
  endif

  let l:contabs_projects = keys(copy(contabs#project#paths()))
  let l:all_entries = uniq(sort(copy(l:cloneable_entries + l:contabs_projects)))

  call fzf#run(fzf#wrap({
        \    'source': l:all_entries,
        \    'sink': function('s:fuzzy_project_selector_handler'),
        \ }))
endfunction

function! s:fuzzy_buffer_delete_handler(projects)
  let l:project_roots = map(copy(a:projects), { _, project_path -> fnamemodify(project_path, ':p') })
  let l:buffers = filter(range(1, bufnr('$')), 'bufloaded(v:val)')
  call map(l:buffers, { _, buf -> fnamemodify(bufname(buf), ':p')})

  " Filter buffers which belong to a selected project
  let l:buffers_to_delete = filter(
        \ copy(l:buffers),
        \ { _, buf -> len(filter(
        \         copy(l:project_roots),
        \         { _, project_root -> match(buf, project_root) > -1 }
        \ )) > 0 },
        \ )

  " Filter terminal buffers which match a selected project
  let l:terminal_buffer_names = map(
        \ copy(a:projects),
        \ { _, project -> 'term-' . fnamemodify(project, ':t') }
        \ )

  call extend(l:buffers_to_delete, l:terminal_buffer_names)

  echom "deleting buffers: " . join(l:buffers_to_delete, "\n")
  for b in buffers_to_delete
    execute 'Bdelete! ' . b
  endfor

  " Close tabs for selected projects
  for project in a:projects
    let l:tabs = sort(copy(MatchStrAll(TabooTabline(), '\[[0-9]\+-[^]]\+\]')))
    let l:index = index(l:tabs, project)
    if l:index >= 0
      echom "closing tab: " . l:tabs[l:index]

      let l:index += 1
      execute l:index . 'tabclose'
    endif
  endfor

  " Remove NoName tabs
  let l:tabs = sort(copy(MatchStrAll(TabooTabline(), '\[[0-9]\+-[^]]\+\]')))
  for x in range(1, len(l:tabs))
    let l:index = index(l:tabs, 'NoName')
    if l:index >= 0
      echom "closing tab: " . l:tabs[l:index]

      let l:index += 1
      execute l:index . 'tabclose'
    endif
  endfor
endfunction

function! FuzzyBufferDelete()
  let l:buffers = filter(range(1, bufnr('$')), 'bufloaded(v:val)')
  call map(l:buffers, { _, buf -> fnamemodify(bufname(buf), ':p')})

  let l:project_roots = map(copy(l:buffers), { _, bufpath -> projectroot#get(bufpath) })
  call filter(l:project_roots, { _, path ->
        \ path != '' &&
        \ path != '.' &&
        \ path !~ '^/usr' &&
        \ path !~ '/.local/'
        \ })
  call uniq(l:project_roots)

  let dict = {}
  for l in l:project_roots
    let dict[l] = ''
  endfor
  let unique_project_roots = map(keys(dict), { _, path -> fnamemodify(path, ':~') })

  call fzf#run(fzf#wrap({
        \    'source': l:unique_project_roots,
        \    'sink*': function('s:fuzzy_buffer_delete_handler'),
        \    'options': '--multi',
        \ }))
endfunction

" :Tags
command! -nargs=* Tags
      \ call fzf#vim#tags(
      \    <q-args>,
      \    {'options': '--delimiter : --nth 4..'},
      \    <bang>0
      \ )

command! -nargs=? -complete=dir Files
      \ call fzf#vim#files(
      \   <q-args>,
      \   fzf#vim#with_preview(),
      \   <bang>0
      \ )

command! -nargs=? AllFiles
      \ call fzf#run(fzf#wrap(fzf#vim#with_preview({
      \     'source': 'rg '.g:fzf_default_rg_opts.' --files --no-ignore',
      \ })))

command! -nargs=? -complete=dir GFiles
      \ call fzf#vim#gitfiles(
      \   <q-args>,
      \   fzf#vim#with_preview(),
      \   <bang>0
      \ )

command! -nargs=0 FzfGDiffView
      \ call fzf#run(fzf#wrap(fzf#vim#with_preview({
      \    'source': 'git log --oneline --graph --color=always ' . fzf#shellescape('--format=%C(auto)%h%d %s %C(green)%cr'),
      \ })))

function! s:get_git_root()
  let root = split(system('git rev-parse --show-toplevel'), '\n')[0]
  return v:shell_error ? '' : root
endfunction

function! s:fzf_gedit_lazy_branch_handler(selection)
  let l:filename = expand('%')
  execute 'Gedit '.a:selection.':'.l:filename
endfunction

function! GEditLazyBranch()
  let l:branches = filter(
        \ split(system('git branch --all')),
        \ {_, s -> s =~ '^[a-zA-Z0-9-_/]\+$'}
        \ )

  call fzf#run(fzf#wrap(fzf#vim#with_preview({
        \    'source': l:branches,
        \    'sink': function('s:fzf_gedit_lazy_branch_handler'),
        \ })))
endfunction
nnoremap <space>ge :call GEditLazyBranch()<CR>

function! s:fzf_commits_diffview_sink(commits) abort
  let pat = '[0-9a-f]\{7,9}'
  let hashes = filter(map(copy(a:commits), 'matchstr(v:val, pat)'), 'len(v:val)')

  if len(hashes) == 1
    let cmd = 'DiffviewOpen '.hashes[0].'..HEAD'
    echom 'executing cmd: '.cmd
    execute cmd
  elseif len(hashes) == 2
    let hash1 = hashes[0]
    let hash2 = hashes[1]
    let cmd = "git log ".hash1." ".hash2." --format='%h' --author-date-order | rg '".hash1."|".hash2."'"
    echom "executing: ".cmd
    let sorted_hashes = split(trim(system(cmd), "\n"))
    call assert_true(len(sorted_hashes) == 1, "failed to sorted hashes using cmd: '".cmd."'")

    let newer = sorted_hashes[0]
    let older = sorted_hashes[1]
    echom 'older:'.older
    echom 'newer:'.newer
    execute 'DiffviewOpen '.older.'..'.newer
  else
    call s:warn('[s:fzf_commits_diffview_sink] didn''t know what to do for selection: '.a:commits)
  endif
endfunction

function! FzfCommitsDiffview(buffer_local)
  let root = s:get_git_root()
  if empty(root)
    return s:warn('Not in git repo')
  endif

  let source = 'git log --oneline --color=always '
       \ . fzf#shellescape('--format=%C(auto)%h%d %s %C(green)%cr')
  let current = expand('%')
  let managed = 0
  if !empty(current)
    call system('git show '.fzf#shellescape(current).' 2> /dev/null')
    let managed = !v:shell_error
  endif

  if a:buffer_local
    if !managed
      return s:warn('The current buffer is not in the working tree')
    endif
    let source .= ' --follow '.fzf#shellescape(current)
  else
    let source .= ' --graph'
  endif

  let options = {
        \ 'source': source,
        \ 'sink*': function('s:fzf_commits_diffview_sink'),
        \ 'options': ['--ansi', '--multi', '--tiebreak=index'],
        \ }

  call extend(options.options,
        \ ['--preview', 'echo {} | grep -o "[a-f0-9]\{7,\}" | head -1 | xargs git show --format=format: --color=always'])

  call fzf#run(fzf#wrap(options))
endfunction

command! -nargs=0 GDiffFiles
      \ call fzf#run(fzf#wrap(fzf#vim#with_preview({
      \    'source': split(trim(system('git diff --name-only')), "\n"),
      \ })))

command! -nargs=0 GDiffMainFiles
      \ call fzf#run(fzf#wrap(fzf#vim#with_preview({
      \    'source': split(trim(system('git diff main --name-only')), "\n"),
      \ })))

command! TerminalBuffers
  \ call fzf#vim#buffers(
  \  '.',
  \  {'options': ['--query', '^term ']},
  \  <bang>0
  \ )

command! -bang -nargs=* Rg
      \ call fzf#vim#grep(
      \   'rg '.g:fzf_default_rg_opts.' --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
      \   fzf#vim#with_preview(), <bang>0)

" FZF Binds
nnoremap <space><C-f> :GFiles<CR>

nnoremap <space>fb :Buffers<CR>
nnoremap <space>fc :Commands<CR>
nnoremap <space>fi :Files<CR>
nnoremap <space>fI :AllFiles<CR> !node_modules<space>
nnoremap <space>ffi :AllFiles<CR> !node_modules<space>
nnoremap <space>fh :Helptags<CR>
nnoremap <space>flb :BLines<CR>
nnoremap <space>fla :Lines<CR>
nnoremap <space>fm :Marks<CR>
nnoremap <space>fM :Maps<CR>
nnoremap <space>fgl :GFiles?<CR>
nnoremap <space>fw :Windows<CR>
nnoremap <space>fa :Rg<CR>
nnoremap <space>fA :RgNoIgnore<CR> !node_modules<space>
nnoremap <space>fr :Rg<CR>
nnoremap <space>ft :TerminalBuffers<CR>
nnoremap <space>fz :FZFMru<CR>
nnoremap <space>fH :History<CR>
nnoremap <space>f: :History:<CR>
nnoremap <space>f/ :History/<CR>

nnoremap <space>fgdv :call FzfCommitsDiffview(0)<CR>
nnoremap <space>fgdbv :call FzfCommitsDiffview(1)<CR>
nnoremap <space>fgdf :GDiffFiles<CR>
nnoremap <space>gdmf :GDiffMainFiles<CR>
nnoremap <space>fd :call FuzzyBufferDelete()<CR>
nnoremap <space>rg :RG<CR>
nnoremap <space>fu :ProjectBuffers<CR>
nnoremap <space>fq :call FuzzyTabs()<CR>

imap <c-x><c-f> <plug>(fzf-complete-path)
" }}}
"{{{ vim-agriculture
function! RgVisualSelection()
  execute ':RgRaw ' . GetVisualSelection()
endfunction

" Setup query
nnoremap <space>f; :RgRaw<Space>
nnoremap <space>/ :RgRaw<Space>

" Perform :RgRaw search with word under cursor
nnoremap <space>f* :execute ':RgRaw' expand('<cword>')<CR>

" Perform :RgRaw with current visual selection
xnoremap <space>f* :call RgVisualSelection()<CR>
"}}}
" {{{ fuzzy incsearch
map s/ <Plug>(incsearch-fuzzy-/)
map s? <Plug>(incsearch-fuzzy-?)
map sg/ <Plug>(incsearch-fuzzy-stay)
" }}}
" {{{ win-reszier
" nnoremap <c-q> :WinResizerStartResize<CR>
let g:winresizer_start_key = '<C-Q>'
" }}}
" {{{ vim-fugitive
" nnoremap <space>gvs :Gvsplit<CR>
nnoremap <space>gvss :Gvsplit
nnoremap <space>gvsm :execute ':Gvsplit ' . trim(system("git symbolic-ref refs/remotes/origin/HEAD \| rg 'refs/remotes/origin/(.+)' -o -r '\$1'")) . ':%'<CR>
nnoremap <space>blame :tabedit %<CR>:Gblame<CR><C-w>lV

" Browse the *history* of a single file
nnoremap <space>ghs :0Gclog<CR>
" }}}
" {{{ vim-projectroot
let g:rpn_rootmarkers_nonmonorepo = [
      \  'Gemfile',
      \  '.projectroot',
      \  '.git',
      \  '.hg',
      \  '.svn',
      \  '.bzr',
      \  '_darcs',
      \  'build.xml',
      \  'MIT-LICENSE',
      \  'README.md',
      \  'package.json'
      \ ]
let g:rpn_rootmarkers_monorepo = [
      \  'Cargo.toml',
      \  'package.json',
      \  'Gemfile',
      \  '.projectroot',
      \  '.git',
      \  '.hg',
      \  '.svn',
      \  '.bzr',
      \  '_darcs',
      \  'build.xml',
      \  'MIT-LICENSE',
      \  'README.md'
      \ ]

" Change current working directory of all windows in tab to project root of current buffer
function! TcdProjectRoot(rootmarkers_config)
  let g:rootmarkers = deepcopy(a:rootmarkers_config)
  let l:project_root = ProjectRootGet()

  if l:project_root == ''
    echo "couldn't determine project root.  Current working directory remains at " . getcwd()
    return
  endif

  execute 'tcd ' . l:project_root
  echo 'switched to "' . l:project_root . '"'
endfunction
nnoremap <space>cd :call TcdProjectRoot(g:rpn_rootmarkers_nonmonorepo)<CR>
nnoremap <space>cD :call TcdProjectRoot(g:rpn_rootmarkers_monorepo)<CR>
" nnoremap <space>cd :execute 'tcd ' . ProjectRootGet()<CR>
" }}}
" {{{ coc-nvim
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gI <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gn <Plug>(coc-diagnostic-next)
      \ :silent call repeat#set("\<Plug>(coc-diagnostic-next)", v:count)<CR>
nmap <silent> gp <Plug>(coc-diagnostic-prev)
      \ :silent call repeat#set("\<Plug>(coc-diagnostic-prev)", v:count)<CR>
nmap <silent> <space>re <Plug>(coc-refactor)
nmap <silent> <space>rn <Plug>(coc-rename)
nnoremap <silent> gl :CocList<CR>
nnoremap <silent> <space>gl :CocList diagnostics<CR>
inoremap <silent><expr> <c-space> coc#refresh()
inoremap <silent> <c-l> <Esc>:call CocActionAsync('showSignatureHelp')<CR>a
nmap <space>A <Plug>(coc-codeaction)

nnoremap K :call CocAction('doHover')<CR>

" imap <silent> <c-k> <esc><Plug>(coc-float-jump)
nmap <silent> gF <Plug>(coc-float-jump)
nmap <silent> gH <Plug>(coc-float-hide)
nmap <silent> <esc> <Plug>(coc-float-hide)

" from :help coc-completion
inoremap <silent><expr> <c-i>
      \ coc#pum#visible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ?
      \ "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
" inoremap <silent><expr> <tab>
"       \ coc#pum#visible() ? coc#_select_confirm() :
"       \ coc#expandableOrJumpable() ?
"       \ "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
"       \ <SID>check_back_space() ? "\<TAB>" :
"       \ coc#refresh()

" inoremap <silent><expr> <C-q> "\<c-o>:echom coc#pum#visible()='".coc#pum#visible()."'\n"
inoremap <silent><expr> <C-q> coc#_select_confirm()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <c-t> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

function! FloatScroll(forward) abort
  let float = coc#util#get_float()
  if !float | return '' | endif
  let buf = nvim_win_get_buf(float)
  let buf_height = nvim_buf_line_count(buf)
  let win_height = nvim_win_get_height(float)
  if buf_height < win_height | return '' | endif
  let pos = nvim_win_get_cursor(float)
  if a:forward
    if pos[0] == 1
      let pos[0] += 3 * win_height / 4
    elseif pos[0] + win_height / 2 + 1 < buf_height
      let pos[0] += win_height / 2 + 1
    else
      let pos[0] = buf_height
    endif
  else
    if pos[0] == buf_height
      let pos[0] -= 3 * win_height / 4
    elseif pos[0] - win_height / 2 + 1  > 1
      let pos[0] -= win_height / 2 + 1
    else
      let pos[0] = 1
    endif
  endif
  call nvim_win_set_cursor(float, pos)
  return ''
endfunction

" inoremap <silent><expr> <down> coc#util#has_float() ? FloatScroll(1) : "\<down>"
" inoremap <silent><expr> <up> coc#util#has_float() ? FloatScroll(0) :  "\<up>"
imap <silent> <c-f> <esc><Plug>(coc-float-jump)
nmap <silent> <c-w><c-f> <esc><Plug>(coc-float-jump)


" }}}
" {{{ vimwiki
let wiki = {}
let wiki.path = '~/vimwiki/'
let wiki.nested_syntax = {'ruby': 'ruby'}
let g:vimwiki_list = [wiki]
let g:vimwiki_folding=''

" let g:vimwiki_key_mappings = { }

function! VimwikiLinkHandler(link)
  " Use Vim to open external files with the 'vfile:' scheme.  E.g.:
  "   1) [[vfile:~/Code/PythonProject/abc123.py]]
  "   2) [[vfile:./|Wiki Home]]
  let link = a:link
  if link =~# '^vfile:'
    let link = link[1:]
  else
    return 0
  endif
  let link_infos = vimwiki#base#resolve_link(link)
  if link_infos.filename == ''
    echomsg 'Vimwiki Error: Unable to resolve link!'
    return 0
  else
    execute 'edit ' . fnameescape(link_infos.filename)
    return 1
  endif
endfunction
" }}}
" {{{ vim-markdown
let g:mkdp_echo_preview_url=0
let g:mkdp_auto_close=0
let g:mkdp_preview_options = {
    \ 'mkit': {},
    \ 'katex': {},
    \ 'uml': {},
    \ 'maid': {},
    \ 'disable_sync_scroll': 1,
    \ 'sync_scroll_type': 'middle',
    \ 'hide_yaml_meta': 1,
    \ 'sequence_diagrams': {},
    \ 'flowchart_diagrams': {},
    \ 'content_editable': v:false,
    \ 'disable_filename': 0,
    \ 'toc': {}
    \ }
" }}}
" {{{ vim-test
let test#ruby#rspec#executable = 'bundle exec rspec'

let g:test#custom_strategies = {
      \ 'project_terminal': function('OpenAndSendCmdToProjectTerminal'),
      \ 'vimspector': function('VimTestVimspectorStrategy'),
      \ }
      " \ 'vimspector*': function('VimTestVimspectorStrategyTest'),
let g:test#strategy = 'project_terminal'
" }}}
" {{{ closetag
let g:closetag_filenames = '*.html,*.xhtml,*.jsx,*.js'
let g:closetag_xhtml_filenames = '*.xhtml,*.jsx,*.js'
let g:closetag_shortcut = '>'
" }}}
" {{{ vim-indentline
" let g:indentLine_color_gui = '#5b5b5b'
" let g:indentLine_fileTypeExclude=['markdown']
" let g:indentLine_bufTypeExclude=['help', 'terminal']

let g:indent_blankline_buftype_exclude=['help', 'terminal']
" let g:indent_blankline_char = '┊'
let g:indent_blankline_char = '▏'
" ¦
" ┆
" │
" ▏
"
" ⎸

" let g:indentLine_char = '┊'
" }}}
" {{{ ultisnips
let g:UltiSnipsEditSplit="horizontal"
let g:UltiSnipsExpandTrigger="<c-t>"
" let g:UltiSnipsJumpForwardTrigger="<c-j>"
" let g:UltiSnipsJumpBackwardTrigger="<c-k>"
let g:UltiSnipsSnippetDirectories=[$HOME.'/code/dotfiles/ultisnips', "UltiSnips"]
" }}}
" {{{ vim-searchhi
let g:searchhi_clear_all_autocmds = 'InsertEnter'
" let g:searchhi_clear_all_asap=1
" let g:searchhi_user_autocmds_enabled=1
nmap / <Plug>(searchhi-/)
nmap ? <Plug>(searchhi-?)
nmap n <Plug>(searchhi-n)
nmap N <Plug>(searchhi-N)
nmap <silent> <space>sl <Plug>(searchhi-clear-all)

vmap / <Plug>(searchhi-v-/)
vmap ? <Plug>(searchhi-v-?)
vmap n <Plug>(searchhi-v-n)
vmap N <Plug>(searchhi-v-N)
vmap <silent> <space>sl <Plug>(searchhi-v-clear-all)

" vim-searchhi / vim-asterisk
nmap * <Plug>(asterisk-z*)<Plug>(searchhi-update)
nmap # <Plug>(asterisk-z#)<Plug>(searchhi-update)
nmap g* <Plug>(asterisk-g*)<Plug>(searchhi-update)
nmap g# <Plug>(asterisk-g#)<Plug>(searchhi-update)

nmap z* <Plug>(asterisk-*)<Plug>(searchhi-update-stay-forward)
nmap z# <Plug>(asterisk-#)<Plug>(searchhi-update-stay-backward)
nmap zg* <Plug>(asterisk-gz*)<Plug>(searchhi-update-stay-forward)
nmap zg# <Plug>(asterisk-gz#)<Plug>(searchhi-update-stay-backward)

" These do not use the visual variant (`searchhi-v-update`) because these
" vim-asterisk commands only use the selected text as the search term, so there
" is no need to preserve the visual selection
vmap * <Plug>(asterisk-*)<Plug>(searchhi-update)
vmap # <Plug>(asterisk-#)<Plug>(searchhi-update)
vmap g* <Plug>(asterisk-g*)<Plug>(searchhi-update)
vmap g# <Plug>(asterisk-g#)<Plug>(searchhi-update)

" These all use the backward variant because the cursor is always at or in
" front of the start of the visual selection, so we need to search backwards to
" get to the start position
vmap z* <Plug>(asterisk-z*)<Plug>(searchhi-update-stay-backward)
vmap z# <Plug>(asterisk-z#)<Plug>(searchhi-update-stay-backward)
vmap zg* <Plug>(asterisk-zg*)<Plug>(searchhi-update-stay-backward)
vmap zg# <Plug>(asterisk-zg#)<Plug>(searchhi-update-stay-backward)

" Write all buffers and turn off search highlights
nmap <silent> <space>wa :silent! :wall<CR>:set nohlsearch<CR>
nnoremap <silent> <space>wa :silent! :wall<CR>:execute "normal \<Plug>(searchhi-clear-all)"<CR>
" }}}
" {{{ Tmux Navigator
let g:tmux_navigator_disable_when_zoomed=1
" }}}
" {{{ vim-signify
omap ic <plug>(signify-motion-inner-pending)
xmap ic <plug>(signify-motion-inner-visual)
omap ac <plug>(signify-motion-outer-pending)
xmap ac <plug>(signify-motion-outer-visual)
let g:signify_update_on_focusgained = 1
nnoremap <space>gg :SignifyToggle<CR>

nmap <silent> gN <Plug>(signify-next-hunk)
      \ :call repeat#set("\<Plug>(signify-next-hunk)", -1)<CR>
nmap <silent> gP <Plug>(signify-prev-hunk)
      \ :call repeat#set("\<Plug>(signify-prev-hunk)", -1)<CR>
nmap <space>gdh :SignifyHunkDiff<CR>
nmap <space>gdu :SignifyHunkUndo<CR>

" }}}
" {{{ nvim-contabs
let g:contabs#project#locations = [
  \ { 'path': '~/.dotfiles' },
  \ { 'path': '~/code', 'depth': 2, 'git_only': v:true },
  \ { 'path': '~/code', 'depth': 1, 'git_only': v:true },
  \ { 'path': '~/code', 'depth': 0, 'git_only': v:true },
  \ { 'path': '~/code-worktrees', 'depth': 4, 'git_only': v:true },
  \ { 'path': '~/code-worktrees', 'depth': 3, 'git_only': v:true },
  \ { 'path': '~/code-worktrees', 'depth': 2, 'git_only': v:true },
  \ { 'path': '~/code-worktrees', 'depth': 1, 'git_only': v:true },
  \ { 'path': '~/code-worktrees', 'depth': 0, 'git_only': v:true },
  \]

if IsWsl() && isdirectory('/mnt/d/wsl-home/code')
  let g:contabs#project#locations = g:contabs#project#locations + [
  \ { 'path': '/mnt/d/wsl-home/code/', 'depth': 0, 'git_only': v:true },
  \ { 'path': '/mnt/d/wsl-home/code/', 'depth': 1, 'git_only': v:true },
  \ { 'path': '/mnt/d/wsl-home/code/', 'depth': 2, 'git_only': v:true },
  \  ]
endif

function! ContabsNewTab(cmd, context)
  let [ l:location, l:directory ] = a:context
  let l:project_name = fnamemodify(l:directory, ':t')

  tabedit
  echom 'switched to "' . l:directory . '"'
  execute 'TabooRename ' . l:project_name
  execute 'tcd' . l:directory

  " Open termainal tab? nah
  " split
  " terminal
  " call TerminalResize()

  " let l:buf_name = 'term-' . l:project_name
  " if (bufexists(l:buf_name))
  "   edit l:buf_name
  " else
  "   execute 'file ' . l:buf_name
  " endif

  wincmd t
endfunction

" nnoremap <silent> <space>fp :call contabs#window#open(
"       \ 'projects',
"       \ contabs#project#paths(),
"       \ funcref('ContabsNewTab'),
"       \ [ 'edit', { 'ctrl-t': 'tabedit', 'ctrl-e': 'edit' } ],
"       \ )
"       \ <CR>
nnoremap <silent> <space>fp :call FuzzyProjectSelector()<CR>
nnoremap <silent> <space>Z :call contabs#project#select()<CR>
" }}}
" {{{ vim-smoothie
" let g:smoothie_no_default_mappings = 1

" nnoremap <silent> <Plug>(SmoothieDownwards) :<C-U>call smoothie#downwards() <CR>
" nnoremap <silent> <Plug>(SmoothieUpwards)   :<C-U>call smoothie#upwards()   <CR>
" nnoremap <silent> <Plug>(SmoothieUpwards)   :<C-U>call smoothie#upwards()   <CR>
" nnoremap <silent> <Plug>(SmoothieDownwards) :<C-D>call smoothie#downwards() <CR>
" silent! nmap <unique> <C-U> <Plug>(SmoothieUpwards)
" silent! nmap <unique> <C-D> <Plug>(SmoothieForwards)

" }}}
" {{{ vim-indent-guides
let g:indent_guides_on_vim_startup=1
let g:indent_guides_start_level=2
let g:indent_guides_guide_size=1

" }}}
" {{{ split-join

" Sort inline rust multi-use statements
" e.g.:
" use anyhow::{Context, Result, bail, anyhow};
" becomes
" use anyhow::{Context, Result, anyhow, bail};
nmap <silent> <Plug>SortInline ^f{gSjvi}:s/\(,\)\@<!$/,/<CR>vi}:sort<CR>/}<CR>:nohlsearch<CR>k$xva}JxF{lxj^f{
  \:call repeat#set("\<Plug>SortInline")<CR>
nmap <space>oi <Plug>SortInline

" }}}
" {{{ vim-bbye
nnoremap <space>bd :keepalt Bdelete!<CR>
nnoremap <space>bw :Bwipeout!<CR>
" }}}
" {{{ firenvim
let g:firenvim_config = {
    \ 'globalSettings': {
        \ 'alt': 'all',
    \  },
    \ 'localSettings': {
        \ '.*': {
            \ 'cmdline': 'neovim',
            \ 'priority': 0,
            \ 'selector': 'textarea:not([readonly]), div[role="textbox"]',
            \ 'takeover': 'never',
        \ },
    \ }
\ }

if exists('g:started_by_firenvim')
  " set guifont='Meslo LG M for Powerline:h14'
endif

if exists('g:started_by_nvim')
  augroup firenvim
    autocmd!

    autocmd BufEnter github.com_*.txt set filetype=markdown
  augroup end
endif
" }}}
" {{{ vim-peekaboo
let g:peekaboo_prefix = '<space>'
let g:peekaboo_ins_prefix = '<c-x>'

let g:peekaboo_window="call CreateCenteredFloatingWindow()"
" }}}
" {{{ vim-gutentags
let g:gutentags_enabled=0
" }}}
" nerdtree {{{
nnoremap <space><space> :NERDTreeFind<CR>
" }}}
" ToggleHidden {{{
let s:hidden_all = 0
function! ToggleHiddenAll()
  if s:hidden_all  == 0
    let s:hidden_all = 1
    set noshowmode
    set noruler
    set laststatus=0
    set noshowcmd
  else
    let s:hidden_all = 0
    set showmode
    set ruler
    set laststatus=2
    set showcmd
  endif
endfunction

nnoremap <space>H :call ToggleHiddenAll()<CR>
" }}}
" {{{ vimspector
let g:vimspector_install_gadgets = ['vscode-node-debug-2']

let g:vimspector_sign_priority = {
      \    'vimspectorBP':         20,
      \    'vimspectorBPCond':     19,
      \    'vimspectorBPDisabled': 1,
      \    'vimspectorPC':         999,
      \ }

nmap <space>ds <Plug>VimspectorStop
nmap <space>drs <Plug>VimspectorRestart
nmap <space>dh <Plug>VimspectorRunToCursor
nnoremap <space>dsD :VimspectorReset<CR>

nmap <silent><space>dc <Plug>VimspectorContinue
      \ :silent call repeat#set("\<Plug>VimspectorContinue", -1)<CR>
nmap <silent><space>db <Plug>VimspectorToggleBreakpoint
      \ :silent call repeat#set("\<Plug>VimspectorToggleBreakpoint", -1)<CR>
nmap <silent><space>dsov <Plug>VimspectorStepOver
      \ :silent call repeat#set("\<Plug>VimspectorStepOver", -1)<CR>
nmap <silent><space>dsin <Plug>VimspectorStepInto
      \ :silent call repeat#set("\<Plug>VimspectorStepInto", -1)<CR>
nmap <silent><space>dsou <Plug>VimspectorStepOut
      \ :silent call repeat#set("\<Plug>VimspectorStepOut", -1)<CR>
nmap <silent><space>dse <Plug>VimspectorBalloonEval
      \ :silent call repeat#set("\<Plug>VimspectorBalloonEval", -1)<CR>

" See: VimTestVimspectorStrategy
" }}}
" {{{ vim-projectionist
let g:projectionist_heuristics = {
      \ 'Gemfile.lock|*.gemspec': {
      \   '*.rb': {
      \     'type': 'source',
      \     'alternate': 'spec/{}_spec.rb',
      \   },
      \   'spec/*_spec.rb': {
      \     'alternate': '{}.rb',
      \     'type': 'test',
      \   },
      \ },
      \ 'package.json': {
      \   'package.json': {
      \     'type': 'package',
      \     'alternate': ['yarn.lock', 'package-lock.json'],
      \   },
      \   'package-lock.json': {
      \     'alternate': 'package.json',
      \   },
      \   'yarn.lock': {
      \     'alternate': 'package.json',
      \   },
      \   'src/*.ts': {
      \     'type': 'source',
      \     'alternate': [
      \       'src/{}.test.ts',
      \       'src/{}.spec.ts',
      \       'test/{}.test.ts',
      \       'test/{}.spec.ts',
      \     ],
      \   },
      \   'src/*.test.ts': {
      \     'type': 'test',
      \     'alternate': 'src/{}.ts'
      \   },
      \   'src/*.spec.ts': {
      \     'type': 'test',
      \     'alternate': 'src/{}.ts'
      \   },
      \   'src/*.tsx': {
      \     'type': 'source',
      \     'alternate': [
      \       'src/{}.test.tsx',
      \       'src/{}.spec.tsx',
      \       'test/{}.test.tsx',
      \       'test/{}.spec.tsx',
      \     ],
      \   },
      \   'src/*.test.tsx': {
      \     'type': 'test',
      \     'alternate': 'src/{}.tsx'
      \   },
      \   'src/*.spec.tsx': {
      \     'type': 'test',
      \     'alternate': 'src/{}.tsx'
      \   },
      \ },
      \ 'pom.xml': {
      \   'src/main/java/*.java': {
      \     'type': 'source',
      \     'alternate': 'src/test/java/{}Test.java'
      \   },
      \   'src/test/java/*Test.java': {
      \     'type': 'test',
      \     'alternate': 'src/main/java/{}.java'
      \   },
      \   'src/main/kotlin/*.kt': {
      \     'type': 'source',
      \     'alternate': 'src/test/kotlin/{}Test.kt'
      \   },
      \   'src/test/kotlin/*Test.kt': {
      \     'type': 'test',
      \     'alternate': 'src/main/kotlin/{}.kt'
      \   },
      \ }}

" Undocumented feature
" FZF is really slow with projectionist for some reason.
" https://github.com/junegunn/fzf.vim/issues/392#issuecomment-440238233
let g:projectionist_ignore_term = 1

nnoremap <space>a :A<CR>

" }}}
" {{{ DiffView
nnoremap <space>gdo :DiffviewOpen ..HEAD<left><left><left><left><left><left>
nnoremap <space>gq :DiffviewClose<CR>
" }}}
" {{{ vim-winlayout
nmap <space>wu <Plug>(WinlayoutBackward)
nmap <space>wr <Plug>(WinlayoutForward)
" }}}
" {{{ vim-swap
silent! nunmap gs
nmap <space>gs <Plug>(swap-interactive)
" }}}
" {{{ vim Trouble
nnoremap <space>kx <cmd>TroubleToggle<cr>
nnoremap <space>kw <cmd>TroubleToggle lsp_workspace_diagnostics<cr>
nnoremap <space>kd <cmd>TroubleToggle lsp_document_diagnostics<cr>
nnoremap <space>kq <cmd>TroubleToggle quickfix<cr>
nnoremap <space>kl <cmd>TroubleToggle loclist<cr>
nnoremap gR <cmd>TroubleToggle lsp_references<cr>
" }}}
" {{{ surround-funk.vim
let g:surround_funk_create_mappings = 0

" normal mode
nmap dsf <Plug>DeleteSurroundingFunction
nmap dsF <Plug>DeleteSurroundingFUNCTION
nmap csf <Plug>ChangeSurroundingFunction
nmap csF <Plug>ChangeSurroundingFUNCTION
nmap ysf <Plug>YankSurroundingFunction
nmap ysF <Plug>YankSurroundingFUNCTION

" visual mode
xmap <silent> af <Plug>SelectWholeFunction
omap <silent> af <Plug>SelectWholeFunction
xmap <silent> aF <Plug>SelectWholeFUNCTION
omap <silent> aF <Plug>SelectWholeFUNCTION
xmap <silent> if <Plug>SelectWholeFunction
omap <silent> if <Plug>SelectWholeFunction
xmap <silent> iF <Plug>SelectWholeFUNCTION
omap <silent> iF <Plug>SelectWholeFUNCTION
xmap <silent> <space>an <Plug>SelectFunctionName
omap <silent> <space>an <Plug>SelectFunctionName
xmap <silent> <space>aN <Plug>SelectFunctionNAME
omap <silent> <space>aN <Plug>SelectFunctionNAME
xmap <silent> <space>in <Plug>SelectFunctionName
omap <silent> <space>in <Plug>SelectFunctionName
xmap <silent> <space>iN <Plug>SelectFunctionNAME
omap <silent> <space>iN <Plug>SelectFunctionNAME

" operator pending mode
" nmap <silent> gs <Plug>GripSurroundObject
" vmap <silent> gs <Plug>GripSurroundObject
" }}}
" {{{ textobj-user
call textobj#user#plugin('rpn', {
      \ 'fold': {
      \     'pattern': ['{{{', '}}}'],
      \     'select-a': 'az',
      \     'select-i': 'iz',
      \   }
      \ })
" }}}
" {{{ lua
" lua dofile(vim.env.XDG_CONFIG_HOME .. "/nvim/lua/test.lua")
lua dofile(vim.env.XDG_CONFIG_HOME .. "/nvim/lua/test.lua")
lua dofile(vim.env.XDG_CONFIG_HOME .. "/nvim/lua/init.lua")
" }}}
" {{{ vim-bookmarks
let g:bookmark_no_default_key_mappings = 1
let g:bookmark_save_per_working_dir = 1
let g:bookmark_auto_save = 1

nmap <space>mm <Plug>BookmarkToggle
nmap <space>mi <Plug>BookmarkAnnotate
nmap <space>ml <Plug>BookmarkShowAll
nmap <space>mj <Plug>BookmarkNext
nmap <space>mk <Plug>BookmarkPrev
nmap <space>mc <Plug>BookmarkClear
nmap <space>mx <Plug>BookmarkClearAll
nmap <space>mK <Plug>BookmarkMoveUp
nmap <space>mJ <Plug>BookmarkMoveDown
nmap <space>mg <Plug>BookmarkMoveToLine
" }}}
" {{{ neovim-remote
if has('nvim')
  let $GIT_EDITOR = 'nvr --remote-wait'
endif
" }}}
" {{{ vim-duck
nnoremap <space>dd :lua require("duck").hatch()<CR>
nnoremap <space>dk :lua require("duck").cook()<CR>
" }}}
" {{{ copilot.vim
" imap <silent><script><expr> <C-E> copilot#Accept("\<CR>")
" let g:copilot_no_tab_map = v:true
" }}}
" {{{ coc-deno
command! Deno execute ':CocCommand deno.initializeWorkspace'
nnoremap <space>deno :Deno<CR>
" }}}
" {{{ Terminal buffer configs

" For some reason WSL terminal shells don't start zsh
if IsWsl() && executable('zsh')
  let g:zsh_path = trim(system('which zsh'))
  execute "let &shell='".g:zsh_path."'"
endif

if has('nvim')
  augroup tmappings
    autocmd!
  augroup end

  " UI
  " hi! TermCursorNC ctermfg=1 ctermbg=2 cterm=NONE gui=NONE
  hi! TermCursorNC ctermfg=15 guifg=#fdf6e3 ctermbg=14 guibg=#93a1a1 cterm=NONE gui=NONE

  nnoremap <space>T :call ToggleProjectTerminal()<CR>
  nnoremap <space>sT :call RestartProjectTerminal()<CR>

  function! NewMiscTerm()
    let l:project_name = fnamemodify(getcwd(), ':t')
    let l:terminal_buf_name = 'term-' . l:project_name
    terminal
    call feedkeys(':keepalt file '.l:terminal_buf_name.'-')
  endfunction
  nnoremap <space>term :call NewMiscTerm()<CR>

  " Terminal mode binds tnoremap jk <C-\><C-N>
  tnoremap ;; <C-\><C-N>
  tnoremap <C-s> <C-\><C-n>
  tnoremap <C-q> <C-\><C-n>
  tnoremap <C-\><C-\> <C-n>
  tnoremap <C-\><C-s> <C-n>
  " tnoremap is0 iso8601

  " Use <C-\><C-r> in terminal insert mode to emulate <C-r> in insert mode
  " in a normal buffer (i.e. next key pastes from that buffer)
  tnoremap <expr> <C-\><C-r> '<C-\><C-n>"'.nr2char(getchar()).'pi'

  " Don't insert ^\ when using the above binding from muscle memory in the
  " wrong buffer type
  inoremap <C-\><C-r> <C-r>
  cnoremap <C-\><C-r> <C-r>

  " For some reason these break when in an ssh session?
  " tnoremap <C-p> <up>
  " tnoremap <C-n> <down>
  " tnoremap <C-f> <right>
  " tnoremap <C-b> <left>

  " Allow tmux navigator to work in :terminal
  " tnoremap <silent> <c-h> <c-\><c-n>:TmuxNavigateLeft<cr>
  " tnoremap <silent> <c-j> <c-\><c-n>:TmuxNavigateDown<cr>
  " tnoremap <silent> <c-k> <c-\><c-n>:TmuxNavigateUp<cr>
  " tnoremap <silent> <c-l> <c-\><c-n>:TmuxNavigateRight<cr>
  " tnoremap <silent> <c-\> <c-\><c-n>:TmuxNavigatePrevious<cr>

  " Neoterm / Vim-Test
  nnoremap \t :call ToggleProjectTerminal()<CR>

  " this plugin mapping is by default bound to ',tt' :facepalm:, which
  " introduces a delay when using ','
  " Bind it to something that will never get used or conflict with another
  " binding...
  let g:neoterm_automap_keys='\\\\\\\\'

  " ?? For some reason, after a while the binding stops working...
  " Wrapping it in another function seems ok.
  function! RunLastCommandInProjectTerminal()
    call OpenAndSendCmdToProjectTerminal("\<C-p>")
  endfunction

  nnoremap <space>tn :silent! :wall<CR>:TestNearest<CR>
  nnoremap <space>tf :silent! :wall<CR>:TestFile<CR>
  nnoremap <space>ts :silent! :wall<CR>:TestSuite<CR>
  nnoremap <space>tl :silent! :wall<CR>:TestLast<CR>
  nnoremap <space>to :TestVisit<CR>

  nnoremap <space>tp :call RunLastCommandInProjectTerminal()<CR>

  nnoremap <space>dn :silent! :wall<CR>:TestNearest -strategy=vimspector<CR>
  nnoremap <space>df :silent! :wall<CR>:TestFile -strategy=vimspector<CR>
  nnoremap <space>dl :silent! :wall<CR>:TestLast -strategy=vimspector<CR>
  nnoremap <space>ds :silent! :wall<CR>:TestSuite -strategy=vimspector<CR>

  nnoremap <space>dn :TestNearest -strategy=vimspector<CR>
  nnoremap <space>df :TestFile -strategy=vimspector<CR>
  nnoremap <space>ds :TestSuite -strategy=vimspector<CR>

  nnoremap <space>Dn :TestNearest -strategy=vimspector*<CR>
  nnoremap <space>Df :TestFile -strategy=vimspector*<CR>
  nnoremap <space>Ds :TestSuite -strategy=vimspector*<CR>

  nnoremap <space>tL :silent! :wall<CR>:Tkill<CR>:Tkill<CR>:TestLast<CR>
  nnoremap <space>tfile :TREPLSendFile<CR>
  vnoremap <space>tsel :TREPLSendSelection<CR>
  " nnoremap <space>tline :TREPLSendLine<CR>

  function! KillAndRunLastCommandInProjectTerminal()
    call OpenAndSendCmdToProjectTerminal("\<c-c>", 0)
    call OpenAndSendCmdToProjectTerminal("\<c-c>", 0)
    call OpenAndSendCmdToProjectTerminal("\<c-p>", 1)
  endfunction

  " nnoremap <space>tL :call OpenAndSendCmdToProjectTerminal("\<c-c>\<c-c>\<c-p>")
  nnoremap <space>tL :call KillAndRunLastCommandInProjectTerminal()<CR>
  nnoremap <space>tg :TestVisit<CR>
  nnoremap <space>tfile :TREPLSendFile<CR>
  vnoremap <space>tsel :TREPLSendSelection<CR>
  " nnoremap <space>tline :TREPLSendLine<CR>

  nmap gx <Plug>(neoterm-repl-send)
  xmap gx <Plug>(neoterm-repl-send)
  nmap gX <Plug>(neoterm-repl-send-line)
  xmap gX <Plug>(neoterm-repl-send-line)

  " neoterm settings
  let g:neoterm_autoscroll=1
endif
" }}}
" {{{ Misc
" things I don't want to commit to repo
" (tnoremap abbreviations for commonly used activerecord objects)
if filereadable($HOME.'/.vimrc.private')
  execute 'source '.$HOME.'/.vimrc.private'
endif

" Search highlight comes back after reloading vimrc.  Hide it
nohlsearch
" }}}

" Avoid code execution vulnerability
" Set again at the end to ensure no other upstream config mistakenly turned it
" back on
set nomodeline
