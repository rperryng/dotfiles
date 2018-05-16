"""""""""""
" Plugins "
"""""""""""
call plug#begin('~/.vim/plugged')

" Functionality
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'alvan/vim-closetag'
Plug 'ap/vim-buftabline'
Plug 'christoomey/vim-tmux-navigator'
Plug 'janko-m/vim-test'
Plug 'jceb/vim-orgmode'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'
Plug 'kana/vim-textobj-user'
Plug 'kassio/neoterm'
Plug 'ludovicchabant/vim-gutentags'
Plug 'michaeljsmith/vim-indent-object'
Plug 'nelstrom/vim-textobj-rubyblock'
Plug 'scrooloose/nerdtree'
Plug 'sjl/gundo.vim'
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-rake'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'vim-scripts/ZoomWin'
Plug 'w0rp/ale'
Plug 'wellle/targets.vim'
Plug 'wesQ3/vim-windowswap'

" UI
Plug 'chriskempson/base16-vim'
Plug 'joshdick/onedark.vim'
Plug 'junegunn/vim-slash'
Plug 'machakann/vim-highlightedyank'
Plug 'metalelf0/base16-black-metal-scheme'
Plug 'mhinz/vim-startify'
Plug 'rakr/vim-one'
Plug 'sheerun/vim-polyglot'
" Plug 'vim-airline/vim-airline'
" Plug 'vim-airline/vim-airline-themes'

call plug#end()

"""""""""""""""""""""
" autocmd Settings "
"""""""""""""""""""""

augroup focusgroup
  autocmd!
  " Preserve cursor location when switching buffers
  au BufLeave * let b:winview = winsaveview()
  au BufEnter * if(exists('b:winview')) | call winrestview(b:winview) | endif
  au FocusGained,BufEnter * :silent! checkt
augroup end

augroup filetypes
  autocmd!
  autocmd BufNewFile,BufReadPost *.md set filetype=markdown
  autocmd BufNewFile,BufReadPost *.jshintrc set filetype=javascript
  autocmd BufNewFile,BufReadPost *.zshrc set filetype=zsh
  autocmd BufNewFile,BufReadPost *.org set filetype=org
  autocmd BufNewFile,BufReadPost *.rb set colorcolumn=100
  autocmd FileType yaml setlocal commentstring=#\ %s
  autocmd FileType org setlocal shiftwidth=1 tabstop=1
  autocmd FileType python setl nosmartindent
augroup end

""""""""""""""""
" Vim settings "
""""""""""""""""

let mapleader="\<Space>"
let maplocalleader="\\"

" Colors
let base16colorspace=256
syntax enable
set background=dark
colorscheme base16-eighties
" colorscheme base16-black-metal-bathory

" Start and End tags are same color
hi Tag        ctermfg=04
hi xmlTag     ctermfg=04
hi xmlTagName ctermfg=04
hi xmlEndTag  ctermfg=04

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
set norelativenumber
set scrolloff=999
set showcmd
set showmatch
set splitbelow
set splitright
set textwidth=0
set wildmenu
set wildmode=list:longest
set nowrap
set noequalalways

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
" command! -nargs=+ Z execute "cd " . system("execz.sh")

""""""""""""""""
" Custom Binds "
""""""""""""""""
" Insert empty lines
nnoremap [<space>  :<c-u>put! =repeat(nr2char(10), v:count1)<CR>'[
nnoremap ]<space>  :<c-u>put =repeat(nr2char(10), v:count1)<CR>

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

" Layout mappings
nnoremap <leader>wK :resize +5<CR>
nnoremap <leader>wJ :resize -5<CR>
nnoremap <leader>wL :vertical resize +5<CR>
nnoremap <leader>wH :vertical resize -5<CR>
nnoremap <leader>wk :resize +1<CR>
nnoremap <leader>wj :resize -1<CR>
nnoremap <leader>wl :vertical resize +1<CR>
nnoremap <leader>wh :vertical resize -1<CR>
nnoremap <leader>ww :<up><CR>
nnoremap <leader>s ml:tabedit %<CR>'l

nnoremap s% :echo @%<CR>
nnoremap sn% :NERDTreeFind<CR>

" Reload vimrc
nnoremap <leader>R :source $MYVIMRC<CR>

