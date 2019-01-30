" vim: set foldmethod=marker:

"{{{ Plugins

" :CocInstall coc-solargraph

call plug#begin('~/.local/share/nvim/plugged')

Plug 'neoclide/coc.nvim', {'tag': '*', 'do': { -> coc#util#install()}}

" Functionality
Plug 'AndrewRadev/splitjoin.vim'
Plug 'alvan/vim-closetag'
Plug 'dbakker/vim-projectroot'
Plug 'haya14busa/incsearch-fuzzy.vim'
Plug 'haya14busa/incsearch.vim'
Plug 'janko-m/vim-test'
Plug 'jesseleite/vim-agriculture'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'
Plug 'kana/vim-textobj-user'
Plug 'kassio/neoterm'
Plug 'ludovicchabant/vim-gutentags'
Plug 'mcchrish/nnn.vim'
Plug 'michaeljsmith/vim-indent-object'
Plug 'nelstrom/vim-textobj-rubyblock'
Plug 'prakashdanish/vim-githubinator'
Plug 'raghur/vim-ghost', {'do': ':GhostInstall'}
Plug 'simeji/winresizer'
Plug 'sjl/gundo.vim'
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-eunuch'
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
Plug 'wellle/targets.vim'

" UI
Plug 'Yggdroot/indentLine'
Plug 'arzg/seoul8'
Plug 'drewtempelmeyer/palenight.vim'
Plug 'gcmt/taboo.vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install' }
Plug 'joshdick/onedark.vim'
Plug 'junegunn/seoul256.vim'
Plug 'junegunn/vim-journal'
Plug 'junegunn/vim-slash'
Plug 'machakann/vim-highlightedyank'
Plug 'metalelf0/base16-black-metal-scheme'
Plug 'morhetz/gruvbox'
Plug 'patstockwell/vim-monokai-tasty'
Plug 'rakr/vim-one'
Plug 'sheerun/vim-polyglot'

" Plug 'scrooloose/nerdtree'
" Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

" Load last, as required in the README
" Plug 'ryanoasis/vim-devicons'

" 'Maybe' pile
" Plug 'TaDaa/vimade'
" Plug 'romainl/vim-cool'
" Plug 'itchyny/lightline.vim'
" Plug 'chriskempson/base16-vim'
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

" {{{ Autocmd settings

augroup focusgroup
  autocmd!
  " Preserve cursor location when switching buffers
  " autocmd BufLeave * let b:winview = winsaveview()
  " autocmd BufEnter * if(exists('b:winview')) | call winrestview(b:winview) | endif
  autocmd FocusGained,BufEnter * :silent! checkt

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

  autocmd FileType vim,markdown setlocal conceallevel=0
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

let mapleader="\<Space>"

" Colors
if has('nvim')
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

if (has("termguicolors"))
  set termguicolors
endif

syntax enable
let g:gruvbox_contrast_dark="hard"
colorscheme gruvbox
" colorscheme vim-monokai-tasty
" let g:seoul256_background = 235
" colorscheme seoul256
set background=dark

" hi StatusLine   ctermfg=15  guifg=#ffffff ctermbg=239 guibg=#4e4e4e cterm=bold gui=bold
" hi StatusLineNC ctermfg=249 guifg=#b2b2b2 ctermbg=237 guibg=#3a3a3a cterm=none gui=none
" hi VertSplit    ctermfg=15  guifg=#b2b2b2 ctermbg=237 guibg=#3a3a3a cterm=none gui=none
" set fillchars+=vert:\ " intentional whitespace after forward slash

" Start and End tags are same color
highlight Tag        ctermfg=04
highlight xmlTag     ctermfg=04
highlight xmlTagName ctermfg=04
highlight xmlEndTag  ctermfg=04

hi normal guibg=NONE ctermbg=NONE
" }}}

" {{{ Options

" Have { and } jumps skip over block
set foldopen-=block

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
set conceallevel=0
set noswapfile " Taboo
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
set signcolumn=yes
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
" }}}

" {{{ Functions and Commands

" Get terminal output
tnoremap <C-Enter> <C-\><C-n>mza<CR>

" Strip Whitespace
""""""""""""""""""
command! StripWhitespace %s/\s\+$//e

" Change working directory using z.sh
"""""""""""""""""""""""""""""""""""""
function! ZLookup(z_arg)
  let currwin=winnr()
  let z_command = 'windo cd ' . system('. ~/code/tools/z/z.sh && _z -e ' . a:z_arg)
  " Strip empty newline so that command line doesn't grow when echoing
  let z_command = substitute(z_command, "\n", "", "")
  execute z_command

  execute currwin . 'wincmd w'
  echo z_command
endfunction

command! -nargs=1 Z call ZLookup(<q-args>)

" Change working directory using ProjectRootCD
""""""""""""""""""""""""""""""""""""""""""""""
function! ProjectRootCDAll()
  let currwin=winnr()
  let cd_command = 'windo cd ' . ProjectRootGuess()
  execute cd_command
  execute currwin . 'wincmd w'
  echo cd_command
endfunction

command! -nargs=0 ProjectRootCDAll call ProjectRootCDAll()

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
function! Today()
  execute "normal! i> {{{\<CR>}}}"
  put! =strftime('%A // %B %d %Y')
  normal! VYppVr-o
  execute "normal! 4kJ3ji*\<Space>"
  startinsert!
endfunction
command! Today :call Today()

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

" }}}

" {{{ Mappings

" :)
nnoremap s <Nop>

" Insert mode maps
inoremap jk <Esc>
inoremap ;; <Esc>
inoremap <C-y> <Esc>

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

inoremap <C-h> <Esc><C-w>h
inoremap <C-j> <Esc><C-w>j
inoremap <C-k> <Esc><C-w>k
inoremap <C-l> <Esc><C-w>l
" inoremap <C-h> <Esc><C-w>h

" Default swaps
"""""""""""""""

" Swap jump to column of mark and jump to beginning of line of mark commands
nnoremap ' `
nnoremap ` '

" Use verymagic searching
" nnoremap / /\v
" vnoremap / /\v
" cnoremap %s/ %smagic/
" cnoremap \>s/ \>smagic/
" nnoremap :g/ :g/\v
" nnoremap :g// :g//

" xnoremap y y`]

