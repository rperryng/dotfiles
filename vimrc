" A void code execution vulnerability
set nomodeline

" TODO
" 2. Fix 'Coc*Float' highlight group for symbol backgrounds

let mapleader="\<Space>"

"{{{ Plugins

" {{{ Automatic vim-plug install
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

autocmd VimEnter * PlugInstall | source $MYVIMRC
endif
" }}}

call plug#begin('~/.local/share/nvim/plugged')

" :CocInstall coc-snippets
" :CocInstall coc-rust-analyzer
" :CocInstall coc-tsserver
" :CocInstall coc-solargraph
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Functionality
Plug 'AndrewRadev/splitjoin.vim'
Plug 'Julian/vim-textobj-variable-segment'
Plug 'KKPMW/vim-sendtowindow'
Plug 'SirVer/ultisnips'
Plug 'alvan/vim-closetag'
Plug 'arthurxavierx/vim-caser'
Plug 'christoomey/vim-tmux-navigator'
Plug 'dbakker/vim-projectroot'
Plug 'editorconfig/editorconfig-vim'
Plug 'gcmt/taboo.vim'
Plug 'gisphm/vim-gitignore'
Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
Plug 'haya14busa/incsearch-fuzzy.vim'
Plug 'haya14busa/incsearch.vim'
Plug 'honza/vim-snippets'
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
Plug 'mcchrish/nnn.vim'
Plug 'michaeljsmith/vim-indent-object'
Plug 'moll/vim-bbye'
Plug 'nelstrom/vim-textobj-rubyblock'
Plug 'prakashdanish/vim-githubinator'
Plug 'prettier/vim-prettier'
Plug 'rperryng/nvim-contabs'
Plug 'segeljakt/vim-isotope'
Plug 'simeji/winresizer'
Plug 'sjl/gundo.vim'
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
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vim-ruby/vim-ruby'
Plug 'vimwiki/vimwiki'
Plug 'wellle/targets.vim'

" UI
Plug 'arzg/seoul8'
Plug 'chriskempson/base16-vim'
Plug 'drewtempelmeyer/palenight.vim'
Plug 'haya14busa/vim-asterisk'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install' }
Plug 'joshdick/onedark.vim'
Plug 'jparise/vim-graphql'
Plug 'junegunn/seoul256.vim'
Plug 'junegunn/vim-journal'
Plug 'machakann/vim-highlightedyank'
Plug 'mhinz/vim-signify'
Plug 'morhetz/gruvbox'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'patstockwell/vim-monokai-tasty'
Plug 'peitalin/vim-jsx-typescript'
Plug 'psliwka/vim-smoothie'
Plug 'qxxxb/vim-searchhi'
Plug 'rakr/vim-one'
Plug 'rust-lang/rust.vim'
Plug 'udalov/kotlin-vim'
Plug 'webdevel/tabulous'
Plug 'wlangstroth/vim-racket'

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
" Ruby
if executable('pyenv')
  let g:python_host_prog=trim(system('pyenv '))"/Users/ryanperry-nguyen/.pyenv/versions/neovim2/bin/python"
  let g:python_host_prog="/Users/ryanperry-nguyen/.pyenv/versions/neovim2/bin/python"
  let g:python3_host_prog="/Users/ryanperry-nguyen/.pyenv/versions/neovim3/bin/python"
else
  echom "missing pyenv.  No python host set."
endif

" Ruby
if executable('rbenv')
  let g:ruby_host_prog=trim(system('rbenv which ruby'))
else
  echom "Missing rbenv.  No ruby host set."
endif

" Node
if executable('nodenv')
  let g:node_host_prog=trim(system('nodenv which node'))
  let g:coc_node_path=g:node_host_prog
else
  echom "Missing nodenv.  No ruby host set."
endif

" }}}
" {{{ Autocmd

augroup focusgroup
autocmd!
" Preserve cursor location when switching buffers
" autocmd BufLeave * let b:winview = winsaveview()
" autocmd BufEnter * if(exists('b:winview')) | call winrestview(b:winview) | endif
autocmd FocusGained,BufEnter * :silent! checkt
" autocmd FocusGained,BufEnter index.wiki :silent execute 'normal zR'

