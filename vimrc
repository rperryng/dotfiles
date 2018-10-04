"""""""""""
" Plugins "
"""""""""""
call plug#begin('~/.local/share/nvim/plugged')

" LSP
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

" Functionality
Plug 'AndrewRadev/splitjoin.vim'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Yilin-Yang/vim-markbar'
Plug 'alvan/vim-closetag'
Plug 'ap/vim-buftabline'
Plug 'christoomey/vim-tmux-navigator'
Plug 'dbakker/vim-projectroot'
Plug 'gcmt/taboo.vim'
Plug 'janko-m/vim-test'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'
Plug 'kana/vim-textobj-user'
Plug 'kassio/neoterm'
Plug 'ludovicchabant/vim-gutentags'
Plug 'michaeljsmith/vim-indent-object'
Plug 'mileszs/ack.vim'
Plug 'nelstrom/vim-textobj-rubyblock'
Plug 'prakashdanish/vim-githubinator'
Plug 'scrooloose/nerdtree'
Plug 'sjl/gundo.vim'
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-rake'
Plug 'tpope/vim-rbenv'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vim-ruby/vim-ruby'
Plug 'vim-scripts/ZoomWin'
Plug 'w0rp/ale'
Plug 'wellle/targets.vim'
Plug 'wesQ3/vim-windowswap'

" UI
Plug 'Yggdroot/indentLine'
Plug 'drewtempelmeyer/palenight.vim'
Plug 'joshdick/onedark.vim'
Plug 'junegunn/vim-journal'
Plug 'junegunn/vim-slash'
Plug 'machakann/vim-highlightedyank'
Plug 'metalelf0/base16-black-metal-scheme'
Plug 'morhetz/gruvbox'
Plug 'rakr/vim-one'
Plug 'sheerun/vim-polyglot'

" Plug 'itchyny/lightline.vim'
" Plug 'chriskempson/base16-vim'
" Plug 'vim-airline/vim-airline'
" Plug 'vim-airline/vim-airline-themes'

call plug#end()

" Python
let g:python_host_prog='/Users/rperrynguyen/.pyenv/versions/neovim2/bin/python'
let g:python3_host_prog='/Users/rperrynguyen/.pyenv/versions/neovim3/bin/python'

" Ruby
let g:ruby_host_prog='/Users/rperrynguyen/.rbenv/versions/2.5.1/bin/ruby'

"""""""""""""""""""""
" autocmd Settings "
"""""""""""""""""""""

augroup focusgroup
  autocmd!
  " Preserve cursor location when switching buffers
  autocmd BufLeave * let b:winview = winsaveview()
  autocmd BufEnter * if(exists('b:winview')) | call winrestview(b:winview) | endif
  autocmd FocusGained,BufEnter * :silent! checkt
augroup end

augroup dir
  autocmd!
  " NERDTree always matches vim's working directory
  " autocmd DirChanged * :silent NERDTreeCWD
  " autocmd DirChanged * :silent NERDTreeCWD
augroup end

augroup filetypes
  autocmd!
  autocmd BufNewFile,BufReadPost *.md set filetype=markdown
  autocmd BufNewFile,BufReadPost *.jshintrc set filetype=javascript
  autocmd BufNewFile,BufReadPost *.zshrc set filetype=zsh
  autocmd BufNewFile,BufReadPost *.org set filetype=org
  autocmd FileType ruby setlocal colorcolumn=101
  autocmd FileType ruby setlocal textwidth=100
  autocmd FileType ruby setlocal omnifunc=LanguageClient#complete
  autocmd FileType yaml setlocal commentstring=#\ %s
  autocmd FileType org setlocal shiftwidth=1 tabstop=1
  autocmd FileType python setl nosmartindent
augroup end

""""""""""""""""
" Vim settings "
""""""""""""""""

let mapleader="\<Space>"

" Colors
if has('nvim')
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

if (has("termguicolors"))
  set termguicolors
endif

syntax enable
set background=dark
colorscheme gruvbox

" hi StatusLine   ctermfg=15  guifg=#ffffff ctermbg=239 guibg=#4e4e4e cterm=bold gui=bold
" hi StatusLineNC ctermfg=249 guifg=#b2b2b2 ctermbg=237 guibg=#3a3a3a cterm=none gui=none
" hi VertSplit    ctermfg=15  guifg=#b2b2b2 ctermbg=237 guibg=#3a3a3a cterm=none gui=none
" set fillchars+=vert:\ " intentional whitespace after forward slash

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
runtime macros/matchit.vim

