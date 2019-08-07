" Avoid code execution vulnerability
set nomodeline

" TODO
" 1. Make nnn filetype binding for <Esc><C-L> to remove weird delay after
" closing prompt
" 2. Install Vim plug if not found

let mapleader="\<Space>"

"{{{ Plugins

" {{{ Automatic vim-plug install
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif
" }}}

call plug#begin('~/.local/share/nvim/plugged')

" :CocInstall coc-snippets
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Functionality
Plug 'AndrewRadev/splitjoin.vim'
Plug 'KKPMW/vim-sendtowindow'
Plug 'SirVer/ultisnips'
Plug 'alvan/vim-closetag'
Plug 'christoomey/vim-tmux-navigator'
Plug 'dbakker/vim-projectroot'
Plug 'gcmt/taboo.vim'
Plug 'haya14busa/incsearch-fuzzy.vim'
Plug 'haya14busa/incsearch.vim'
Plug 'honza/vim-snippets'
Plug 'janko-m/vim-test'
Plug 'jesseleite/vim-agriculture'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/gv.vim'
Plug 'junegunn/vim-easy-align'
Plug 'kana/vim-textobj-user'
Plug 'kassio/neoterm'
Plug 'ludovicchabant/vim-gutentags'
Plug 'mcchrish/nnn.vim'
Plug 'michaeljsmith/vim-indent-object'
Plug 'nelstrom/vim-textobj-rubyblock'
Plug 'prakashdanish/vim-githubinator'
Plug 'raghur/vim-ghost', {'do': ':GhostInstall'}
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
Plug 'junegunn/vader.vim'

" UI
Plug 'Yggdroot/indentLine'
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
Plug 'patstockwell/vim-monokai-tasty'
Plug 'qxxxb/vim-searchhi'
Plug 'rakr/vim-one'
Plug 'udalov/kotlin-vim'
Plug 'webdevel/tabulous'

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
let g:python_host_prog='/Users/rperrynguyen/.pyenv/versions/neovim2/bin/python'
let g:python3_host_prog='/Users/rperrynguyen/.pyenv/versions/neovim3/bin/python'

" Ruby
let g:ruby_host_prog='/Users/rperrynguyen/.rbenv/versions/2.5.1/bin/ruby'
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
  autocmd FileType org setlocal shiftwidth=1
  autocmd FileType org setlocal shiftwidth=1 tabstop=1
  autocmd FileType python setlocal nosmartindent

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
" let g:gruvbox_contrast_dark="hard"
" let g:gruvbox_hls_cursor="orange"
colorscheme gruvbox
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
set scrolloff=15
set sidescrolloff=15
set showcmd
set splitbelow
set splitright
set wildmode=list:longest
set nowrap
set noequalalways

set list
set listchars=tab:>-,trail:+

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
nnoremap <leader>gJ :call JoinSpaceless()<CR>
xnoremap <leader>gJ :call JoinSpaceless()<CR>

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
  resize 20
  execute currwin . 'wincmd w'
endfunction

nnoremap <leader>w= :silent call TerminalResize()<CR>

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
  split ~/vimwiki/Standup.wiki
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
command! Today :call Today()

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

" }}}
" {{{ Mappings

cnoremap <c-\><c-f> <c-f>
cnoremap <c-\><c-a> <c-a>

nnoremap H ^
xnoremap H ^
nnoremap L g_
xnoremap L g_

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
onoremap <silent> <expr> al v:count==0 ? ":<c-u>normal! 0V$h<cr>" : ":<c-u>normal! V" . (v:count) . "jk<cr>"
vnoremap <silent> <expr> al v:count==0 ? ":<c-u>normal! 0V$h<cr>" : ":<c-u>normal! V" . (v:count) . "jk<cr>"
onoremap <silent> <expr> il v:count==0 ? ":<c-u>normal! ^vg_<cr>" : ":<c-u>normal! ^v" . (v:count) . "jkg_<cr>"
vnoremap <silent> <expr> il v:count==0 ? ":<c-u>normal! ^vg_<cr>" : ":<c-u>normal! ^v" . (v:count)

" Close all folds except the current one
nnoremap <leader>z zMzv

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
nnoremap <leader><c-]> viwlg<c-]>
nnoremap <leader>* viwl*

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
nnoremap <leader>e //e<CR>

" Replace
nnoremap <leader>/ :%s/<C-r>=expand('<cword>')<CR>//g<left><left>
" onoremap <leader>/ :s/<C-r>=expand('<cword>')<CR>//g<left><left>
xnoremap <leader>/ :s/

