" Install vim plug https://github.com/junegunn/vim-plug

""" Plugins Begin """
call plug#begin('~/.vim/plugged')

" Functionality
Plug 'Raimondi/delimitMate'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'justinmk/vim-sneak'
Plug 'mhinz/vim-grepper'
Plug 'alvan/vim-closetag'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'wellle/targets.vim'
Plug 'scrooloose/nerdtree'
Plug 'xolox/vim-misc'
Plug 'xolox/vim-session'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

" Pretty things
Plug 'Yggdroot/indentLine'
Plug 'mhinz/vim-startify'
Plug 'ntpeters/vim-better-whitespace'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Colorschemes
Plug 'ajh17/Spacegray.vim'
Plug 'altercation/vim-colors-solarized'
Plug 'chriskempson/base16-vim'
Plug 'chriskempson/vim-tomorrow-theme'
Plug 'rakr/vim-one'

" Syntax
Plug 'digitaltoad/vim-jade'
Plug 'elzr/vim-json'
Plug 'groenewege/vim-less'
Plug 'junegunn/vim-journal'
Plug 'justinmk/vim-syntax-extra'
Plug 'sheerun/vim-polyglot'
Plug 'sickill/vim-monokai'
Plug 'terryma/vim-multiple-cursors'

call plug#end()
""" Plugins End """


let g:startify_custom_header = [
\ '     ____',
\ '    (.   \     m',
\ '      \  |',
\ '       \ |___(\--/)           e',
\ '    __/     (  . . )',
\ '    "''._.    ''-.O.''    o',
\ '         ''-.  \ "|\         wwwwwww',
\ '            ''.,,/''.,',
\ '',
\ '',
\ ]

" Place cursor in correc spot
imap <expr> <CR> pumvisible() ? "\<c-y>" : "<Plug>delimitMateCR"

let g:deoplete#enable_at_startup=1
let g:deoplete#auto_complete_delay=1

" Stop hiding double quotes
let g:vim_json_syntax_conceal=0

" indentLines customization
let g:indentLine_leadingSpaceEnabled=1
let g:indentLine_leadingSpaceChar='.'
let g:indentLine_color_term=239

" powerline fonts!!
let g:airline_powerline_fonts=1
" air-line

if !exists('g:airline_symbols')
    let g:airline_symbols={}
endif

" Don't conceal markdown
let g:vim_markdown_conceal=0

" unicode symbols
let g:airline_left_sep='»'
let g:airline_left_sep='▶'
let g:airline_right_sep='«'
let g:airline_right_sep='◀'
let g:airline_symbols.linenr='␊'
let g:airline_symbols.linenr='␤'
let g:airline_symbols.linenr='¶'
let g:airline_symbols.branch='⎇'
let g:airline_symbols.paste='ρ'
let g:airline_symbols.paste='Þ'
let g:airline_symbols.paste='∥'
let g:airline_symbols.whitespace='Ξ'

" airline symbols
let g:airline_left_sep=''
let g:airline_left_alt_sep=''
let g:airline_right_sep=''
let g:airline_right_alt_sep=''
let g:airline_symbols.branch=''
let g:airline_symbols.readonly=''
let g:airline_symbols.linenr=''

" Syntastic customization
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*

" let g:syntastic_always_populate_loc_list=1
" let g:syntastic_auto_loc_list=1
" let g:syntastic_check_on_open=1
" let g:syntastic_check_on_wq=0
" let g:syntastic_c_remove_include_errors=1


" let g:syntastic_mode_map={
"   \ "mode": "active",
"   \ "passive_filetypes": ["c", "java"] }

" change comment style
autocmd FileType c,cpp,cs,java setlocal commentstring=//\ %s

" spaces and tabs
set tabstop=2 " show existing tabs with 2 spaces
set softtabstop=2 " 2 spaces indented and backspaced
set shiftwidth=2 " how many columns for automatic indentation
set expandtab " insert spaces instead of tabs
set autoindent " copy indentation from previous line
filetype plugin indent on

" UI things
set number " line numbers
set scrolloff=999 " keep cursor in middle
set textwidth=0 " do not automatically wrap lines at a certain line
set colorcolumn=80 " set a ruler
set cursorline " highlight current line
set cursorcolumn " highlight current column

set showcmd " show last command in bottom bar
set cmdheight=2 " Set height of command bar
set wildmenu " visual autocomplete for command menu
set wildmode=list:longest " Make autocomplete go up to a point of ambiguity while showing all options
set showmatch " highlight matching brackets
set mat=2 " how many tenths of a second blink when matching brackets

set splitbelow " open new splits on bottom instead of top
set splitright " open new splits on right instead of left
set lazyredraw " avoid updating screen before commands are completed
syntax on " highlighting yay