" Zoom a vim pane
nnoremap <leader>- :wincmd _<cr>:wincmd \|<cr>
nnoremap <leader>= :wincmd =<cr>

" Help aligning ruby params
nnoremap <leader>, /,<CR>cgn,<CR><ESC>n

nnoremap <leader>zz :let &scrolloff=999-&scrolloff<CR>

nnoremap <leader>ll <C-^>
nnoremap <leader>ls :nohlsearch<CR>

nnoremap ss "+
nnoremap <leader>y "+y
nnoremap <leader>wa :silent! :wa<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>bd :bp <bar> bd #<CR>
nnoremap <leader>bl :ls<CR>:b<space>
nnoremap <leader>bb <c-^>
nnoremap <C-n> :tabnext<CR>
nnoremap <C-p> :tabprevious<CR>
nnoremap <C-S-n> :bnext<CR>
nnoremap <C-S-p> :bprevious<CR>

nnoremap <leader>file :set filetype=
nnoremap <leader>z :cd ~/code/ws/

" Plugin mappings
nnoremap <leader>gu :GundoToggle<CR>
nnoremap <leader>n :NERDTreeToggle<CR>
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
nnoremap <silent> sn :ALENextWrap<CR>
nnoremap <silent> sp :ALEPreviousWrap<CR>
nnoremap sl :ALELint<CR>
nnoremap <leader>p :PlugInstall<CR>

" FZF mappings
nnoremap <C-f> :GFiles!<CR>

nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>fc :Commands<CR>
nnoremap <leader>fi :Files<CR>
nnoremap <leader>fh :Helptags<CR>
nnoremap <leader>flb :BLines<CR>
nnoremap <leader>fll :Lines<CR>
nnoremap <leader>ft :Tags<CR>
nnoremap <leader>fm :Marks<CR>
nnoremap <leader>fg :GFiles?<CR>
nnoremap <leader>fw :Windows<CR>
nnoremap <leader>fa :Ag<CR>

nnoremap <leader>fB :Buffers!<CR>
nnoremap <leader>fC :Commands!<CR>
nnoremap <leader>fI :Files!<CR>
nnoremap <leader>fH :Helptags!<CR>
nnoremap <leader>flB :BLines!<CR>
nnoremap <leader>flL :Lines!<CR>
nnoremap <leader>fT :Tags!<CR>
nnoremap <leader>fM :Marks!<CR>
nnoremap <leader>fG :GFiles?!<CR>
nnoremap <leader>fW :Windows!<CR>
nnoremap <leader>fA :Ag!<CR>

set notermguicolors

" Search highlight comes back after reloading vimrc.  Hide it
:nohlsearch

"""""""""""""""""""
" Plugin Settings "
"""""""""""""""""""

" vim-test
let test#ruby#rspec#executable = 'bundle exec rspec'

" vim-buftabline
let g:buftabline_numbers=1
let g:buftabline_separators=1
hi default link BufTabLineActive TabLine

" vim-closetag
let g:closetag_filenames = '*.html,*.xhtml,*.jsx,*.js'
let g:closetag_xhtml_filenames = '*.xhtml,*.jsx,*.js'
let g:closetag_shortcut = '<c-b>'

  " Gutentags
let g:gutentags_project_root=['.tags-root']

" Ale
let g:ale_sign_column_always = 1
let g:ale_lint_on_enter=1
let g:ale_lint_on_text_changed='never'
let g:ale_linters = {
\  'html': [],
\  'javascript': ['eslint'],
\  'ruby': ['ruby', 'rubocop'],
\}

" Deoplete
let g:deoplete#enable_at_startup = 1

" Vim-rooter
let g:rooter_patterns=['.vimroot', '.git/', '.git']

" NERDTree
let NERDTreeAutoDeleteBuffer=1
let NERDTreeDirArrows = 1
let NERDTreeMinimalUI = 1
let NERDTreeShowHidden=1
let g:NERDTreeMapHelp = '<F1>'

" FZF
let $FZF_DEFAULT_OPTS .= ' --no-height'

command! -bang -nargs=? -complete=dir Ag
  \ call fzf#vim#ag(<q-args>, fzf#vim#with_preview(), <bang>0)

