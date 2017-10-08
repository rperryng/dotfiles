"""""""""""
" Plugins "
"""""""""""
call plug#begin('~/.vim/plugged')

" Functionality
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'airblade/vim-rooter'
Plug 'alvan/vim-closetag'
Plug 'ap/vim-buftabline'
Plug 'christoomey/vim-tmux-navigator'
Plug 'jceb/vim-orgmode'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/vim-slash'
Plug 'justinmk/vim-sneak'
Plug 'kana/vim-textobj-user'
Plug 'ludovicchabant/vim-gutentags'
Plug 'nelstrom/vim-textobj-rubyblock'
Plug 'scrooloose/nerdtree'
Plug 'sjl/gundo.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'vim-ruby/vim-ruby'
Plug 'w0rp/ale'
Plug 'wellle/targets.vim'
Plug 'wesQ3/vim-windowswap'

" UI
Plug 'chriskempson/base16-vim'
Plug 'joshdick/onedark.vim'
Plug 'junegunn/seoul256.vim'
Plug 'machakann/vim-highlightedyank'
Plug 'mhinz/vim-startify'
Plug 'rakr/vim-one'
Plug 'romainl/Apprentice'
Plug 'sheerun/vim-polyglot'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

call plug#end()

"""""""""""""""""""""
" autocmd Settings "
"""""""""""""""""""""

augroup focusgroup
  autocmd!
  autocmd FocusGained,BufEnter * :silent! !
  autocmd FocusLost,WinLeave * :silent! wa
  autocmd VimResized * :wincmd =
augroup end

augroup filetypes
  autocmd!
  autocmd BufNewFile,BufReadPost *.md set filetype=markdown
  autocmd BufNewFile,BufReadPost *.jshintrc set filetype=javascript
  autocmd BufNewFile,BufReadPost *.org set filetype=org
  autocmd BufNewFile,BufReadPost *.rb set colorcolumn=100
  autocmd FileType org setlocal shiftwidth=1 tabstop=1
  autocmd FileType python setl nosmartindent
augroup end

""""""""""""""""
" Vim settings "
""""""""""""""""

" Colors
let base16colorspace=256
syntax enable
set background=dark
colorscheme base16-eighties

" Misc
set autoread
set backspace=indent,eol,start
set complete-=i
set complete-=t
set display+=lastline
set hidden
set history=10000
set nrformats-=octal
set updatetime=250

" Spaces & tabs
filetype plugin indent on
set autoindent
set expandtab
set shiftwidth=2
set smartindent
set softtabstop=2
set tabstop=2

" UI
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
set nowrap

" Disable bell
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Searching
set hlsearch
set ignorecase
set incsearch
set smartcase
set inccommand=split

" Mouse support?
set mouse=a

"""""""""""""""""""
" Custom Commands "
"""""""""""""""""""

" :command StripWhitespace :let _s=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_s <Bar> :nohl <Bar> :unlet _s <CR>

""""""""""""""""
" Custom Binds "
""""""""""""""""

" Insert empty lines
nnoremap [<space>  :<c-u>put! =repeat(nr2char(10), v:count1)<cr>'[
nnoremap ]<space>  :<c-u>put =repeat(nr2char(10), v:count1)<cr>

" Match current input
cnoremap <c-n> <down>
cnoremap <c-p> <up>

" Best
imap jk <esc>

" Up and down traverse into wrapped lines
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

" Search for text under visual selection
vnoremap // y/<C-R>"<CR>

" Leader mappings
let mapleader="\<Space>"
let maplocalleader="\\"

" Reload vimrc
nnoremap <leader>r :source $MYVIMRC<CR>

" Zoom a vim pane
nnoremap <leader>- :wincmd _<cr>:wincmd \|<cr>
nnoremap <leader>= :wincmd =<cr>

" Help aligning ruby params
nnoremap <leader>, /,<CR>cgn,<CR><ESC>n

nnoremap <Leader>zz :let &scrolloff=999-&scrolloff<CR>

nnoremap <leader>y :%y+<CR>
nnoremap <leader>l :nohlsearch<CR>
nnoremap <leader>w :wa<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>bd :bp <bar> bd #<CR>
nnoremap <leader>bl :ls<CR>:b<space>
nnoremap <leader>bb <c-^>
nnoremap <C-N> :bnext<CR>
nnoremap <C-P> :bprev<CR>

nnoremap <leader>t :set filetype=

" Plugin mappings
nnoremap <leader>gu :GundoToggle<CR>
nnoremap <leader>n :NERDTreeToggle<CR>
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
nmap <leader>j <Plug>(ale_previous_wrap)
nmap <leader>k <Plug>(ale_next_wrap)
nmap <leader>p :PlugInstall<CR>

" FZF mappings
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>fc :Commands<CR>
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fh :Helptags<CR>
nnoremap <leader>fl :BLines<CR>
nnoremap <leader>ft :Tags<CR>
nnoremap <leader>fm :Marks<CR>
nnoremap <leader>fg :GFiles?<CR>
nnoremap <leader>fw :Windows<CR>

nnoremap <leader>FB :Buffers!<CR>
nnoremap <leader>FC :Commands!<CR>
nnoremap <leader>FF :Files!<CR>
nnoremap <leader>FH :Helptags!<CR>
nnoremap <leader>FL :BLines!<CR>
nnoremap <leader>FT :Tags!<CR>
nnoremap <leader>FM :Marks!<CR>
nnoremap <leader>FG :GFiles?!<CR>
nnoremap <leader>FW :Windows!<CR>


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

"""""""""""""""""""
" Plugin Settings "
"""""""""""""""""""

" tmux-navigator
let g:tmux_navigator_disable_when_zoomed=1

" vim-buftabline
let g:buftabline_numbers=1
let g:buftabline_separators=1
hi default link BufTabLineActive TabLine

" Gutentags
let g:gutentags_project_root=['.tags-root']
let g:gutentags_ctags_tagfile='guten.tags'

" Ale
let g:ale_sign_column_always = 1

" Deoplete
let g:deoplete#enable_at_startup = 1

" Vim-rooter
let g:rooter_patterns=['.vimroot', '.git/', '.git']

" NERDTree
let NERDTreeShowHidden=1

" Session
let g:session_autoload=0
let g:session_autosave=0

" Airline
let g:airline_theme='base16'
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

" GitGutter
let g:gitgutter_map_keys=0