" Make list selection for tags the default
nnoremap <c-]> g<c-]>
vnoremap <c-]> g<c-]>
nnoremap g<c-]> <c-]>
vnoremap g<c-]> <c-]>

nnoremap Y yg_

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

" Go to end of pattern match
nnoremap <leader>e //e<CR>

" Layout mappings
nnoremap st ml:tabedit %<CR>'l
nnoremap <leader>wr <C-w>j<C-w>j:b neoterm<CR><C-w>:res 20<CR><C-w>k
nnoremap <leader>w= <C-w>=<C-w>j:res 20<CR><C-w>k
nnoremap <leader>wl <C-w>=<C-w>j:res 15<CR><C-w>k
nnoremap <leader>w<space> :res +1<CR>:res -1<CR>

" Reload vimrc
nnoremap <leader>R :source $MYVIMRC<CR>

nnoremap <leader>zz :let &scrolloff=999-&scrolloff<CR>

nnoremap <leader>l <C-^>
nnoremap <leader>sl :nohlsearch<CR>
nnoremap <leader>sL :set hlsearch<CR>
nnoremap set :buffer term-<C-d>

nnoremap <leader>' "+
nnoremap <leader>y "+y
nnoremap <leader>p "+p
vnoremap <leader>y "+y
vnoremap <leader>p "+p
nnoremap <leader>wa :silent! :wall<CR>
nnoremap <leader>tq :tabclose<CR>
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

nnoremap <leader>gn :%s///gn<CR>
nnoremap <leader>file :set filetype=
" }}}

" {{{ Plugin Mappings

" nnn
nnoremap <leader>N :NnnPicker '%:p:h'<CR>
let g:nnn#action = {
      \ '<c-t><c-t>': 'tab split',
      \ '<c-s><c-s>': 'split',
      \ '<c-v>': 'vsplit' }

" Gundo
nnoremap <leader>gu :GundoToggle<CR>

" NERDTree
" nnoremap <leader>n :NERDTreeToggle<CR>
" nnoremap <leader>N :NERDTreeCWD<CR>

" vim-easy-align "
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

map <leader>m <Plug>ToggleMarkbar

" Coc-vim
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" FZF mappings
nnoremap <C-f> :GFiles<CR>
nnoremap <leader><C-f> :GFiles!<CR>


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
nnoremap <leader>fr :Rg<CR>

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
nnoremap <leader>fR :Rg!<CR>

function! RgVisualSelection()
  execute ':RgRaw ' . GetVisualSelection()
endfunction