" Spaces & tabs
filetype plugin indent on
set autoindent
set expandtab
set shiftwidth=2
set smartindent
set softtabstop=2
set tabstop=2

" UI
set lazyredraw
set colorcolumn=80
set synmaxcol=400
" set cursorcolumn
" set cursorline
set nonumber
set norelativenumber
set scrolloff=999
set sidescrolloff=15
set showcmd
set noshowmatch
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

if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

if executable('rg')
  let g:ackprg = 'rg --vimgrep --no-heading --smart-case'
else
  echom 'no ripgrep found'
endif

"""""""""""""""""""
" Custom Commands "
"""""""""""""""""""

" Strip Whitespace
""""""""""""""""""
command! StripWhitespace %s/\s\+$//e

" Change working directory using z.sh
"""""""""""""""""""""""""""""""""""""
function! ZLookup(z_arg)
  let z_command = 'cd ' . system('. ~/code/tools/z/z.sh && _z -e ' . a:z_arg)
  " Strip empty newline so that command line doesn't grow when echoing
  let z_command = substitute(z_command, "\n", "", "")
  execute z_command
  echo z_command
endfunction

command! -nargs=+ Z call ZLookup(<q-args>)

" Format JSON
"""""""""""""
function! FormatJson()
  execute '%!python -m json.tool'
  execute 'normal! gg=G'
endfunction
command! FormatJson call FormatJson()

" Start Ruby LSP for project of current file
""""""""""""""""""""""""""""""""""""""""""""
function! Solargraph()
  execute 'ProjectRootCD'
  let solargraph_buffer_name = 'term-solargraph-' . fnamemodify(getcwd(), ':t')

  if bufexists(solargraph_buffer_name)
    echom solargraph_buffer_name . ' already running!'
    execute 'buffer ' . solargraph_buffer_name
    return
  endif

  botright split
  terminal solargraph socket
  let rename_buffer_command = 'file ' . solargraph_buffer_name
  execute rename_buffer_command
endfunction

command! Solargraph :call Solargraph()

