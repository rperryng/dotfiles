" TODO:
" 1. Write a command tabedit the result of `bundle info <gem>`
" 2. Write a command that deletes the 'project terminal', all buffers within
" 3. Write a command that opens a TODO in a floating window
" 4. Exiting from nnn session changes current working directory?
" 5. Add Brewfile
" 6. vimspector config for ruby tests
" the cwd, and closes the tab

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
Plug 'alvan/vim-closetag'
Plug 'arthurxavierx/vim-caser'
Plug 'christoomey/vim-tmux-navigator'
Plug 'dbakker/vim-projectroot'
Plug 'editorconfig/editorconfig-vim'
Plug 'gcmt/taboo.vim'
Plug 'gisphm/vim-gitignore'
Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
Plug 'habamax/vim-winlayout'
Plug 'haya14busa/incsearch-fuzzy.vim'
Plug 'haya14busa/incsearch.vim'
Plug 'iamcco/vim-language-server'
Plug 'inkarkat/vim-AdvancedSorters'
Plug 'inkarkat/vim-ingo-library'
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
Plug 'machakann/vim-swap'
Plug 'mcchrish/nnn.vim'
Plug 'michaeljsmith/vim-indent-object'
Plug 'moll/vim-bbye'
Plug 'nelstrom/vim-textobj-rubyblock'
Plug 'pbogut/fzf-mru.vim'
Plug 'prakashdanish/vim-githubinator'
Plug 'prettier/vim-prettier'
Plug 'puremourning/vimspector'
Plug 'rperryng/nvim-contabs'
Plug 'segeljakt/vim-isotope'
Plug 'simeji/winresizer'
Plug 'sindrets/diffview.nvim'
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
Plug 'tpope/vim-scriptease'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vim-ruby/vim-ruby'
Plug 'vimwiki/vimwiki'
Plug 'wellle/targets.vim'

" Neovim Nightly
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" To show tree style views for coworkers not used to buffer based workflows
Plug 'preservim/nerdtree'

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
Plug 'lukas-reineke/indent-blankline.nvim', { 'branch': 'lua' }
Plug 'machakann/vim-highlightedyank'
Plug 'mhinz/vim-signify'
Plug 'patstockwell/vim-monokai-tasty'
Plug 'qxxxb/vim-searchhi'
Plug 'rakr/vim-one'
Plug 'rust-lang/rust.vim'
Plug 'udalov/kotlin-vim'
Plug 'webdevel/tabulous'
Plug 'wlangstroth/vim-racket'
Plug 'folke/lsp-colors.nvim', { 'branch': 'main' }
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }

Plug 'morhetz/gruvbox'

" Requires lush
" Need to figure out terminal green color messed up
" Plug 'rktjmp/lush.nvim'
" Plug 'npxbr/gruvbox.nvim'

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
  let g:python_host_prog=trim(system('PYENV_VERSION=neovim2 pyenv which python'))
  let g:python3_host_prog=trim(system('PYENV_VERSION=neovim3 pyenv which python'))
else
  echom "missing pyenv.  No python host set."
endif

" Ruby
if executable('rbenv')
  let g:ruby_host_prog=trim(system('RBENV_VERSION=$(cat $DOTFILES_SOURCE/.ruby-version) rbenv which ruby'))
else
  echom "Missing rbenv.  No ruby host set."
endif