command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

command! -bang -nargs=? -complete=dir GFiles
  \ call fzf#vim#gitfiles(<q-args>, fzf#vim#with_preview(), <bang>0)

" Airline
let g:airline_theme='base16'
let g:airline_powerline_fonts=1
let g:airline#extensions#ale#enabled = 1

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

"""""""""""""""""""
" Neovim Settings "
"""""""""""""""""""

if has('nvim')
  augroup tmappings
    autocmd!
    " https://gist.github.com/nelstrom/d08d342501d59abdac95b9d28fdb4cfc
    " Readline cheatsheet:
    " ctrl-a - jump to start of line
    " ctrl-e - jump to end of line
    " ctrl-k - kill forwards to the end of line
    " ctrl-u - kill backwards to the start of line
    autocmd TermOpen * nnoremap <buffer> I I<C-a>
    autocmd TermOpen * nnoremap <buffer> A A<C-e>
    autocmd TermOpen * nnoremap <buffer> C A<C-k>
    autocmd TermOpen * nnoremap <buffer> D A<C-k><C-\><C-n>
    autocmd TermOpen * nnoremap <buffer> cc A<C-e><C-u>
    autocmd TermOpen * nnoremap <buffer> dd A<C-e><C-u><C-\><C-n>
    autocmd TermOpen * nnoremap <leader>bd :bp <bar> bd! #<CR>

    autocmd TermOpen * setlocal scrollback=30000
  augroup end

  " UI
  hi! TermCursorNC ctermfg=1 ctermbg=2 cterm=NONE gui=NONE

  " Vim-test
  let test#strategy = 'neoterm'

" Terminal mode binds
  tnoremap jk <C-\><C-N>
  tnoremap <C-n> <down>
  tnoremap <C-p> <up>

  " Use <C-\><C-r> in terminal insert mode to emulate <C-r> in insert mode
  " in a normal buffer (i.e. next key pastes from that buffer)
  tnoremap <expr> <C-\><C-r> '<C-\><C-n>"'.nr2char(getchar()).'pi'

  " Allow tmux navigator to work in :terminal
  tnoremap <silent> <c-h> <c-\><c-n>:TmuxNavigateLeft<cr>
  tnoremap <silent> <c-j> <c-\><c-n>:TmuxNavigateDown<cr>
  tnoremap <silent> <c-k> <c-\><c-n>:TmuxNavigateUp<cr>
  tnoremap <silent> <c-l> <c-\><c-n>:TmuxNavigateRight<cr>
  tnoremap <silent> <c-\> <c-\><c-n>:TmuxNavigatePrevious<cr>

  nnoremap <leader>term :file<Space>term-

  " Neoterm / Vim-Test
  nnoremap <leader>td :call neoterm#do("\<C-d>")<CR>
  nnoremap <leader>tq :call neoterm#kill()<CR>
  nnoremap <leader>tQ :call neoterm#kill()<CR>:call neoterm#kill()<CR>
  nnoremap <leader>tn :TestNearest<CR>
  nnoremap <leader>tf :TestFile<CR>
  nnoremap <leader>ts :TestSuite<CR>
  nnoremap <leader>tl :TestLast<CR>
  nnoremap <leader>tL :call neoterm#kill()<CR>:call neoterm#kill()<CR>:TestLast<CR>
  nnoremap <leader>tg :TestVisit<CR>
  nnoremap <leader>tt :Tnew<CR>
  nnoremap <leader>tfile :TREPLSendFile<CR>
  vnoremap <leader>tsel :TREPLSendSelection<CR>
  nnoremap <leader>tline :TREPLSendLine<CR>
  nnoremap <leader>neo :Ttoggle<CR>

  " Haaaaddeeeeees
  nnoremap <leader>tpls :call neoterm#do("\<Up>")<CR>

  nnoremap <leader>tv :let g:neoterm_position='vertical'<CR>:Tnew<CR><C-\><C-n>:file neoterm<CR>
  nnoremap <leader>ts :let g:neoterm_position='horizontal'<CR>:Tnew<CR><C-\><C-n>:file neoterm<CR>

  " neoterm settings
  let g:neoterm_autoinsert=1
  let g:neoterm_autoscroll=1
endif
