""" Plugins Begin """
call plug#begin('~/.vim/plugged')

" Functionality
Plug 'https://github.com/Raimondi/delimitMate.git'
Plug 'https://github.com/ctrlpvim/ctrlp.vim'
Plug 'https://github.com/scrooloose/nerdcommenter.git'
Plug 'https://github.com/tpope/vim-surround.git'
Plug 'https://github.com/tpope/vim-fugitive.git'

" Pretty things
Plug 'https://github.com/nathanaelkane/vim-indent-guides.git'
Plug 'https://github.com/mhinz/vim-startify.git'
Plug 'https://github.com/vim-airline/vim-airline.git'
Plug 'https://github.com/vim-airline/vim-airline-themes.git'

" Colorschemes
Plug 'https://github.com/altercation/vim-colors-solarized.git'
Plug 'https://github.com/chriskempson/vim-tomorrow-theme.git'
Plug 'https://github.com/AlessandroYorba/Alduin.git'

" Syntax
Plug 'https://github.com/junegunn/vim-journal.git'
Plug 'https://github.com/terryma/vim-multiple-cursors.git'
Plug 'https://github.com/justinmk/vim-syntax-extra.git'
Plug 'https://github.com/groenewege/vim-less.git'
Plug 'https://github.com/digitaltoad/vim-jade.git'
Plug 'https://github.com/sickill/vim-monokai.git'

call plug#end()
""" Plugins End """

" Place cursor in correc spot
imap <expr> <CR> pumvisible() ? "\<c-y>" : "<Plug>delimitMateCR"

" spaces and tabs
set tabstop=2 " show existing tabs with 2 spaces
set softtabstop=2 " 2 spaces indented and backspaced
set shiftwidth=2 " how many columns for automatic indentation
set expandtab " insert spaces instead of tabs
set autoindent " copy indentation from previous line
filetype plugin indent on

" UI things
set number " line numbers
set showcmd " show last command in bottom bar
set cmdheight=2 " Set height of command bar
set cursorline " highlight current line
set wildmenu " visual autocomplete for command menu
set wildmode=list:longest " Make autocomplete go up to a point of ambiguity while showing all options
set showmatch " highlight matching brackets
set mat=2 " how many tenths of a second blink when matching brackets
set splitbelow " open new splits on bottom instead of top
set splitright " open new splits on right instead of left
set scrolloff=999 " keep cursor in middle
set lazyredraw " avoid updating screen before commands are completed
syntax on " highlighting yay
set textwidth=0 " do not automatically wrap lines at a certain line
set colorcolumn=80 " set a ruler
" hide highlighting until next search after CTRL-L pressed
nnoremap <C-L> :nohlsearch<CR><C-L>:<backspace>

" Nested style for :Explore
let g:netrw_liststyle=3

" indent-guides customization
let g:indent_guides_enable_on_vim_startup=1 " show indents
let g:indent_guides_guide_size=1 " set indent guide size to 1
let g:indent_guides_auto_colors=0
    autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=0
    autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=52

" vim journal filetype
au BufNewFile,BufRead *.journal set filetype=journal

" disable bell
set noerrorbells
set novisualbell
set t_vb=
set tm=500

set splitright " split right by default
set splitbelow " split below by default

set backspace=indent,eol,start " enable backspace over these characters

" searching
set incsearch " search as characters are entered
set hlsearch " highlight all matches

" custom binds
" up and down traverse into wrapped lines
nnoremap j gj
nnoremap k gk

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

" Theming
syntax enable
set background=dark
colorscheme Tomorrow-Night
let g:airline_theme='tomorrow'
