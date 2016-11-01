"""""""""""
" Plugins "
"""""""""""
call plug#begin('~/.vim/plugged')

" Functionality
Plug 'Raimondi/delimitMate'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/seoul256.vim'
Plug 'justinmk/vim-sneak'
Plug 'maxboisvert/vim-simple-complete'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'wellle/targets.vim'
Plug 'xolox/vim-misc'
Plug 'xolox/vim-session'

" UI
Plug 'mhinz/vim-startify'
Plug 'rakr/vim-one'
Plug 'romainl/Apprentice'
Plug 'sheerun/vim-polyglot'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

call plug#end()

""""""""""""""""
" Vim settings "
""""""""""""""""

" Colors
syntax enable
set background=dark
colorscheme one

" Misc
set autoread
set autoread
set backspace=indent,eol,start
set complete-=i
set complete-=t
set display+=lastline
set hidden
set history=10000
set nrformats-=octal

" spaces & tabs
filetype plugin indent on
set autoindent
set expandtab
set shiftwidth=2
set smartindent
set softtabstop=2
set tabstop=2

" ui
set colorcolumn=80
set cursorcolumn
set cursorline
set number
set relativenumber
set scrolloff=999
set showcmd
set showmatch
set splitbelow
set splitright
set textwidth=0
set wildmenu
set wildmode=list:longest

" disable bell
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" searching
set hlsearch
set ignorecase
set incsearch
set smartcase

"""""""""""""""""""""
" autocmd Settings "
"""""""""""""""""""""

augroup configgroup
  autocmd!
  autocmd vimenter * highlight clear signcolumn
augroup end

""""""""""""""""
" Custom Binds "
""""""""""""""""

" Insert empty lines
nnoremap [<space>  :<c-u>put! =repeat(nr2char(10), v:count1)<cr>'[
nnoremap ]<space>  :<c-u>put =repeat(nr2char(10), v:count1)<cr>

" Match current input
cnoremap <c-n> <down>
cnoremap <c-p> <up>

" Hide search highlighting
nnoremap <C-L> :nohlsearch<CR>

" Best
imap jk <esc>

" up and down traverse into wrapped lines
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk
nnoremap <down> gj
nnoremap <up> gk
vnoremap <down> gj
vnoremap <up> gk
inoremap <down> <c-o>gj
inoremap <up> <c-o>gk

" Buffer navigation
nnoremap <S-H> :bnext<cr>
nnoremap <S-L> :bprevious<cr>

" leader mappings
let mapleader="\<Space>"

nnoremap <leader>h <C-w>h
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <leader>l <C-w>l
nnoremap <leader>w :wa<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>s :SaveSession<CR>
nnoremap <leader>bq :bp <bar> bd #<CR>
nnoremap <leader>bl :ls<CR>:b<space>
nnoremap <leader>bb <c-^>
nnoremap <leader>v :set nonumber<CR>:set norelativenumber<CR>:vertical resize 32<CR>

" Plugin mappings
nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <leader>v :set nonumber<CR>:set norelativenumber<CR>:vertical resize 32<CR>
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fbb :Buffers<CR>
nnoremap <leader>fbl :Lines<CR>
nnoremap <leader>fl :BLines<CR>
nnoremap <leader>fc :Commands<CR>

" True color support
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

""""""""""""""""""""
" Plugins Settings "
""""""""""""""""""""

" Place cursor in correc spot
imap <expr> <CR> pumvisible() ? "\<c-y>" : "<Plug>delimitMateCR"

let g:vsc_tab_complete=1
let g:vsc_completion_command = "\<C-P>"
let g:vsc_reverse_completion_command = "\<C-N>"

let g:session_autoload=0
let g:session_autosave=0

" airline
let g:airline_theme='one'
let g:airline_powerline_fonts=1

if !exists('g:airline_symbols')
  let g:airline_symbols={}
endif

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

let g:airline_left_sep=''
let g:airline_left_alt_sep=''
let g:airline_right_sep=''
let g:airline_right_alt_sep=''
let g:airline_symbols.branch=''
let g:airline_symbols.readonly=''
let g:airline_symbols.linenr=''