" Preserve folds between vim sessions
" autocmd BufWinLeave * silent! mkview
" autocmd BufWinEnter * silent! loadview
augroup end

augroup dir
autocmd!
augroup end

augroup filetypes
  autocmd!
  autocmd BufNewFile,BufReadPost *.md set filetype=markdown
  autocmd BufNewFile,BufReadPost *.jshintrc set filetype=javascript
  autocmd BufNewFile,BufReadPost *.zshrc set filetype=zsh
  autocmd BufNewFile,BufReadPost *.org set filetype=org
  autocmd BufNewFile,BufReadPost *.journal set filetype=journal

  autocmd FileType vim,markdown,json setlocal conceallevel=0

  autocmd FileType ruby setlocal colorcolumn=101
  autocmd FileType ruby setlocal textwidth=100
  autocmd FileType yaml setlocal commentstring=#\ %s
  autocmd FileType tsx setlocal commentstring=//\ %s
  autocmd FileType python setlocal nosmartindent
  autocmd FileType netrw setlocal nosmartindent

  autocmd FileType org setlocal shiftwidth=4 tabstop=4 softtabstop=4
  autocmd FileType typescript setlocal shiftwidth=4 tabstop=4 softtabstop=4
  autocmd FileType rust setlocal shiftwidth=4 tabstop=4 softtabstop=4

  autocmd FileType rust nnoremap <buffer> <space>fo :RustFmt<CR>
  autocmd FileType typescript nnoremap <buffer> <space>fo :PrettierAsync<CR>

  " Help prevent accidentally modifying external source code resolved via
  " ctags or LSP functionality.
  autocmd BufReadPost */.cargo/*,*/.rustup/* setlocal readonly

  " hacky-fix for coc-vim leaving the popup menu window open when creating a ruby
  " block
  autocmd FileType ruby inoremap <Space>do <Space>do<Space><Backspace>
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

" syntax enable
let g:gruvbox_contrast_dark="hard"
" let g:gruvbox_hls_cursor="orange"
colorscheme gruvbox
" colorscheme gruvbox
set background=dark


" Start and End tags are same color
" highlight Tag        ctermfg=04
" highlight xmlTag     ctermfg=04
" highlight xmlTagName ctermfg=04
" highlight xmlEndTag  ctermfg=04

" hi StatusLine   ctermfg=15  guifg=#ffffff ctermbg=239 guibg=#4e4e4e cterm=bold gui=bold
" hi StatusLineNC ctermfg=249 guifg=#b2b2b2 ctermbg=237 guibg=#3a3a3a cterm=none gui=none
" hi VertSplit    ctermfg=15  guifg=#b2b2b2 ctermbg=237 guibg=#3a3a3a cterm=none gui=none

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
set colorcolumn=80
set synmaxcol=200
set signcolumn=yes
set scrolloff=0
set sidescrolloff=15
set showcmd
set splitbelow
set splitright
set wildmode=list:longest
set nowrap
set noequalalways
set showtabline=2

set list
set listchars=tab:>-,trail:~

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

" Show trailing whitespace with error highlighting group
highlight! link Whitespace Error

" Searching
set ignorecase
set smartcase
set inccommand=split
" }}}
" {{{ Functions/Commands

function! EqualWindowHorizontally()
endfunction

function! OnlyWindow()
  let currwin=winnr()
endfunction

" Preferred Layout When starting a new session
function! Layout()
  edit ~/vimwiki/index.wiki
  vsplit
  edit ~/vimwiki/Standup.wiki
  vsplit
  edit ~/vimwiki/misc_TODO.wiki
  TabooRename Today
  tabedit ~/.vimrc
  vertical help
  TabooRename Vim
  tabedit
  split

  if bufexists('term-misc')
    buffer term-misc
  else
    terminal
    file term-misc
  endif

  wincmd k
  execute 'TabooRename ' . fnamemodify(getcwd(), ':t')
endfunction

command! -nargs=0 Layout call Layout()

" Easily insert new vimwiki TODO items
function! Todo(...)
  edit ~/vimwiki/misc_TODO.wiki
  execute 'normal G'

  if a:0 > 0
    execute 'normal o' . join(a:000)
  endif
endfunction

command! -nargs=* Todo call Todo(<f-args>)

function! Tabe(name)
  tabedit
  split
  terminal
  execute 'TabooRename ' . a:name
  execute 'TZ ' . a:name
  execute 'file term-misc-' . a:name
  call feedkeys('az ' . a:name . "\<CR>")
endfunction

command! -nargs=1 TE call Tabe(<q-args>)

function! CursorSaveAndTabulous()
  let t:active_windownr = winnr()
  execute winnr('$') . 'wincmd w'
endfunction

function! CursorRestore()
  execute t:active_windownr . 'wincmd w'
endfunction

" Get terminal output
tnoremap <C-Enter> <C-\><C-n>mza<CR>

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

" Sjlow Paste
""""""""""""
" Paste 10 lines to the window below
function! SlowPaste()
  HighlightedyankOff
  normal qp
  silent .,+9yank
  normal 10j
  wincmd j
  put 0
  wincmd k
  normal q
  HighlightedyankOn
endfunction

command! SlowPaste call SlowPaste()

function! SlowPasteRange() range
  echo split(GetVisualSelection(), "\n")
  " for i in split(GetVisualSelection(), "\n")

  " endfor
  " echo "firstline ".a:firstline." lastline ".a:lastline
  " echo "firstline contents" . getline(a:firstline)
  " echo "lastline contents" . getline(a:lastline)
endfunction

command! -range SlowPasteRange <line1>,<line2>call SlowPasteRange()

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
  wincmd=
  execute winnr("$") . 'wincmd w'

  let new_size = min([14, &lines / 4])
  execute "resize" . new_size
  execute currwin . 'wincmd w'
endfunction

nnoremap <space>w= :silent call TerminalResize()<CR>

" Change working directory using ProjectRootCD
""""""""""""""""""""""""""""""""""""""""""""""
function! ProjectRootCDAll()
  let currwin=winnr()
  let root=ProjectRootGuess()
  let cd_command = 'tcd ' . root
  execute cd_command
  echo root

endfunction

command! -nargs=0 ProjectRootCDAll call ProjectRootCDAll()

" Remove all buffers from other projects
function! ClearOtherBuffers()
  bdelete bdelete ~/code/<C-a>
endfunction

command! -nargs=0 ClearOtherBuffers call ClearOtherBuffers()

" Format JSON
"""""""""""""
function! FormatJson()
  execute '%!python -m json.tool'
  execute 'normal! gg=G'
endfunction
command! FormatJson call FormatJson()

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

" Start Ruby LSP for project of current file
""""""""""""""""""""""""""""""""""""""""""""
" function! Solargraph()
"   execute 'ProjectRootCD'
"   let solargraph_buffer_name = 'term-solargraph-' . fnamemodify(getcwd(), ':t')

"   if bufexists(solargraph_buffer_name)
"     echom solargraph_buffer_name . ' already running!'
"     execute 'buffer ' . solargraph_buffer_name
"     return
"   endif

"   botright split
"   terminal solargraph socket
"   let rename_buffer_command = 'file ' . solargraph_buffer_name
"   execute rename_buffer_command
" endfunction

" command! Solargraph :call Solargraph()

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
    put! "\r"
    put! =strftime('= %A - %B %d %Y =')
    " execute "normal! o*\<Space>"
    startinsert!
  elseif search(l:date_formatted . '\n\%(\*.*\)\{1,}\n$', 'e') != 0
    execute "normal! G{{}O*\<Space>"
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

" Shameleslly stolen from
" https://github.com/arithran/vim-delete-hidden-buffers/blob/master/plugin/delete-hidden-buffers.vim
if !exists("*DeleteHiddenBuffers") " Clear all hidden buffers when running
  function DeleteHiddenBuffers() " Vim with the 'hidden' option
    let tpbl=[]
    call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
    for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
      silent execute 'bwipeout' buf
    endfor
  endfunction
  endif
command! DeleteHiddenBuffers call DeleteHiddenBuffers()

function NNStart()
  edit ~/.vimrc
  cd ~/code/dotfiles
  split
  terminal
  file term-misc-dotfiles
  call TerminalResize()
  TabooRename dotfiles
endfunction
" }}}
" {{{ Mappings

cnoremap <c-\><c-f> <c-f>
cnoremap <c-\><c-a> <c-a>

nnoremap gh ^
xnoremap gh ^
nnoremap gl $
xnoremap gl $h

" :)
nnoremap s <Nop>
nnoremap Q <nop>

" Insert mode maps
inoremap jk <Esc>
inoremap <C-s> <Esc>
cnoremap <C-s> <Esc>

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

xnoremap il g_o^
onoremap il :normal vil<CR>
xnoremap al $o0
xnoremap il g_o^

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
nnorema K a<Enter><Esc>

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
nnoremap st ml:tabedit %<CR>`l

" Make windows equal but shrink the bottommost window to 20 lines (usually a
" terminal buffer)
" nnoremap <space>w= <C-w>=<C-w>j:res 20<CR><C-w>k

" Weird hack.  Sometimes the scrolloff option breaks for a terminal buffer
" if the terminal buffer was present in another window with different
" dimensions.
nnoremap <space>w<space> :resize +1<CR>:resize -1<CR>

" Reload vimrc
nnoremap <space>E :edit $MYVIMRC<CR>
nnoremap <space>R :source $MYVIMRC<CR>

" Toggle scrolloff
" nnoremap <space>zz :let &scrolloff=999-&scrolloff<CR>

nnoremap <space>l <C-^>
" nnoremap <space>sl :nohlsearch<CR>
" nnoremap <space>sL :set hlsearch<CR>
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
nnoremap sF :file<space>
" }}}
" {{{ Plugin Config

" {{{ NNN
let g:nnn#command = 'nnn -H'
let g:nnn#action = {
      \ '<c-t><c-t>': 'tab split',
      \ '<c-s><c-s>': 'split',
      \ '<c-v>': 'vsplit' }

nnoremap <leader>n :NnnPicker<CR>
nnoremap <space>N :NnnPicker %:p:h<CR>
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

function! TabRename(...)
  let current_directory = fnamemodify(getcwd(), ':t')
  let name = get(a:, 1, '')

  let tab_name = current_directory
  if name != ''
    let tab_name = tab_name . '-' . name
  endif

  echo substitute(tab_name, "\n", "", "")
  silent! execute 'TabooRename ' . tab_name
  execute 'normal! :TabooRename ' . current_directory . '-'
endfunction

command! -nargs=0 TabRename call TabRename(<f-args>)

nnoremap <space>tr :TabooRename<space>
nnoremap <silent> <space>tR :execute 'TabooRename ' . expand('%')<CR>
" nnoremap <space>tR :execute 'TabooRename ' . fnamemodify(getcwd(), ':t')<CR>
" }}}
" {{{ gundo
nnoremap <space>gu :GundoToggle<CR>
" }}}
" {{{ vim-easy-align
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
" }}}
" {{{ FZF
let $FZF_DEFAULT_OPTS .= ' --color=bg:#1d2021 --border --no-height --layout=reverse'

if executable('rg')
  let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
  set grepprg=rg\ --vimgrep
  command! -bang -nargs=* Find
    \ call fzf#vim#grep(
    \   'rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"',
    \   1,
    \   <bang>0
    \ )
endif

" floating fzf window with borders
function! CreateCenteredFloatingWindow()
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
    call nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
    au BufWipeout <buffer> exe 'bw '.s:buf
endfunction

let g:fzf_layout = { 'window': 'call CreateCenteredFloatingWindow()' }

" if has('nvim-0.4.0')
"   function! FloatingFZF()
"     let width = float2nr(&columns * 0.9)
"     let height = float2nr(&lines * 0.6)
"     let opts = { 'relative': 'editor',
"           \ 'row': (&lines - height) / 2,
"           \ 'col': (&columns - width) / 2,
"           \ 'width': width,
"           \ 'height': height,
"           \ 'style': 'minimal'
"           \}

"     let win = nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
"     call setwinvar(win, '&winhighlight', 'NormalFloat:TabLine')
"   endfunction

"   let g:fzf_layout = { 'window': 'call FloatingFZF()' }
" endif

" :like :Rg but only search file content, i.e. do not match directories
command! -bang -nargs=* RG
  \ call fzf#vim#grep(
  \   "rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>),
  \   1,
  \   fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}),
  \   <bang>0)

command! -bang -nargs=* RI
  \ call fzf#vim#grep(
  \   'rg --no-ignore --column --line-number --no-heading --fixed-strings --smart-case --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"',
  \   1,
  \   <bang>0
  \ )

" mnemonic: fzf all
nnoremap <space>fA :RI<CR>

function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --no-ignore --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)
" mnemonic: straight up ripgrep with no fzf syntax support accross all files
nnoremap <space>rg :RG<CR>

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

command! -nargs=? -complete=dir AllFiles
  \ call fzf#vim#files(
  \   <q-args>,
  \   fzf#vim#with_preview(),
  \   <bang>0
  \ )

command! -nargs=? -complete=dir GFiles
  \ call fzf#vim#gitfiles(
  \   <q-args>,
  \   fzf#vim#with_preview(),
  \   <bang>0
  \ )

command! TerminalBuffers
  \ call fzf#vim#buffers(
  \  '.',
  \  {'options': ['--query', '^term ']},
  \  <bang>0
  \ )

" :Rg, prepopulate search with '!spec '
  " \   fzf#vim#with_preview({'options': ['--query', '!spec ']}),
command! -bang -nargs=* RgNoSpec
  \ call fzf#vim#grep(
  \   "rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>),
  \   1,
  \   <bang>0
  \ )

" command! -bang -nargs=* RG
"   \ call fzf#vim#grep(
"   \   "rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>),
"   \   1,
"   \   fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}),
"   \   <bang>0)

nnoremap <space><C-f> :GFiles<CR>

nnoremap <space>fb :Buffers<CR>
nnoremap <space>fc :Commands<CR>
nnoremap <space>fi :Files<CR>
nnoremap <space>fh :Helptags<CR>
nnoremap <space>flb :BLines<CR>
nnoremap <space>fla :Lines<CR>
nnoremap <space>fm :Marks<CR>
nnoremap <space>fg :GFiles?<CR>
nnoremap <space>fw :Windows<CR>
nnoremap <space>fa :Rg<CR>
nnoremap <space>fA :RG<CR>
nnoremap <space>fr :Rg<CR>
nnoremap <space>ft :TerminalBuffers<CR>
nnoremap <space>fsa :RgNoSpec<CR>

nnoremap <space>fB :Buffers!<CR>
nnoremap <space>fC :Commands!<CR>
nnoremap <space>fI :Files!<CR>
nnoremap <space>flB :BLines!<CR>
nnoremap <space>flL :Lines!<CR>
nnoremap <space>fT :TerminalBuffers!<CR>
nnoremap <space>fM :Marks!<CR>
nnoremap <space>fG :GFiles?!<CR>
nnoremap <space>fW :Windows!<CR>
nnoremap <space>fR :Rg!<CR>

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
nnoremap <space>WR :WinResizerStartResize<CR>
let g:winresizer_start_key = '<C-Q>'
" }}}
" {{{ vim-fugitive
nnoremap <space>gst :Gstatus<CR>
nnoremap <space>gsp :Gstatus<CR>
nnoremap <space>gvs :Gvsplit<CR>
nnoremap <space>blame :tabedit %<CR>:Gblame<CR><C-w>lV
" }}}
" {{{ project-root-cd
" Change current working directory of all windows in tab to project root of current buffer
function! TcdProjectRoot()
  let l:project_root = ProjectRootGet()

  if l:project_root == ''
    let l:project_root = "~/"
  endif

  execute 'tcd ' . l:project_root
  echo 'switched to "' . l:project_root . '"'
endfunction
nnoremap <space>cd :call TcdProjectRoot()<CR>
" nnoremap <space>cd :execute 'tcd ' . ProjectRootGet()<CR>
" }}}
" {{{ coc-nvim
nmap slR :CocRestart<CR>
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gn <Plug>(coc-diagnostic-next)
nmap <silent> gp <Plug>(coc-diagnostic-prev)
nmap <silent> <space>re <Plug>(coc-refactor)
nmap <silent> <space>rn <Plug>(coc-rename)
nmap <silent> <space>rn <Plug>(coc-list)
nnoremap <silent> <space>gl :CocList diagnostics<CR>
inoremap <silent><expr> <c-space> coc#refresh()

nnoremap K :call CocAction('doHover')<CR>
" vmap <silent> re <Plug>(coc-refactor)
vmap <silent> <space>ac :CocAction<CR>

imap <silent><expr> <c-k> <Plug>(coc-float-jump)
nmap <silent> gF <Plug>(coc-float-jump)
nmap <silent> gH <Plug>(coc-float-hide)
nmap <silent> <esc> <Plug>(coc-float-hide)

imap <silent> <c-l> <Esc>:call CocActionAsync('showSignatureHelp')<CR>a

inoremap <silent><expr> <tab>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

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

inoremap <silent><expr> <down> coc#util#has_float() ? FloatScroll(1) : "\<down>"
inoremap <silent><expr> <up> coc#util#has_float() ? FloatScroll(0) :  "\<up>"

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
" }}}
" {{{ vim-test
let test#ruby#rspec#executable = 'bundle exec rspec'
" }}}
" {{{ closetag
let g:closetag_filenames = '*.html,*.xhtml,*.jsx,*.js'
let g:closetag_xhtml_filenames = '*.xhtml,*.jsx,*.js'
let g:closetag_shortcut = '>'
" }}}
" {{{ vim-indentline
let g:indentLine_color_gui = '#5b5b5b'
let g:indentLine_fileTypeExclude=['markdown', 'json']
let g:indentLine_bufTypeExclude=['help', 'terminal']
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
" nmap <silent> <space>wa :silent! :wall<CR>:set nohlsearch<CR>
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
" }}}
" {{{ nvim-contabs
let g:contabs#project#locations = [
  \ { 'path': '~/code', 'depth': 3, 'git_only': v:true },
  \ { 'path': '~/code', 'depth': 2, 'git_only': v:true },
  \ { 'path': '~/code', 'depth': 1, 'git_only': v:true },
  \ { 'path': '~/code', 'depth': 0, 'git_only': v:true },
  \]

function! ContabsNewTab(cmd, context)
  let [ l:location, l:directory ] = a:context
  let l:project_name = fnamemodify(l:directory, ':t')

  tabedit
  echom 'switched to "' . l:directory . '"'
  execute 'TabooRename ' . l:project_name
  execute 'tcd' . l:directory

  split
  terminal
  call TerminalResize()

  let l:buf_name = 'term-misc-' . l:project_name
  if (bufexists(l:buf_name))
    edit l:buf_name
  else
    execute 'file ' . l:buf_name
  endif

  wincmd t
endfunction

nnoremap <silent> <space>fp :call contabs#window#open(
      \ 'projects',
      \ contabs#project#paths(),
      \ funcref('ContabsNewTab'),
      \ [ 'edit', { 'ctrl-t': 'tabedit', 'ctrl-e': 'edit' } ],
      \ )
      \ <CR>

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
" nmap <silent> <space>oi ^f{gSjvi}:s/\(,\)\@<!$/,/<CR>vi}:sort<CR>/}<CR>:nohlsearch<CR>k$xva}JxF{lxj^f{
nmap <silent> <Plug>SortInline ^f{gSjvi}:s/\(,\)\@<!$/,/<CR>vi}:sort<CR>/}<CR>:nohlsearch<CR>k$xva}JxF{lxj^f{
  \:call repeat#set("\<Plug>SortInline")<CR>
nmap <space>oi <Plug>SortInline

" }}}
" {{{ vim-bbye
nnoremap <space>bd :Bdelete!<CR>
nnoremap <space>bw :Bwipeout!<CR>
" }}}
" {{{ vim-githubinator
let g:githubinator_no_default_mapping=1
nmap <space>gho <Plug>(githubinator-open)
nmap <space>ghc <Plug>(githubinator-copy)
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

function! CreateCenteredFloatingWindow()
    let width = float2nr(&columns * 0.6)
    let height = float2nr(&lines * 0.6)
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
    call nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
    au BufWipeout <buffer> exe 'bw '.s:buf
endfunction

let g:peekaboo_window="call CreateCenteredFloatingWindow()"
" }}}
" {{{ vim-gutentags
let g:gutentags_enabled=1
" }}}

" }}}
" {{{ Terminal buffer configs

if has('nvim')
  augroup tmappings
    autocmd!
    autocmd TermOpen * setlocal scrollback=50000

    " Dumb hack because something something scrolloff in terminal windows?
    " autocmd InsertEnter * if &l:buftype ==# 'terminal' | res +1 | res -1 | endif
    autocmd InsertEnter * if &l:buftype ==# 'terminal' | res +1 | res -1 | endif
  augroup end

  " UI
  " hi! TermCursorNC ctermfg=1 ctermbg=2 cterm=NONE gui=NONE
  hi! TermCursorNC ctermfg=15 guifg=#fdf6e3 ctermbg=14 guibg=#93a1a1 cterm=NONE gui=NONE

  " Vim-test
  let test#strategy = 'neoterm'

  function! OpenNeoterm()
    if bufexists('neoterm')
      buffer neoterm
      return
    endif

    botright split
    enew
    execute 'Tnew'
    resize 20
    sleep 200m
    file neoterm
  endfunction
  nnoremap <space>T :call OpenNeoterm()<CR>

  nnoremap <space>term :terminal<CR>:file term-

  " Terminal mode binds tnoremap jk <C-\><C-N>
  tnoremap ;; <C-\><C-N>
  tnoremap <C-x><C-x> <C-\><C-N>
  tnoremap <C-s> <C-\><C-n>
  tnoremap <C-q> <C-\><C-n>
  tnoremap <C-y> <C-\><C-N>
  tnoremap granch $(g_branch)
  tnoremap is0 iso8601

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
  nnoremap <space>td :T <C-d>
  nnoremap <space>tn :silent! :wall<CR>:TestNearest<CR>
  nnoremap <space>tf :silent! :wall<CR>:TestFile<CR>
  nnoremap <space>ts :silent! :wall<CR>:TestSuite<CR>
  nnoremap <space>tl :silent! :wall<CR>:TestLast<CR>
  nnoremap <space>tL :silent! :wall<CR>:Tkill<CR>:Tkill<CR>:TestLast<CR>
  nnoremap <space>tg :TestVisit<CR>
  nnoremap <space>tfile :TREPLSendFile<CR>
  vnoremap <space>tsel :TREPLSendSelection<CR>
  nnoremap <space>tline :TREPLSendLine<CR>

  nmap gx <Plug>(neoterm-repl-send)
  xmap gx <Plug>(neoterm-repl-send)
  nmap gX <Plug>(neoterm-repl-send-line)
  xmap gX <Plug>(neoterm-repl-send-line)

  nnoremap sT :tabedit<CR>:enew<CR>:terminal<CR>:file term-

  " neoterm settings
  let g:neoterm_autoscroll=1
endif
" }}}
" {{{ Misc
" things I don't want to commit to repo
" (tnoremap abbreviations for commonly used activerecord objects)
source ~/.vimrc.private

" Search highlight comes back after reloading vimrc.  Hide it
nohlsearch
" }}}

" Avoid code execution vulnerability
" Set again at the end to ensure no other upstream config mistakenly turned it
" back on
set nomodeline