""" vim-agriculture
" Setup query
nnoremap <leader>f; :RgRaw<Space>

" Perform :RgRaw search with word under cursor
nnoremap <leader>f* :execute ':RgRaw' expand('<cword>')<CR>

" Perform :RgRaw with current visual selection
xnoremap <leader>f* :call RgVisualSelection()<CR>

" fuzzy incsearch
map s/ <Plug>(incsearch-fuzzy-/)
map s? <Plug>(incsearch-fuzzy-?)
map sg/ <Plug>(incsearch-fuzzy-stay)

"winresizer
nnoremap <leader>ww :WinResizerStartResize<CR>

" Fugitive binds
nnoremap <leader>gst :Gstatus
nnoremap <leader>gsp :Gstatus
nnoremap <leader>gvs :Gvsplit
nnoremap <leader>blame :tabedit %<CR>:Gblame<CR><C-w>lV

" Change current working directory to project root of current buffer
nnoremap <leader>cd :ProjectRootCDAll<CR>

" LanguageClient
nmap slgd <Plug>(coc-definition)
nmap slgd <Plug>(coc-definition)
nmap slrn <Plug>(coc-rename)
nmap slre <Plug>(coc-references)
" }}}

" {{{ Plugin Settings

" vim-markdown
let g:mkdp_echo_preview_url=0
let g:mkdp_auto_close=0

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

" vim-devicons
" let g:webdevicons_conceal_nerdtree_brackets = 1
let g:WebDevIconsNerdTreeAfterGlyphPadding = ' '
let g:WebDevIconsNerdTreeGitPluginForceVAlign = 0

" Gutentags
" let g:gutentags_project_root=['.tags-root']

" vim-markbar
" let g:markbar_open_position='botright'
" let g:markbar_open_vertical=v:false
" let g:markbar_height=10
" let g:markbar_peekaboo_apostrophe_mapping="`"
" let g:markbar_peekaboo_backtick_mapping="'"

" vim-indentline
" let g:indentLine_color_term = 239
let g:indentLine_color_gui = '#5b5b5b'
" let g:indentLine_bgcolor_term = 230
let g:indentLine_fileTypeExclude=['markdown']
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

" NERDTree
let NERDTreeAutoDeleteBuffer=1
let NERDTreeDirArrows=1
let NERDTreeMinimalUI=1
let NERDTreeShowHidden=1
let NERDTreeHighlightCursorline=0
let g:NERDTreeMapHelp='\'
let g:NERDTreeSyntaxDisableDefaultExtensions=1
let g:NERDTreeDisableExactMatchHighlight=1
let g:NERDTreeDisablePatternMatchHighlight=1
let g:NERDTreeSyntaxEnabledExtensions=['c', 'h', 'c++', 'php', 'rb', 'js', 'jsx', 'html', 'css', 'yml'] " example

" vim-winresizer
let g:winresizer_start_key='<C-q>'

" incsearch
let g:incsearch#auto_nohlsearch=0

" FZF
if executable('rg')
  let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
  set grepprg=rg\ --vimgrep
  command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)
endif

imap <c-x><c-f> <plug>(fzf-complete-path)

let $FZF_DEFAULT_OPTS .= ' --no-height'

" :AG Only search file content, i.e. do not match directories
command! -bang -nargs=* AG
  \ call fzf#vim#ag(<q-args>, fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}), <bang>0)

" " :Ag Match directories as well (useful to filter out specs)
" command! -bang -nargs=* Ag
"   \ call fzf#vim#ag(<q-args>, fzf#vim#with_preview(), <bang>0)

" :Tags
command! -bang -nargs=* Tags call fzf#vim#tags(<q-args>, {'options': '--delimiter : --nth 4..'}, <bang>0)

command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

command! -bang -nargs=? -complete=dir GFiles
  \ call fzf#vim#gitfiles(<q-args>, fzf#vim#with_preview(), <bang>0)
" }}}

" {{{ :terminal settings

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
      edit neoterm
      return
    endif

    botright split
    enew
    execute 'Tnew'
    resize 20
    sleep 200m
    file neoterm
  endfunction
  nnoremap <leader>term :terminal<CR>:file term-

  " Terminal mode binds tnoremap jk <C-\><C-N>
  tnoremap ;; <C-\><C-N>
  tnoremap <C-y> <C-\><C-N>
  tnoremap granch $(g_branch)

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
  nnoremap <leader>tt :call OpenNeoterm()<CR>
  nnoremap <leader>T :call OpenNeoterm()<CR>
  nnoremap <leader>tfile :TREPLSendFile<CR>
  vnoremap <leader>tsel :TREPLSendSelection<CR>
  nnoremap <leader>tline :TREPLSendLine<CR>

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
source ~/.vimrc.private

" Search highlight comes back after reloading vimrc.  Hide it
nohlsearch
" }}}