" Open buffer in new tab and go to current position
nnoremap st ml:tabedit %<CR>`l

" Make windows equal but shrink the bottommost window to 20 lines (usually a
" terminal buffer)
" nnoremap <leader>w= <C-w>=<C-w>j:res 20<CR><C-w>k

" Weird hack.  Sometimes the scrolloff option breaks for a terminal buffer
" if the terminal buffer was present in another window with different
" dimensions.
nnoremap <leader>w<space> :res +1<CR>:res -1<CR>

" Reload vimrc
nnoremap <leader>R :source $MYVIMRC<CR>

" Toggle scrolloff
" nnoremap <leader>zz :let &scrolloff=999-&scrolloff<CR>

nnoremap <leader>l <C-^>
" nnoremap <leader>sl :nohlsearch<CR>
" nnoremap <leader>sL :set hlsearch<CR>
nnoremap set :buffer term-<C-d>

nnoremap <leader>1 1gt
nnoremap <leader>2 2gt
nnoremap <leader>3 3gt
nnoremap <leader>4 4gt
nnoremap <leader>5 5gt
nnoremap <leader>6 6gt
nnoremap <leader>7 7gt
nnoremap <leader>8 8gt
nnoremap <leader>9 9gt

nnoremap <leader>= "+
nnoremap <leader>y "+y
nnoremap <leader>p "+p
vnoremap <leader>y "+y
vnoremap <leader>p "+p

nnoremap <leader>tq :tabclose<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>bd :bprevious <bar> bdelete! #<CR>
nnoremap <C-n> :tabnext<CR>
nnoremap <C-p> :tabprevious<CR>
nnoremap sn :tabnext<CR>
nnoremap sp :tabprevious<CR>

nnoremap sf :set filetype=
nnoremap sF :file<space>
" }}}
" {{{ Plugin Config

" {{{ NNN
let g:nnn#command = 'nnn -l'
let g:nnn#action = {
      \ '<c-t><c-t>': 'tab split',
      \ '<c-s><c-s>': 'split',
      \ '<c-v>': 'vsplit' }

nnoremap <leader>N :NnnPicker '%:p:h'<CR>
" }}}
" {{{ send-to-window
let g:sendtowindow_use_defaults=0
nmap <leader>wl <Plug>SendRight
xmap <leader>wl <Plug>SendRightV
nmap <leader>wh <Plug>SendLeft
xmap <leader>wh <Plug>SendLeftV
nmap <leader>wk <Plug>SendUp
xmap <leader>wk <Plug>SendUpV
nmap <leader>wj <Plug>SendDown
xmap <leader>wj <Plug>SendDownV
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

nnoremap <leader>tr :TabooRename<space>
nnoremap <leader>TR :TabRename<space>
" nnoremap <leader>tR :execute 'TabooRename ' . fnamemodify(getcwd(), ':t')<CR>
" }}}
" {{{ gundo
nnoremap <leader>gu :GundoToggle<CR>
" }}}
" {{{ vim-easy-align
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
" }}}
" {{{ FZF
let $FZF_DEFAULT_OPTS .= ' --no-height'

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

" :like Ag but only search file content, i.e. do not match directories
command! -bang -nargs=* AG
  \ call fzf#vim#ag(
  \   <q-args>,
  \   fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}),
  \   <bang>0
  \ )

" :Tags
command! -nargs=* Tags
  \ call fzf#vim#tags(
  \   <q-args>,
  \   {'options': '--delimiter : --nth 4..'},
  \   <bang>0
  \ )

command! -nargs=? -complete=dir Files
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

nnoremap <C-f> :GFiles<CR>
nnoremap <leader><C-f> :GFiles!<CR>

nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>fc :Commands<CR>
nnoremap <leader>fi :Files<CR>
nnoremap <leader>fh :Helptags<CR>
nnoremap <leader>flb :BLines<CR>
nnoremap <leader>fla :Lines<CR>
nnoremap <leader>fm :Marks<CR>
nnoremap <leader>fg :GFiles?<CR>
nnoremap <leader>fw :Windows<CR>
nnoremap <leader>fa :Rg<CR>
nnoremap <leader>fr :Rg<CR>
nnoremap <leader>ft :TerminalBuffers<CR>
nnoremap <leader>ag :Ag<CR>
nnoremap <leader>fA :Ag!<CR>
nnoremap <leader>AG :AG<CR>
nnoremap <leader><leader> :RgNoSpec<CR>

nnoremap <leader>fB :Buffers!<CR>
nnoremap <leader>fC :Commands!<CR>
nnoremap <leader>fI :Files!<CR>
nnoremap <leader>flB :BLines!<CR>
nnoremap <leader>flL :Lines!<CR>
nnoremap <leader>fT :TerminalBuffers!<CR>
nnoremap <leader>fM :Marks!<CR>
nnoremap <leader>fG :GFiles?!<CR>
nnoremap <leader>fW :Windows!<CR>
nnoremap <leader>fR :Rg!<CR>

imap <c-x><c-f> <plug>(fzf-complete-path)
" }}}
"{{{ vim-agriculture
function! RgVisualSelection()
  execute ':RgRaw ' . GetVisualSelection()
endfunction

" Setup query
nnoremap <leader>f; :RgRaw<Space>

" Perform :RgRaw search with word under cursor
nnoremap <leader>f* :execute ':RgRaw' expand('<cword>')<CR>

" Perform :RgRaw with current visual selection
xnoremap <leader>f* :call RgVisualSelection()<CR>
"}}}
" {{{ fuzzy incsearch
map s/ <Plug>(incsearch-fuzzy-/)
map s? <Plug>(incsearch-fuzzy-?)
map sg/ <Plug>(incsearch-fuzzy-stay)
" }}}
" {{{ win-reszier
nnoremap <leader>WR :WinResizerStartResize<CR>
" }}}
" {{{ vim-fugitive
nnoremap <leader>gst :Gstatus
nnoremap <leader>gsp :Gstatus
nnoremap <leader>gvs :Gvsplit
nnoremap <leader>blame :tabedit %<CR>:Gblame<CR><C-w>lV
" }}}
" {{{ project-root-cd
" Change current working directory to project root of current buffer
nnoremap <leader>cd :ProjectRootCDAll<CR>
" }}}
" {{{ coc-nvim
nmap slR :CocRestart<CR>
nmap slgd <Plug>(coc-definition)
nmap slgd <Plug>(coc-definition)
nmap slrn <Plug>(coc-rename)
nmap slre <Plug>(coc-references)

" nmap <silent> [c <Plug>(coc-diagnostic-prev)
" nmap <silent> ]c <Plug>(coc-diagnostic-next)
" }}}
" {{{ vimwiki
let wiki = {}
let wiki.path = '~/vimwiki/'
let wiki.nested_syntax = {'ruby': 'ruby'}
let g:vimwiki_list = [wiki]
let g:vimwiki_folding='expr'

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
    exe 'edit ' . fnameescape(link_infos.filename)
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
" {{{ buftabline
let g:buftabline_numbers=1
let g:buftabline_separators=1
let g:buftabline_plug_max=0
hi default link BufTabLineActive TabLine
" }}}
" {{{ closetag
let g:closetag_filenames = '*.html,*.xhtml,*.jsx,*.js'
let g:closetag_xhtml_filenames = '*.xhtml,*.jsx,*.js'
let g:closetag_shortcut = '<c-b>'
" }}}
" {{{ vim-indentline
let g:indentLine_color_gui = '#5b5b5b'
let g:indentLine_fileTypeExclude=['markdown', 'json']
let g:indentLine_bufTypeExclude=['help', 'terminal']
" }}}
" {{{ ultisnips
let g:UltiSnipsEditSplit="horizontal"
" let g:UltiSnipsExpandTrigger="<tab>"
" let g:UltiSnipsJumpForwardTrigger="<c-n>"
" let g:UltiSnipsJumpBackwardTrigger="<c-p>"
let g:UltiSnipsSnippetsDir="~/code/dotfiles/ultisnips"
let g:UltiSnipsSnippetDirectories=[$HOME.'/code/dotfiles/ultisnips', "UltiSnips"]
" }}}
" {{{ vim-searchhi
let g:searchhi_clear_all_autocmds = 'InsertEnter'
let g:searchhi_clear_all_asap=1
" let g:searchhi_user_autocmds_enabled=1

nmap / <Plug>(searchhi-/)
nmap ? <Plug>(searchhi-?)
nmap n <Plug>(searchhi-n)
nmap N <Plug>(searchhi-N)
nmap <silent> <leader>sl <Plug>(searchhi-clear-all)

vmap / <Plug>(searchhi-v-/)
vmap ? <Plug>(searchhi-v-?)
vmap n <Plug>(searchhi-v-n)
vmap N <Plug>(searchhi-v-N)
vmap <silent> <leader>sl <Plug>(searchhi-v-clear-all)

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
" nmap <silent> <leader>wa :silent! :wall<CR>:set nohlsearch<CR>
nnoremap <silent> <leader>wa :silent! :wall<CR>:execute "normal \<Plug>(searchhi-clear-all)"<CR>
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
  nnoremap <leader>T :call OpenNeoterm()<CR>

  nnoremap <leader>term :terminal<CR>:file term-

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
  tnoremap <C-p> <up>
  tnoremap <C-n> <down>
  tnoremap <C-f> <right>
  tnoremap <C-b> <left>

  " Allow tmux navigator to work in :terminal
  " tnoremap <silent> <c-h> <c-\><c-n>:TmuxNavigateLeft<cr>
  " tnoremap <silent> <c-j> <c-\><c-n>:TmuxNavigateDown<cr>
  " tnoremap <silent> <c-k> <c-\><c-n>:TmuxNavigateUp<cr>
  " tnoremap <silent> <c-l> <c-\><c-n>:TmuxNavigateRight<cr>
  " tnoremap <silent> <c-\> <c-\><c-n>:TmuxNavigatePrevious<cr>

  " Neoterm / Vim-Test
  nnoremap <leader>td :T <C-d>
  nnoremap <leader>tn :silent! :wall<CR>:TestNearest<CR>
  nnoremap <leader>tf :silent! :wall<CR>:TestFile<CR>
  nnoremap <leader>ts :silent! :wall<CR>:TestSuite<CR>
  nnoremap <leader>tl :silent! :wall<CR>:TestLast<CR>
  nnoremap <leader>tL :silent! :wall<CR>:Tkill<CR>:Tkill<CR>:TestLast<CR>
  nnoremap <leader>tg :TestVisit<CR>
  nnoremap <leader>tfile :TREPLSendFile<CR>
  vnoremap <leader>tsel :TREPLSendSelection<CR>
  nnoremap <leader>tline :TREPLSendLine<CR>

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