" Node
if executable('nodenv')
  let g:node_host_prog=trim(system('NODENV_VERSION=$(cat $DOTFILES_SOURCE/.node-version) nodenv which node'))
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
  " autocmd FileType typescript setlocal shiftwidth=4 tabstop=4 softtabstop=4
  autocmd FileType typescript setlocal shiftwidth=2 tabstop=2 softtabstop=2
  autocmd FileType rust setlocal shiftwidth=4 tabstop=4 softtabstop=4

  autocmd FileType rust nnoremap <buffer> <space>fo :RustFmt<CR>
  autocmd FileType typescript nnoremap <buffer> <space>fo :PrettierAsync<CR>

  " Help prevent accidentally modifying external source code resolved via
  " ctags or LSP functionality.
  autocmd BufReadPost */.cargo/*,*/.rustup/* setlocal readonly

  " hacky-fix for coc-vim leaving the popup menu window open when creating a ruby
  " block
  " autocmd FileType ruby inoremap <Space>do <Space>do<Space><Backspace>
augroup end

augroup neovim_terminal()
  autocmd!

  autocmd TermOpen * setlocal scrollback=50000
  autocmd TermOpen * setlocal nonumber
augroup end


function! s:enable_fzf_maps()
  tnoremap <buffer> <C-j> <down><down><down><down><down>
  tnoremap <buffer> <C-k> <up><up><up><up><up>
endfunction

augroup fzf_maps
  autocmd!

  autocmd TermOpen *fzf/bin/fzf* call s:enable_fzf_maps()
augroup end

" always open help in a vertical split

function! s:bufreadpost_help_buftype()
  if &buftype == 'help'
    wincmd L
    setlocal nonumber
  endif
endfunction

augroup vimrc_help
  autocmd!

  autocmd BufReadPost *.txt call s:bufreadpost_help_buftype()
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

function! ApplyColorSchemeTweaks()
  if g:colorscheme ==# 'gruvbox'
    " highlight DiffAdd     gui=none guifg=none    guibg=#15420e
    " highlight DiffDelete  gui=none guifg=#4b0000 guibg=#4b0000
    " highlight DiffChange  gui=none guifg=none    guibg=#516c5b
    " highlight DiffText    gui=none guifg=none    guibg=#a7722c

    highlight DiffAdd guibg=#282828 ctermbg=235 guifg=#8ec07c ctermfg=142 cterm=NONE gui=NONE
    highlight DiffChange guibg=#282828 ctermbg=235 guifg=#fdba48 ctermfg=108 cterm=NONE gui=NONE
    highlight DiffDelete guibg=#282828 ctermbg=235 guifg=#fb4934 ctermfg=167 cterm=NONE gui=NONE

    highlight DiffAdd  guifg = none guibg=#4b5632
    highlight DiffText gui   = none guifg=none    guibg=#47330b
  endif
endfunction

nnoremap <space>hi :echo 
      \ "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
      \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
      \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

augroup init_colors
    autocmd!
    autocmd ColorScheme * call ApplyColorSchemeTweaks()
augroup END

let g:gruvbox_contrast_dark='hard'
let g:tokyonight_style = 'storm'

let g:colorscheme = 'gruvbox'

execute("colorscheme " . g:colorscheme)
set background=dark

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
set synmaxcol=500
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
set number

set list
" set listchars=tab:>-,trail:~

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
" highlight! link Whitespace Error

" Searching
set ignorecase
set smartcase
set inccommand=split
" }}}
" {{{ Functions/Commands

" Redirect vim command into register
command! -nargs=+ -complete=command Redir let s:reg = @@ | redir @"> | silent execute <q-args> | redir END | new | pu | 1,2d_ | let @@ = s:reg

function! MatchStrAll(str, pat)
    let l:res = []
    call substitute(a:str, a:pat, '\=add(l:res, submatch(0))', 'g')
    return l:res
endfunction

function! EqualWindowHorizontally()
endfunction

function! OnlyWindow()
  let currwin=winnr()
endfunction

function! s:warn(message)
  echohl WarningMsg
  echom a:message
  echohl None
  return 0
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

" Eval vimscript contents
xnoremap <space>: y:@"<CR>

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

" Slow Paste
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

  let new_size = min([20, &lines / 3])
  execute "resize" . new_size
  execute currwin . 'wincmd w'
endfunction

nnoremap <space>w= :silent call TerminalResize()<CR>

function! OpenAndSendCmdToProjectTerminal(cmd, ...)
  let l:append_enter = a:0 >= 1 ? a:1 : 1

  let l:project_name = fnamemodify(getcwd(), ':t')
  let l:current_buf_name = bufname()
  let l:terminal_buf_name = 'term-misc-' . l:project_name
  let l:channel_id = -1
  let l:current_win = nvim_get_current_win()

  wincmd b
  if bufname() !~ "term-"
    botright split
    call TerminalResize()
  endif

  if !bufexists(l:terminal_buf_name)
    terminal
    execute 'file ' . l:terminal_buf_name
    call TerminalResize()
  elseif bufname() !~ l:terminal_buf_name
    execute 'edit ' . l:terminal_buf_name
  endif

  let l:cmd = l:append_enter ? a:cmd . "\<cr>" : a:cmd
  call chansend(b:terminal_job_id, l:cmd)
  normal G
  wincmd p
endfunction

function! ToggleProjectTerminal()
  let l:project_name = fnamemodify(getcwd(), ':t')
  let l:current_buf_name = bufname()
  let l:terminal_buf_name = 'term-misc-' . l:project_name

  wincmd b
  if bufname() !~ "term-"
    botright split
    call TerminalResize()
  endif

  if !bufexists(l:terminal_buf_name)
    terminal
    execute 'file ' . l:terminal_buf_name
  elseif bufname() !~ l:terminal_buf_name
    execute 'edit ' . l:terminal_buf_name
  else
    quit
  endif
endfunction

command! -nargs=0 ToggleProjectTerminal call ToggleProjectTerminal()

" function! SendCommandToProjectTerminal(cmd)
"   let l:project_name = fnamemodify(getcwd(), ':t')
"   let l:current_buf_name = bufname()
"   let l:terminal_buf_name = 'term-misc-' . l:project_name

"   execute 'edit ' . l:terminal_buf_name
"   let l:channel_id = b:terminal_job_id
"   execute 'edit ' . l:current_buf_name

"   chansend(l:channel_id, cmd)
" endfunction

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
    put! =strftime('= %A - %B %d %Y =')
    startinsert!
  elseif search(l:date_formatted . '\n\%(\*.*\)\{1,}\n$', 'e') != 0
    execute 'normal! G{{}O*\<Space>'
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

function! NNStart()
  edit ~/.vimrc
  cd ~/code/dotfiles
  split
  terminal
  file term-misc-dotfiles
  call TerminalResize()
  TabooRename dotfiles
endfunction

" function VimTestVimspectorStrategyTest(executable, args)
"   if !(filereadable(".vimspector.json"))
"     echo "No '.vimspector.json' found, starting with vscode-node sample"
"     system('cp ~/.vimspector.json.sample ./.vimspector.json')
"   endif

"   let l:vimspector_config = json_decode(join(readfile('.vimspector.json')))

"   " Assign program
"   let l:vimspector_config['configurations']['run']['configuration']['program'] =
"         \ '${workspaceFolder}/' . a:executable

"   " Assign args
"   let l:vimspector_config['configurations']['run']['configuration']['args'] =
"         \ a:args
"         " \ map(copy(a:args), { _, val -> substitute(val, '\$', '\\$', '') })

"   call writefile(split(json_encode(l:vimspector_config), "\n"), glob('.vimspector.json'), 'b')

"   " Start the debugger
"   call vimspector#Continue()
" endfunction

function! VimTestVimspectorStrategy(cmd)
  if !filereadable(".vimspector.json")
    echo "No '.vimspector.json' found, starting with vscode-node sample"
    call system('cp ~/.vimspector.json.sample ./.vimspector.json')
  endif

  let l:vimspector_config = json_decode(join(readfile('.vimspector.json')))

  " Assign program
  let l:program = split(a:cmd, ' ')[0]
  let l:vimspector_config['configurations']['run']['configuration']['program'] =
        \ '${workspaceFolder}/' . l:program

  " Assign program_args
  " Remove the program from the string
  let l:program_args = join(split(a:cmd, " ")[1:], " ")

  " split by spaces unless within quotes.  No good way to do this with vimscript
  " TODO: is this escaping enough?
  let l:split_cmd = 'printf "%s" "' . escape(l:program_args, '"') . '" | xargs -n 1 printf "%s\n"'
  let l:print_output = system(l:split_cmd)
  let l:program_args = split(l:print_output, "\n")

  " Re-quote strings with spaces in them
  call map(l:program_args, { _, arg -> match(arg, ' ') >= 0 ? "'" . arg . "'" : arg })

  " vimspector uses python template strings, escape '$' with '$$'
  call map(l:program_args, { _, arg -> substitute(arg, '\$', '$$', 'g') })

  let l:vimspector_config['configurations']['run']['configuration']['args'] = l:program_args

  call writefile(split(json_encode(l:vimspector_config), "\n"), glob('.vimspector.json'), 'b')

  " Start the debugger
  call vimspector#Continue()
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
nnoremap <space>rl :source $MYVIMRC<CR>

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

vnoremap <space>o :<C-U> call system('open ' . GetVisualSelection())<CR>
nnoremap <space>S :mksession! ./Session.manual.vim
nnoremap <space>R :source! ./Session.manual.vim
" }}}
" {{{ Plugin Config

" {{{ Nnn
let g:nnn#command = 'nnn -H'
let g:nnn#action = {
      \ '<c-t><c-t>': 'tab split',
      \ '<c-s><c-s>': 'split',
      \ '<c-v>': 'vsplit' }

nnoremap <space>n :NnnPicker<CR>
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
" nnoremap <silent> <space>tR :execute 'TabooRename ' . expand('%')<CR>
nnoremap <space>tR :execute 'TabooRename ' . fnamemodify(getcwd(), ':t')<CR>
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

let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.8 } }

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

function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --no-ignore --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)
" mnemonic: straight up ripgrep with no fzf syntax support accross all files

function! s:project_buffer_open(buffer)
  execute ':buffer ' . bufnr(bufname(a:buffer))
endfunction

" :Project buffers
function! ProjectBuffers()
  let l:project_root = ProjectRootGet()
  let l:buffers = filter(range(1, bufnr('$')), 'bufloaded(v:val)')
  let l:project_buffers = filter(l:buffers, { _, val ->
        \   stridx(fnamemodify(bufname(val), ':p'), l:project_root) > -1
        \ })
  let l:names = sort(map(copy(l:project_buffers), { _, val -> bufname(val) }))

  call fzf#run(fzf#wrap(fzf#vim#with_preview({
        \    'source': l:names,
        \    'sink': function('s:project_buffer_open'),
        \ })))
endfunction
command! -nargs=* ProjectBuffers call ProjectBuffers()

function! s:fuzzy_tab_open_handler(tab_name)
  echom "handler called"
  let l:tabnr = matchstr(a:tab_name, '[0-9]\+')
  execute 'normal ' . l:tabnr . 'gt'
endfunction
function! FuzzyTabs()
  let l:tabs = sort(copy(MatchStrAll(TabooTabline(), '\[[0-9]\+-[^]]\+\]')))
  call fzf#run(fzf#wrap({
        \    'source': l:tabs,
        \    'sink': function('s:fuzzy_tab_open_handler'),
        \ }))
endfunction

function! s:fuzzy_buffer_delete_handler(projects)
  let l:project_roots = map(copy(a:projects), { _, project_path -> fnamemodify(project_path, ':p') })
  let l:buffers = filter(range(1, bufnr('$')), 'bufloaded(v:val)')
  call map(l:buffers, { _, buf -> fnamemodify(bufname(buf), ':p')})

  " Filter buffers which belong to a selected project
  let l:buffers_to_delete = filter(
        \ copy(l:buffers),
        \ { _, buf -> len(filter(
        \         copy(l:project_roots),
        \         { _, project_root -> match(buf, project_root) > -1 }
        \ )) > 0 },
        \ )

  " Filter terminal buffers which match a selected project
  let l:terminal_buffer_names = map(
        \ copy(a:projects),
        \ { _, project -> 'term-misc-' . fnamemodify(project, ':t') }
        \ )

  call extend(l:buffers_to_delete, l:terminal_buffer_names)

  echom "deleting buffers: " . join(l:buffers_to_delete, "\n")
  for b in buffers_to_delete
    execute 'Bdelete! ' . b
  endfor

  " Close tabs for selected projects
  for project in a:projects
    let l:tabs = sort(copy(MatchStrAll(TabooTabline(), '\[[0-9]\+-[^]]\+\]')))
    let l:index = index(l:tabs, project)
    if l:index >= 0
      echom "closing tab: " . l:tabs[l:index]

      let l:index += 1
      execute l:index . 'tabclose'
    endif
  endfor

  " Remove NoName tabs
  let l:tabs = sort(copy(MatchStrAll(TabooTabline(), '\[[0-9]\+-[^]]\+\]')))
  for x in range(1, len(l:tabs))
    let l:index = index(l:tabs, 'NoName')
    if l:index >= 0
      echom "closing tab: " . l:tabs[l:index]

      let l:index += 1
      execute l:index . 'tabclose'
    endif
  endfor
endfunction

function! FuzzyBufferDelete()
  let l:buffers = filter(range(1, bufnr('$')), 'bufloaded(v:val)')
  call map(l:buffers, { _, buf -> fnamemodify(bufname(buf), ':p')})

  let l:project_roots = map(copy(l:buffers), { _, bufpath -> projectroot#get(bufpath) })
  call filter(l:project_roots, { _, path ->
        \ path != '' &&
        \ path != '.' &&
        \ path !~ '^/usr' &&
        \ path !~ '/.local/'
        \ })
  call uniq(l:project_roots)

  let dict = {}
  for l in l:project_roots
    let dict[l] = ''
  endfor
  let unique_project_roots = map(keys(dict), { _, path -> fnamemodify(path, ':~') })

  call fzf#run(fzf#wrap({
        \    'source': l:unique_project_roots,
        \    'sink*': function('s:fuzzy_buffer_delete_handler'),
        \    'options': '--multi',
        \ }))
endfunction

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

command! -nargs=0 FzfGDiffView
      \ call fzf#run(fzf#wrap(fzf#vim#with_preview({
      \    'source': 'git log --oneline --graph --color=always ' . fzf#shellescape('--format=%C(auto)%h%d %s %C(green)%cr'),
      \ })))

function! s:get_git_root()
  let root = split(system('git rev-parse --show-toplevel'), '\n')[0]
  return v:shell_error ? '' : root
endfunction

function! s:fzf_commits_diffview_sink(commits) abort
  let pat = '[0-9a-f]\{7,9}'
  let hashes = filter(map(copy(a:commits), 'matchstr(v:val, pat)'), 'len(v:val)')

  if len(hashes) == 1
    let cmd = 'DiffviewOpen '.hashes[0].'..HEAD'
    echom 'executing cmd: '.cmd
    execute cmd
  elseif len(hashes) == 2
    let hash1 = hashes[0]
    let hash2 = hashes[1]
    let cmd = "git log ".hash1." ".hash2." --format='%h' --author-date-order | rg '".hash1."|".hash2."'"
    echom "executing: ".cmd
    let sorted_hashes = split(trim(system(cmd), "\n"))
    call assert_true(len(sorted_hashes) == 1, "failed to sorted hashes using cmd: '".cmd."'")

    let newer = sorted_hashes[0]
    let older = sorted_hashes[1]
    echom 'older:'.older
    echom 'newer:'.newer
    execute 'DiffviewOpen '.older.'..'.newer
  else
    call s:warn('[s:fzf_commits_diffview_sink] didn''t know what to do for selection: '.a:commits)
  endif
endfunction

function! FzfCommitsDiffview(buffer_local)
  let root = s:get_git_root()
  if empty(root)
    return s:warn('Not in git repo')
  endif

  let source = 'git log --oneline --color=always '
       \ . fzf#shellescape('--format=%C(auto)%h%d %s %C(green)%cr')
  let current = expand('%')
  let managed = 0
  if !empty(current)
    call system('git show '.fzf#shellescape(current).' 2> /dev/null')
    let managed = !v:shell_error
  endif

  if a:buffer_local
    if !managed
      return s:warn('The current buffer is not in the working tree')
    endif
    let source .= ' --follow '.fzf#shellescape(current)
  else
    let source .= ' --graph'
  endif

  let options = {
        \ 'source': source,
        \ 'sink*': function('s:fzf_commits_diffview_sink'),
        \ 'options': ['--ansi', '--multi', '--tiebreak=index'],
        \ }

  call extend(options.options,
        \ ['--preview', 'echo {} | grep -o "[a-f0-9]\{7,\}" | head -1 | xargs git show --format=format: --color=always'])

  call fzf#run(fzf#wrap(options))
endfunction

command! -nargs=0 GDiffFiles
      \ call fzf#run(fzf#wrap(fzf#vim#with_preview({
      \    'source': split(trim(system('git diff --name-only')), "\n"),
      \ })))

command! -nargs=0 GDiffMainFiles
      \ call fzf#run(fzf#wrap(fzf#vim#with_preview({
      \    'source': split(trim(system('git diff $(git_default_branch) --name-only')), "\n"),
      \ })))

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

" FZF Binds
nnoremap <space><C-f> :GFiles<CR>

nnoremap <space>fb :Buffers<CR>
nnoremap <space>fc :Commands<CR>
nnoremap <space>fi :Files<CR>
nnoremap <space>fh :Helptags<CR>
nnoremap <space>flb :BLines<CR>
nnoremap <space>fla :Lines<CR>
nnoremap <space>fm :Marks<CR>
nnoremap <space>fgl :GFiles?<CR>
nnoremap <space>fw :Windows<CR>
nnoremap <space>fa :Rg<CR>
nnoremap <space>fA :RG<CR>
nnoremap <space>fr :Rg<CR>
nnoremap <space>ft :TerminalBuffers<CR>
nnoremap <space>fsa :RgNoSpec<CR>
nnoremap <space>fz :FZFMru<CR>

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

nnoremap <space>fgdv :call FzfCommitsDiffview(0)<CR>
nnoremap <space>fgdbv :call FzfCommitsDiffview(1)<CR>
nnoremap <space>fgdf :GDiffFiles<CR>
nnoremap <space>gdmf :GDiffMainFiles<CR>
nnoremap <space>fd :call FuzzyBufferDelete()<CR>
nnoremap <space>fA :RI<CR>
nnoremap <space>rg :RG<CR>
nnoremap <space>fu :ProjectBuffers<CR>
nnoremap <space>fq :call FuzzyTabs()<CR>

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
nnoremap <space>gvs :Gvsplit<CR>
nnoremap <space>blame :tabedit %<CR>:Gblame<CR><C-w>lV
" }}}
" {{{ vim-projectroot
let g:rootmarkers = [
      \  'Gemfile',
      \  '.projectroot',
      \  '.git',
      \  '.hg',
      \  '.svn',
      \  '.bzr',
      \  '_darcs',
      \  'build.xml',
      \  'MIT-LICENSE',
      \  'README.md'
      \ ]

" Change current working directory of all windows in tab to project root of current buffer
function! TcdProjectRoot()
  let l:project_root = ProjectRootGet()

  if l:project_root == ''
    echo "couldn't determine project root.  Current working directory remains at " . getcwd()
    return
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
      \ :silent call repeat#set("\<Plug>(coc-diagnostic-next)", v:count)<CR>
nmap <silent> gp <Plug>(coc-diagnostic-prev)
      \ :silent call repeat#set("\<Plug>(coc-diagnostic-prev)", v:count)<CR>
nmap <silent> <space>re <Plug>(coc-refactor)
nmap <silent> <space>rn <Plug>(coc-rename)
nmap <silent> <space>rn <Plug>(coc-list)
nnoremap <silent> <space>gl :CocList diagnostics<CR>
inoremap <silent><expr> <c-space> coc#refresh()
inoremap <silent> <c-l> <Esc>:call CocActionAsync('showSignatureHelp')<CR>a
nmap <silent> <space>A :CocAction<CR>

nnoremap K :call CocAction('doHover')<CR>
" vmap <silent> re <Plug>(coc-refactor)
vmap <silent> <space>ac :CocAction<CR>

imap <silent><expr> <c-k> <Plug>(coc-float-jump)
nmap <silent> gF <Plug>(coc-float-jump)
nmap <silent> gH <Plug>(coc-float-hide)
nmap <silent> <esc> <Plug>(coc-float-hide)

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

let g:test#custom_strategies = {
      \ 'project_terminal': function('OpenAndSendCmdToProjectTerminal'),
      \ 'vimspector': function('VimTestVimspectorStrategy'),
      \ }
      " \ 'vimspector*': function('VimTestVimspectorStrategyTest'),
let g:test#strategy = 'project_terminal'
" }}}
" {{{ closetag
let g:closetag_filenames = '*.html,*.xhtml,*.jsx,*.js'
let g:closetag_xhtml_filenames = '*.xhtml,*.jsx,*.js'
let g:closetag_shortcut = '>'
" }}}
" {{{ vim-indentline
" let g:indentLine_color_gui = '#5b5b5b'
" let g:indentLine_fileTypeExclude=['markdown']
" let g:indentLine_bufTypeExclude=['help', 'terminal']

let g:indent_blankline_buftype_exclude=['help', 'terminal']
" let g:indent_blankline_char = '┊'
let g:indent_blankline_char = '▏'
" ¦
" ┆
" │
" ▏
"
" ⎸

" let g:indentLine_char = '┊'
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
nnoremap <space>gg :SignifyToggle<CR>

nmap ]c <Plug>(signify-next-hunk)
      \ :silent call repeat#set("\<Plug>(signify-next-hunk)", -1)<CR>
nmap [c <Plug>(signify-prev-hunk)
      \ :silent call repeat#set("\<Plug>(signify-prev-hunk)", -1)<CR>
nmap <space>gdh :SignifyHunkDiff<CR>
nmap <space>gdu :SignifyHunkUndo<CR>

" }}}
" {{{ nvim-contabs
let g:contabs#project#locations = [
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

  " Open termainal tab? nah
  " split
  " terminal
  " call TerminalResize()

  " let l:buf_name = 'term-misc-' . l:project_name
  " if (bufexists(l:buf_name))
  "   edit l:buf_name
  " else
  "   execute 'file ' . l:buf_name
  " endif

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
let g:gutentags_enabled=0
" }}}
" nerdtree {{{
nnoremap <space><space> :NERDTreeFind<CR>
" }}}
" ToggleHidden {{{
let s:hidden_all = 0
function! ToggleHiddenAll()
  if s:hidden_all  == 0
    let s:hidden_all = 1
    set noshowmode
    set noruler
    set laststatus=0
    set noshowcmd
  else
    let s:hidden_all = 0
    set showmode
    set ruler
    set laststatus=2
    set showcmd
  endif
endfunction

nnoremap <space>H :call ToggleHiddenAll()<CR>
" }}}
" {{{ vimspector
let g:vimspector_install_gadgets = ['vscode-node-debug-2']

let g:vimspector_sign_priority = {
      \    'vimspectorBP':         20,
      \    'vimspectorBPCond':     19,
      \    'vimspectorBPDisabled': 1,
      \    'vimspectorPC':         999,
      \ }

nmap <space>ds <Plug>VimspectorStop
nmap <space>drs <Plug>VimspectorRestart
nmap <space>dh <Plug>VimspectorRunToCursor
nmap <space>dsin <Plug>VimspectorStepInto
nmap <space>dsou <Plug>VimspectorStepOut
nnoremap <space>dsD :VimspectorReset<CR>

nmap <silent><space>dc <Plug>VimspectorContinue
      \ :silent call repeat#set("\<Plug>VimspectorContinue", -1)<CR>
nmap <silent><space>db <Plug>VimspectorToggleBreakpoint
      \ :silent call repeat#set("\<Plug>VimspectorToggleBreakpoint", -1)<CR>
nmap <silent><space>dsov <Plug>VimspectorStepOver
      \ :silent call repeat#set("\<Plug>VimspectorStepOver", -1)<CR>
nmap <silent><space>dse <Plug>VimspectorBalloonEval
      \ :silent call repeat#set("\<Plug>VimspectorBalloonEval", -1)<CR>

" See: VimTestVimspectorStrategy
" }}}
" {{{ vim-projectionist
let g:projectionist_heuristics = {
      \ 'Gemfile.lock|*.gemspec': {
      \   '*.rb': {
      \     'type': 'source',
      \     'alternate': 'spec/{}_spec.rb',
      \   },
      \   'spec/*_spec.rb': {
      \     'alternate': '{}.rb',
      \     'type': 'test',
      \   },
      \ },
      \ 'package.json': {
      \   'package.json': {
      \     'type': 'package',
      \     'alternate': ['yarn.lock', 'package-lock.json'],
      \   },
      \   'package-lock.json': {
      \     'alternate': 'package.json',
      \   },
      \   'yarn.lock': {
      \     'alternate': 'package.json',
      \   },
      \   'src/*.ts': {
      \     'type': 'source',
      \     'alternate': [
      \       'src/{}.test.ts',
      \       'src/{}.spec.ts',
      \     ],
      \   },
      \   'src/*.test.ts': {
      \     'type': 'test',
      \     'alternate': 'src/{}.ts'
      \   },
      \   'src/*.spec.ts': {
      \     'type': 'test',
      \     'alternate': 'src/{}.ts'
      \   },
      \ }}

" Undocumented feature
" FZF is really slow with projectionist for some reason.
" https://github.com/junegunn/fzf.vim/issues/392#issuecomment-440238233
let g:projectionist_ignore_term = 1

nnoremap <space>a :A<CR>

" }}}
" {{{ DiffView
nnoremap <space>gdo :DiffviewOpen ..HEAD<left><left><left><left><left><left>
" }}}
" {{{ vim-winlayout
nmap <space>wu <Plug>(WinlayoutBackward)
nmap <space>wr <Plug>(WinlayoutForward)
" }}}

" }}}
" {{{ lua
lua <<EOF
require'nvim-treesitter'
-- require'lsp'
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained",
  highlight = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
}

-- Diffview
local cb = require'diffview.config'.diffview_callback
require'diffview'.setup {
  diff_binaries = false,    -- Show diffs for binaries
  file_panel = {
    width = 35,
    use_icons = false        -- Requires nvim-web-devicons
  },
  key_bindings = {
    -- The `view` bindings are active in the diff buffers, only when the current
    -- tabpage is a Diffview.
    view = {
      ["<tab>"]    = cb("select_next_entry"),  -- Open the diff for the next file
      ["<s-tab>"]  = cb("select_prev_entry"),  -- Open the diff for the previous file
      ["<space>"]  = cb("focus_files"),        -- Bring focus to the files panel
      ["<space>b"] = cb("toggle_files"),       -- Toggle the files panel.
    },
    file_panel = {
      ["j"]        = cb("next_entry"),         -- Bring the cursor to the next file entry
      ["k"]        = cb("prev_entry"),         -- Bring the cursor to the previous file entry.
      ["<cr>"]     = cb("select_entry"),       -- Open the diff for the selected entry.
      ["o"]        = cb("select_entry"),
      ["R"]        = cb("refresh_files"),      -- Update stats and entries in the file list.
      ["<tab>"]    = cb("select_next_entry"),
      ["<s-tab>"]  = cb("select_prev_entry"),
      ["<space>e"] = cb("focus_files"),
      ["<space>b"] = cb("toggle_files"),
    }
  }
}
EOF
" }}}
" {{{ Terminal buffer configs

if has('nvim')
  augroup tmappings
    autocmd!
  augroup end

  " UI
  " hi! TermCursorNC ctermfg=1 ctermbg=2 cterm=NONE gui=NONE
  hi! TermCursorNC ctermfg=15 guifg=#fdf6e3 ctermbg=14 guibg=#93a1a1 cterm=NONE gui=NONE

  nnoremap <space>T :call ToggleProjectTerminal()<CR>

  nnoremap <space>term :terminal<CR>:file term-

  " Terminal mode binds tnoremap jk <C-\><C-N>
  tnoremap ;; <C-\><C-N>
  tnoremap <C-s> <C-\><C-n>
  tnoremap <C-q> <C-\><C-n>
  tnoremap <C-\><C-\> <C-n>
  tnoremap <C-\><C-s> <C-n>
  tnoremap granch $(g_branch)
  " tnoremap is0 iso8601

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
  nnoremap \t :call ToggleProjectTerminal()<CR>

  " ?? For some reason, after a while the binding stops working...
  " Wrapping it in another function seems ok.
  function! RunLastCommandInProjectTerminal()
    call OpenAndSendCmdToProjectTerminal("\<C-p>")
  endfunction

  nnoremap <space>tn :silent! :wall<CR>:TestNearest<CR>
  nnoremap <space>tf :silent! :wall<CR>:TestFile<CR>
  nnoremap <space>ts :silent! :wall<CR>:TestSuite<CR>
  nnoremap <space>tl :silent! :wall<CR>:TestLast<CR>
  nnoremap <space>to :TestVisit<CR>

  nnoremap <space>tp :call RunLastCommandInProjectTerminal()<CR>

  nnoremap <space>dn :silent! :wall<CR>:TestNearest -strategy=vimspector<CR>
  nnoremap <space>df :silent! :wall<CR>:TestFile -strategy=vimspector<CR>
  nnoremap <space>dl :silent! :wall<CR>:TestLast -strategy=vimspector<CR>
  nnoremap <space>ds :silent! :wall<CR>:TestSuite -strategy=vimspector<CR>

  nnoremap <space>dn :TestNearest -strategy=vimspector<CR>
  nnoremap <space>df :TestFile -strategy=vimspector<CR>
  nnoremap <space>ds :TestSuite -strategy=vimspector<CR>

  nnoremap <space>Dn :TestNearest -strategy=vimspector*<CR>
  nnoremap <space>Df :TestFile -strategy=vimspector*<CR>
  nnoremap <space>Ds :TestSuite -strategy=vimspector*<CR>

  nnoremap <space>tL :silent! :wall<CR>:Tkill<CR>:Tkill<CR>:TestLast<CR>
  nnoremap <space>tfile :TREPLSendFile<CR>
  vnoremap <space>tsel :TREPLSendSelection<CR>
  " nnoremap <space>tline :TREPLSendLine<CR>

  function! KillAndRunLastCommandInProjectTerminal()
    call OpenAndSendCmdToProjectTerminal("\<c-c>", 0)
    call OpenAndSendCmdToProjectTerminal("\<c-c>", 0)
    call OpenAndSendCmdToProjectTerminal("\<c-p>", 1)
  endfunction

  " nnoremap <space>tL :call OpenAndSendCmdToProjectTerminal("\<c-c>\<c-c>\<c-p>")
  nnoremap <space>tL :call KillAndRunLastCommandInProjectTerminal()<CR>
  nnoremap <space>tg :TestVisit<CR>
  nnoremap <space>tfile :TREPLSendFile<CR>
  vnoremap <space>tsel :TREPLSendSelection<CR>
  " nnoremap <space>tline :TREPLSendLine<CR>

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
