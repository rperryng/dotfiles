" Install vim plug https://github.com/junegunn/vim-plug

" Install neovim.
" To start the transition, link your previous configuration so Nvim can use it:

" mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}
" ln -s ~/.vim $XDG_CONFIG_HOME/nvim
" ln -s ~/.vimrc $XDG_CONFIG_HOME/nvim/init.vim

""" Plugins Begin """
call plug#begin('~/.vim/plugged')

" Functionality
Plug 'Raimondi/delimitMate'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-obsession'
Plug 'wellle/targets.vim'
Plug 'sukima/xmledit'
Plug 'scrooloose/syntastic'

" Pretty things
Plug 'Yggdroot/indentLine'
Plug 'mhinz/vim-startify'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ntpeters/vim-better-whitespace'

" Colorschemes
Plug 'altercation/vim-colors-solarized'
Plug 'chriskempson/vim-tomorrow-theme'

" Syntax
Plug 'junegunn/vim-journal'
Plug 'terryma/vim-multiple-cursors'
Plug 'justinmk/vim-syntax-extra'
Plug 'groenewege/vim-less'
Plug 'digitaltoad/vim-jade'
Plug 'sickill/vim-monokai'
Plug 'elzr/vim-json'

call plug#end()
""" Plugins End """

let g:startify_custom_header = [
\ '     ____                            ',
\ '    (.   \     m                     ',
\ '      \  |                           ',
\ '       \ |___(\--/)           e      ',
\ '    __/     (  . . )                 ',
\ '    "''._.    ''-.O.''    o          ',
\ '         ''-.  \ "|\         wwwwwww ',
\ '            ''.,,/''.,               ',
\ '',
\ '',
\ ]

" Place cursor in correc spot
imap <expr> <CR> pumvisible() ? "\<c-y>" : "<Plug>delimitMateCR"

" Stop hiding double quotes
let g:vim_json_syntax_conceal=0

" indentLines customization
let g:indentLine_leadingSpaceEnabled=1
let g:indentLine_leadingSpaceChar='.'
let g:indentLine_color_term=239

" jshint2
" let jshint2_save=1

" Syntastic customization
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list=1
let g:syntastic_auto_loc_list=1
let g:syntastic_check_on_open=1
let g:syntastic_check_on_wq=0
let g:syntastic_c_remove_include_errors=0

let g:syntastic_mode_map={
  \ "mode": "active",
  \ "passive_filetypes": ["java"] }

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
nnoremap <C-L> :nohlsearch<CR><C-L>:<backspace>

" Nested style for :Explore
let g:netrw_liststyle=3

" File specific settings
au BufNewFile,BufRead *.journal set filetype=journal

" disable bell
set noerrorbells
set novisualbell
set t_vb=
set tm=500

set backspace=indent,eol,start " enable backspace over these characters

" searching
set incsearch " search as characters are entered
set hlsearch " highlight all matches
set ignorecase " used in conjunction with smartcase.
set smartcase " only do case sensitive searching if there are capital letters in the query

" custom binds

" Reassign leader key
let mapleader="\<Space>"

" Leader mappings
nnoremap <Leader>w :wa<CR>
nnoremap <Leader>q :q<CR>

" fzf binds
nnoremap <Leader>ff :Files<CR>
nnoremap <Leader>fb :Buffers<CR>
nnoremap <Leader>fl :BLines<CR>
nnoremap <Leader>fc :Commands<CR>
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
:imap jk <Esc>:w<CR>

" shortcuts for entering end of line semicolons and commans
inoremap ;; <END>;<CR>
inoremap ,, <END>,<CR>

set pastetoggle=<F10> " For toggling paste mode when pasting large amounts of preformatted text

set number " show the current line's line number
set relativenumber " show other line numbers relative to the current line

" Theming
syntax enable
set background=dark
colorscheme Tomorrow-Night
let g:airline_theme='tomorrow'