" hide highlighting until next search after CTRL-L pressed
nnoremap <C-L> :nohlsearch<CR><C-L>

" Nested style for :Explore
let g:netrw_liststyle=3

" File specific settings
au BufNewFile,BufRead *.journal set filetype=journal
au BufReadPost *.jshintrc set syntax=json

" disable bell
set noerrorbells
set novisualbell
set t_vb=
set tm=500

set backspace=indent,eol,start " enable backspace over these characters

" something about buffers
set hidden

" searching
set incsearch " search as characters are entered
set hlsearch " highlight all matches
set ignorecase " used in conjunction with smartcase.
set smartcase " only do case sensitive searching if there are capital letters in the query

" custom binds

" Reassign leader key
let mapleader="\<Space>"

" Match current input
cnoremap <c-n> <down>
cnoremap <c-p> <up>

" Insert empty lines
nnoremap [<space>  :<c-u>put! =repeat(nr2char(10), v:count1)<cr>'[
nnoremap ]<space>  :<c-u>put =repeat(nr2char(10), v:count1)<cr>

" Grepper
nmap gs <plug>(GrepperOperator)
xmap gs <plug>(GrepperOperator)

" Leader mappings
nnoremap <leader>h <C-w>h
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <leader>l <C-w>l
nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <leader>gf :Grepper<CR>
nnoremap <leader>gt <c-w>gf
nnoremap <leader>w :wa<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>H :bnext<CR>
nnoremap <leader>L :bprevious<CR>
nnoremap <leader>bq :bp <BAR> bd #<CR>
nnoremap <leader>bl :ls<CR>:b<Space>
nnoremap <leader>bb <C-^>
nnoremap <leader>v :set nonumber<CR>:set norelativenumber<CR>:vertical resize 32<CR>

" fzf binds
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fbb :Buffers<CR>
nnoremap <leader>fbl :Lines<CR>
nnoremap <leader>fl :BLines<CR>
nnoremap <leader>fc :Commands<CR>
imap <c-x><c-l> <plug>(fzf-complete-line)

" up and down traverse into wrapped lines
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk
nnoremap <Down> gj
nnoremap <Up> gk
vnoremap <Down> gj
vnoremap <Up> gk
inoremap <Down> <C-o>gj
inoremap <Up> <C-o>gk

" tab movements
nnoremap <S-H> :tabprevious<CR>
nnoremap <S-L> :tabnext<CR>

" go to normal mode without esc key"
:imap jk <Esc>

" shortcuts for entering end of line semicolons and commans
inoremap ;; <END>;<CR>
inoremap ,, <END>,<CR>

set pastetoggle=<F10> " For toggling paste mode when pasting large amounts of preformatted text

set number " show the current line's line number
set relativenumber " show other line numbers relative to the current line

" theming
let base16colorspace=256
syntax enable
colorscheme base16-eighties
set background=dark
let g:airline_theme='tomorrow'


" Rotating lines screensaver
" Press \r to start rotating lines and <C-c> (Control+c) to stop.
function! s:RotateString(string)
  let split_string = split(a:string, '\zs')
  return join(split_string[-1:] + split_string[:-2], '')
endfunction

function! s:RotateLine(line, leading_whitespace, trailing_whitespace)
  return substitute(
        \ a:line,
        \ '^\(' . a:leading_whitespace . '\)\(.\{-}\)\(' . a:trailing_whitespace . '\)$',
        \ '\=submatch(1) . <SID>RotateString(submatch(2)) . submatch(3)',
        \ ''
        \ )
endfunction

function! s:RotateLines()
  let saved_view = winsaveview()
  let first_visible_line = line('w0')
  let last_visible_line = line('w$')
  let lines = getline(first_visible_line, last_visible_line)
  let leading_whitespace = map(
        \ range(len(lines)),
        \ 'matchstr(lines[v:val], ''^\s*'')'
        \ )
  let trailing_whitespace = map(
        \ range(len(lines)),
        \ 'matchstr(lines[v:val], ''\s*$'')'
        \ )
  try
    while 1 " <C-c> to exit
      let lines = map(
            \ range(len(lines)),
            \ '<SID>RotateLine(lines[v:val], leading_whitespace[v:val], trailing_whitespace[v:val])'
            \ )
      call setline(first_visible_line, lines)
      redraw
      sleep 50m
    endwhile
  finally
    if &modified
      silent undo
    endif
    call winrestview(saved_view)
  endtry
endfunction

nnoremap <silent> <Plug>(RotateLines) :<C-u>call <SID>RotateLines()<CR>
nmap <leader>r <Plug>(RotateLines)