" Clear Terminal Scrollback history
"""""""""""""""""""""""""""""""""""
function! ClearScrollback()
  let current_scrollback=&scrollback
  setlocal scrollback=1
  let &l:scrollback=current_scrollback
endfunction
command! ClearScrollback :call ClearScrollback()

""""""""""""""""""""
" Custom Functions "
""""""""""""""""""""

" Move visual selections up and down.
" So bad, but so good.
" https://github.com/wincent/wincent/blob/fe798113/roles/dotfiles/files/.vim/autoload/wincent/mappings/visual.vim
function! s:Visual()
  return visualmode() == 'V'
endfunction

function! s:Move(address, at_limit)
  if s:Visual() && !a:at_limit
    execute "'<,'>move " . a:address
  endif
  call feedkeys('gv', 'n')
endfunction

function! Move_up() abort range
  let l:at_top=a:firstline == 1
  call s:Move("'<-2", l:at_top)
endfunction

function! Move_down() abort range
  let l:at_bottom=a:lastline == line('$')
  call s:Move("'>+1", l:at_bottom) call feedkeys('gv=', 'n')
endfunction

""""""""""""""""
" Custom Binds "
""""""""""""""""

" Move VISUAL LINE selection within buffer.
xnoremap <silent> K :call Move_up()<CR>
xnoremap <silent> J :call Move_down()<CR>

" Insert mode maps
inoremap jk <Esc>
inoremap <C-y> <Esc>

" Swap jump to column of mark and jump to beginning of line of mark commands
nnoremap ' `
nnoremap ` '

" Use verymagic searching
nnoremap / /\v
vnoremap / /\v

" Make list selection for tags the default
nnoremap <c-]> g<c-]>
vnoremap <c-]> g<c-]>
nnoremap g<c-]> <c-]>
vnoremap g<c-]> <c-]>

" Ruby methods can commonly contain word boundary characters like ! or ?
" Add helpers for motions that operate on the word under the cursor to include
" these tokens
nnoremap <leader><c-]> viwlg<c-]>
nnoremap <leader>* viwl*

" granular window resizing
nnoremap + <C-w>+
nnoremap - <C-w>-
nnoremap ) <C-w>>
nnoremap ( <C-w><

" Match current input
cnoremap <c-n> <down>
cnoremap <c-p> <up>

" Up and down traverse into wrapped lines
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

" Search for text under visual selection
vnoremap // y/<C-R>"<CR>

" Layout mappings
nnoremap st ml:tabedit %<CR>'l
nnoremap <leader>wr <C-w>j<C-w>j:b neoterm<CR><C-w>:res 20<CR><C-w>k
nnoremap <leader>w= <C-w>=<C-w>j:res 20<CR><C-w>k
nnoremap <leader>wl <C-w>=<C-w>j:res 15<CR><C-w>k
nnoremap <leader>w<space> :res +1<CR>:res -1<CR>

" Plugin commands
nnoremap s% :NERDTreeFind<CR>
nnoremap <Leader>ag :Ack!<Space>''<left>

" Reload vimrc
nnoremap <leader>R :source $MYVIMRC<CR>

nnoremap <leader>zz :let &scrolloff=999-&scrolloff<CR>

nnoremap <leader>l <C-^>
nnoremap <leader>sl :nohlsearch<CR>

nnoremap <leader>' "+
nnoremap <leader>y "+y
nnoremap <leader>p "+p
vnoremap <leader>y "+y
vnoremap <leader>p "+p
nnoremap <leader>wa :silent! :wall<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>bd :bprevious <bar> bdelete! #<CR>
nnoremap <leader>bl :buffers<CR>:buffer<space>
nnoremap <leader>bb <c-^>
nnoremap <leader>, :tjump<CR>
nnoremap <C-n> :tabnext<CR>
nnoremap <C-p> :tabprevious<CR>
nnoremap <C-S-n> :bnext<CR>
nnoremap <C-S-p> :bprevious<CR>
nnoremap sn :tabnext<CR>
nnoremap sp :tabprevious<CR>
nnoremap sln :set

nnoremap <leader>file :set filetype=
nnoremap <leader>z :cd ~/code/ws/

" Plugin mappings
nnoremap <leader>gu :GundoToggle<CR>
nnoremap <leader>n :NERDTreeToggle<CR>
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

map <leader>m <Plug>ToggleMarkbar

" FZF mappings
nnoremap <C-f> :GFiles!<CR>

nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>fc :Commands<CR>
nnoremap <leader>fi :Files<CR>
nnoremap <leader>fh :Helptags<CR>
nnoremap <leader>flb :BLines<CR>
nnoremap <leader>fla :Lines<CR>
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

nnoremap <leader>cd :ProjectRootCD<CR>

" Fugitive binds
nnoremap <leader>gst :Gstatus<CR>
nnoremap <leader>gsp :Gstatus
nnoremap <leader>gvs :Gvsplit

" LanguageClient
nnoremap <leader>h :call LanguageClient_contextMenu()<CR>
nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <leader>gd :call LanguageClient#textDocument_definition()<CR>

nnoremap <leader>rename <F2> :call LanguageClient#textDocument_rename()<CR>

"""""""""""""""""""
" Plugin Settings "
"""""""""""""""""""

" LanguageClient
let g:LanguageClient_autoStop = 0
let g:LanguageClient_serverCommands = {
    \ 'ruby': ['tcp://localhost:7658']
    \ }

" vim-test
let test#ruby#rspec#executable = 'bundle exec rspec'

" vim-buftabline
let g:buftabline_numbers=1
let g:buftabline_separators=1
let g:buftabline_plug_max=0
hi default link BufTabLineActive TabLine

" vim-closetag
let g:closetag_filenames = '*.html,*.xhtml,*.jsx,*.js'
let g:closetag_xhtml_filenames = '*.xhtml,*.jsx,*.js'
let g:closetag_shortcut = '<c-b>'

" Gutentags
" let g:gutentags_project_root=['.tags-root']

" vim-markbar
let g:markbar_open_position='botright'
let g:markbar_open_vertical=v:false
let g:markbar_height=10

" vim-indentline
let g:indentLine_bufTypeExclude=['help', 'terminal']

" Ale
" let g:ale_sign_column_always = 1
" let g:ale_lint_on_enter=1
" let g:ale_lint_on_text_changed='never'
" let g:ale_linters = {
" \  'html': [],
" \  'javascript': ['eslint'],
" \  'ruby': ['ruby', 'rubocop'],
" \}
let g:ale_enabled=0

" Deoplete
let g:deoplete#enable_at_startup = 1

" Vim-rooter
let g:rooter_patterns=['.vimroot', '.git/', '.git']

" NERDTree
let NERDTreeAutoDeleteBuffer=1
let NERDTreeDirArrows = 1
let NERDTreeMinimalUI = 1
let NERDTreeShowHidden=1
let g:NERDTreeMapHelp = '\'


" FZF
let $FZF_DEFAULT_OPTS .= ' --no-height'

" :Ag Only search file content, i.e. do not match directories
command! -bang -nargs=* Ag
  \ call fzf#vim#ag(<q-args>, fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}), <bang>0)

" :AG Match directories as well (useful to filter out specs)
command! -bang -nargs=* AG
  \ call fzf#vim#ag(<q-args>, fzf#vim#with_preview(), <bang>0)

" :Tags 
command! -bang -nargs=* Tags call fzf#vim#tags(<q-args>, {'options': '--delimiter : --nth 4..'}, <bang>0)

command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

command! -bang -nargs=? -complete=dir GFiles
  \ call fzf#vim#gitfiles(<q-args>, fzf#vim#with_preview(), <bang>0)

"""""""""""""""""""
" Neovim Settings "
"""""""""""""""""""

if has('nvim')
  augroup tmappings
    autocmd!
    autocmd TermOpen * setlocal scrollback=30000
  augroup end

  " UI
  " hi! TermCursorNC ctermfg=1 ctermbg=2 cterm=NONE gui=NONE
  hi! TermCursorNC ctermfg=15 guifg=#fdf6e3 ctermbg=14 guibg=#93a1a1 cterm=NONE gui=NONE

  " Vim-test
  let test#strategy = 'neoterm'

  nnoremap <leader>T :botright split<CR>:enew<CR>:Tnew<CR>:file neoterm<CR>
  nnoremap <leader>term :terminal<CR>:file term-

  " Terminal mode binds
  " tnoremap jk <C-\><C-N>
  tnoremap ;; <C-\><C-N>
  tnoremap <C-y> <C-\><C-N>

  " Use <C-\><C-r> in terminal insert mode to emulate <C-r> in insert mode
  " in a normal buffer (i.e. next key pastes from that buffer)
  tnoremap <expr> <C-\><C-r> '<C-\><C-n>"'.nr2char(getchar()).'pi'

  " For some reason these break when in an ssh session?
  tnoremap <C-p> <up>
  tnoremap <C-n> <down>
  tnoremap <C-f> <right>
  tnoremap <C-b> <left>

  " Convenience
  tnoremap ;nn ;nil<CR>

  " Allow tmux navigator to work in :terminal
  tnoremap <silent> <c-h> <c-\><c-n>:TmuxNavigateLeft<cr>
  tnoremap <silent> <c-j> <c-\><c-n>:TmuxNavigateDown<cr>
  tnoremap <silent> <c-k> <c-\><c-n>:TmuxNavigateUp<cr>
  tnoremap <silent> <c-l> <c-\><c-n>:TmuxNavigateRight<cr>
  tnoremap <silent> <c-\> <c-\><c-n>:TmuxNavigatePrevious<cr>

  " Neoterm / Vim-Test
  nnoremap <leader>td :T <C-d>
  nnoremap <leader>tq :Tkill<CR>
  nnoremap <leader>tQ :Tkill<CR>:Tkill<CR>
  nnoremap <leader>tn :silent! :wall<CR>:TestNearest<CR>
  nnoremap <leader>tf :silent! :wall<CR>:TestFile<CR>
  nnoremap <leader>ts :silent! :wall<CR>:TestSuite<CR>
  nnoremap <leader>tl :silent! :wall<CR>:TestLast<CR>
  nnoremap <leader>tL :silent! :wall<CR>:Tkill<CR>:Tkill<CR>:TestLast<CR>
  nnoremap <leader>tg :TestVisit<CR>
  nnoremap <leader>tt :Tnew<CR>
  nnoremap <leader>tfile :TREPLSendFile<CR>
  vnoremap <leader>tsel :TREPLSendSelection<CR>
  nnoremap <leader>tline :TREPLSendLine<CR>

  " neoterm settings
  let g:neoterm_autoscroll=1
endif

" Search highlight comes back after reloading vimrc.  Hide it
:nohlsearch
