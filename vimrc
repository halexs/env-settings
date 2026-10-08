" ============================================================================
" env-settings vimrc  (Vim 8.1+ and Neovim)
"
" Sourced from ~/.vimrc by `make vim`. Machine-specific tweaks go in
" ~/.vimrc.local, which is loaded last. Run `make vim-plugins` once to install
" vim-plug and the plugins; until then everything below still works, minus the
" plugin features.
"
" Leader is <Space>. Press <Space>? for a searchable list of every key and
" command (:Keys), or run :Cheatsheet.
" ============================================================================
" encoding must be set before scriptencoding, or the Unicode glyphs below are
" mangled under a non-UTF-8 locale.
if &encoding !=? 'utf-8' | set encoding=utf-8 | endif
scriptencoding utf-8

if &compatible | set nocompatible | endif

if exists('g:env_settings_loaded') || v:version < 801
  finish
endif
let g:env_settings_loaded = 1

" Leader first: plugin and Lua mappings below capture it when they are defined.
let g:mapleader = "\<Space>"
let g:maplocalleader = ','

" Repo root, used to find templates/.
let s:root = fnamemodify(resolve(expand('<sfile>:p')), ':h')

" Per-editor state directory (undo, swap, sessions). Neovim and Vim keep
" separate ones because their undo file formats are not compatible.
let s:datadir = has('nvim') ? stdpath('data') : expand('~/.vim')
for s:d in ['undo', 'swap', 'backup', 'sessions']
  if !isdirectory(s:datadir . '/' . s:d)
    silent! call mkdir(s:datadir . '/' . s:d, 'p', 0700)
  endif
endfor
unlet s:d

" ----------------------------------------------------------------------------
" Plugins (vim-plug)
" ----------------------------------------------------------------------------
let s:plug_file = has('nvim') ? stdpath('data') . '/site/autoload/plug.vim'
      \                       : expand('~/.vim/autoload/plug.vim')
let s:use_plug = filereadable(s:plug_file)

" ALE settings that must be set before it loads.
" Neovim 0.11+ uses its built-in LSP client instead (see nvim/ide.lua).
let s:nvim_ide = has('nvim-0.11')
let g:ale_completion_enabled = s:nvim_ide ? 0 : 1
let g:ale_disable_lsp = s:nvim_ide ? 1 : 'auto'

if s:use_plug
  call plug#begin(s:datadir . '/plugged')

  " Look and feel
  Plug 'catppuccin/vim', { 'as': 'catppuccin' }
  Plug 'itchyny/lightline.vim'

  " Navigation and search
  Plug 'preservim/nerdtree' | Plug 'Xuyuanp/nerdtree-git-plugin'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'

  " Git: change signs, fugitive, GitLens-style inline blame, commit popup per line
  Plug 'airblade/vim-gitgutter'
  Plug 'tpope/vim-fugitive'
  Plug 'APZelos/blamer.nvim'
  Plug 'rhysd/git-messenger.vim'

  " VS Code-like chrome: buffer tab bar on top, start screen
  Plug 'mengelbrecht/lightline-bufferline'
  Plug 'mhinz/vim-startify'

  " Editing
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-repeat'
  Plug 'machakann/vim-highlightedyank'
  Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }

  " Languages: syntax/indent for ~600 filetypes (replaces jsx-pretty, python-syntax)
  Plug 'sheerun/vim-polyglot'
  " Linting, fixing and LSP completion
  Plug 'dense-analysis/ale'

  " Neovim only: IDE features (LSP, installer) and Claude Code integration.
  if s:nvim_ide
    Plug 'neovim/nvim-lspconfig'
    Plug 'mason-org/mason.nvim'
    Plug 'folke/which-key.nvim'
    Plug 'folke/snacks.nvim'
    Plug 'coder/claudecode.nvim'
    Plug 'MeanderingProgrammer/render-markdown.nvim'
    Plug 'lukas-reineke/indent-blankline.nvim'
  endif

  call plug#end()

  if s:nvim_ide
    execute 'luafile' fnameescape(s:root . '/nvim/ide.lua')
  endif
endif

" True when a plug-in was installed AND is registered, e.g. s:has('ale').
function! s:has(name) abort
  return s:use_plug && has_key(get(g:, 'plugs', {}), a:name) && isdirectory(g:plugs[a:name].dir)
endfunction

" ----------------------------------------------------------------------------
" Core options
" ----------------------------------------------------------------------------
set nobomb
set backspace=indent,eol,start
set nrformats-=octal
set hidden                          " switch buffers without saving
set autoread
set belloff=all
set history=1000
set ttimeout ttimeoutlen=10
set timeoutlen=500
set updatetime=250                  " gitgutter / CursorHold latency
set display=lastline
set formatoptions+=j                " drop comment leader when joining lines
set nojoinspaces
set viminfo='200,<500,s50,h

" Files: keep swap/backup/undo out of project directories.
let &directory = s:datadir . '/swap//'
let &backupdir = s:datadir . '/backup//'
set backup writebackup
set undofile
let &undodir = s:datadir . '/undo'
set undolevels=1000 undoreload=10000

" Mouse and clipboard
set mouse=a
if !has('nvim') && exists('&ttymouse')
  silent! set ttymouse=sgr
endif
if has('clipboard')
  set clipboard=unnamed
  if !has('mac') && !has('macunix')
    set clipboard=unnamedplus
  endif
endif

" Display
set number relativenumber
set cursorline
set signcolumn=yes
set scrolloff=5 sidescrolloff=8
set showcmd
set ruler
set wrap linebreak
if exists('&breakindent') | set breakindent | endif
set list listchars=tab:▸\ ,trail:·,nbsp:␣,extends:›,precedes:‹
set fillchars=vert:│,fold:─
set showmatch matchtime=2
set shortmess-=S shortmess+=c       " show search count, quiet completion
set laststatus=2
set splitright splitbelow

" Search
set ignorecase smartcase
set incsearch hlsearch

" Indentation (filetype specific overrides live in the autocmds below)
set expandtab
set tabstop=4 shiftwidth=4 softtabstop=4
set autoindent smartindent

" Folding: off by default, indent based when toggled on (zi).
set foldmethod=indent nofoldenable foldlevel=99

" Command-line completion
set wildmenu
set wildmode=longest:full,full
if has('patch-8.2.4325') || has('nvim')
  set wildoptions=pum
endif
set wildignore+=**/node_modules/**,**/build/**,**/dist/**,**/.git/**,**/__pycache__/**,*.pyc
set path+=**

" Completion popup
set completeopt=menuone,noselect
if has('patch-8.1.1880')
  set completeopt+=popup
endif
set complete-=i                     " scanning includes is slow in big repos

" Tags: look upward from the current file for a tags file (see `make ctags`).
set tags=./tags;/

" Searching: ripgrep when available (also feeds :Grep).
if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case\ --hidden\ --glob\ '!.git'
  set grepformat=%f:%l:%c:%m
else
  set grepprg=grep\ -rnH\ --exclude-dir=.git\ --exclude-dir=node_modules
endif

" ----------------------------------------------------------------------------
" Appearance
" ----------------------------------------------------------------------------
syntax enable
set background=dark

" True colour when the terminal supports it (tmux.conf enables RGB too).
if has('termguicolors') && (has('nvim') || $COLORTERM =~# 'truecolor\|24bit')
  if !has('nvim') && &term =~# '^\(screen\|tmux\)'
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  endif
  set termguicolors
endif

" Cursor shape follows the mode: bar in insert, underline in replace.
if !has('nvim') && !has('gui_running') && &term !~# 'linux'
  let &t_SI = "\<Esc>[6 q"
  let &t_SR = "\<Esc>[4 q"
  let &t_EI = "\<Esc>[2 q"
endif

augroup EnvColors
  autocmd!
  autocmd ColorScheme * highlight clear SignColumn
  autocmd ColorScheme * highlight! link Blamer Comment
augroup END

if s:has('catppuccin') && &t_Co >= 256 && (&termguicolors || has('gui_running'))
  silent! colorscheme catppuccin_mocha
elseif has('patch-9.0.0')
  silent! colorscheme habamax         " ships with Vim 9, fine in 256 colours
endif

" Status line: lightline when installed, a plain one otherwise.
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left':  [['mode', 'paste'], ['branch', 'readonly', 'filename', 'modified']],
      \   'right': [['lineinfo'], ['percent'], ['filetype', 'fileencoding']],
      \ },
      \ 'component_function': { 'branch': 'EnvBranch' },
      \ 'tabline': { 'left': [['buffers']], 'right': [['close']] },
      \ 'component_expand': { 'buffers': 'lightline#bufferline#buffers' },
      \ 'component_type': { 'buffers': 'tabsel' },
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '│', 'right': '│' },
      \ }
if s:has('catppuccin')
  let g:lightline.colorscheme = 'catppuccin_mocha'
endif

function! EnvBranch() abort
  if !exists('*FugitiveHead') | return '' | endif
  let l:b = FugitiveHead()
  return empty(l:b) ? '' : '⎇ ' . l:b
endfunction

" Buffer "tabs" along the top (<Space>1..9 jumps to one), like VS Code editor tabs.
let g:lightline#bufferline#show_number = 2
let g:lightline#bufferline#number_separator = ' '
let g:lightline#bufferline#modified = ' ●'
let g:lightline#bufferline#unnamed = '[No Name]'
let g:lightline#bufferline#shorten_path = 1

if s:has('lightline.vim')
  set noshowmode
  if s:has('lightline-bufferline') | set showtabline=2 | endif
else
  set statusline=\ %f\ %m%r%w%=%y\ \ %l:%c\ \ %p%%\
endif

" ----------------------------------------------------------------------------
" Plugin settings
" ----------------------------------------------------------------------------
" NERDTree
let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeWinSize = 32
let g:NERDTreeIgnore = ['^\.git$', '^node_modules$', '__pycache__', '\.pyc$', '\.swp$']

" gitgutter
let g:gitgutter_sign_added = '▎'
let g:gitgutter_sign_modified = '▎'
let g:gitgutter_sign_removed = '▁'
let g:gitgutter_sign_removed_first_line = '▔'
let g:gitgutter_sign_modified_removed = '▎'

" fzf
let g:fzf_preview_window = ['right,50%', 'ctrl-/']
if has('popupwin') || has('nvim')
  let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.8, 'border': 'rounded' } }
endif

" Inline git blame at the end of the cursor line (like GitLens / VS Code):
"   Alice, 3 days ago • fix login redirect      (<Space>gB toggles it)
let g:blamer_enabled = 1
let g:blamer_delay = 300
let g:blamer_prefix = '   '
let g:blamer_relative_time = 1
let g:blamer_template = '<author>, <author-time> • <summary>'
let g:blamer_show_in_insert_modes = 0
let g:blamer_show_in_visual_modes = 0

" git-messenger: <Space>gm pops up the full commit behind the current line.
let g:git_messenger_no_default_mappings = 1
let g:git_messenger_include_diff = 'current'
let g:git_messenger_always_into_popup = 1

" Start screen: recent files in this directory, then everywhere.
let g:startify_change_to_vcs_root = 1
let g:startify_files_number = 8
let g:startify_custom_header = [
      \ '   env-settings',
      \ '   <Space>? search every key and command   <Space><Space> files   :Guide long docs',
      \ '',
      \ ]
let g:startify_lists = [
      \ { 'type': 'dir',       'header': ['   Recent in ' . getcwd()] },
      \ { 'type': 'files',     'header': ['   Recent'] },
      \ { 'type': 'commands',  'header': ['   Commands'] },
      \ ]
let g:startify_commands = [
      \ { 'f': ['Find file (fzf)', 'Files'] },
      \ { 'g': ['Search text (ripgrep)', 'Rg'] },
      \ { 'h': ['Help: search all keys', 'Keys'] },
      \ ]

" ALE: lint on save and when text stops changing; fix with :ALEFix.
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '▲'
let g:ale_virtualtext_cursor = 'current'
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_delay = 300
let g:ale_fix_on_save = 0
let g:ale_fixers = {
      \ '*': ['remove_trailing_lines', 'trim_whitespace'],
      \ 'python': ['ruff_format', 'ruff'],
      \ 'javascript': ['prettier'],
      \ 'typescript': ['prettier'],
      \ 'css': ['prettier'],
      \ 'html': ['prettier'],
      \ 'json': ['prettier'],
      \ 'sh': ['shfmt'],
      \ }

" Python syntax (from polyglot's python-syntax)
let g:python_highlight_all = 1

" ----------------------------------------------------------------------------
" Mappings
" ----------------------------------------------------------------------------
nnoremap <Space> <Nop>
xnoremap <Space> <Nop>

" --- files, buffers, search ---
nnoremap <silent> <C-t> :NERDTreeToggle<CR>
nnoremap <silent> <leader>n :NERDTreeFind<CR>
" A mapping that is a prefix of another one makes Vim wait 'timeoutlen' before
" firing it, so solo mappings avoid prefixes used elsewhere (a*, f*, d*, c*, r*, b*).
nnoremap <silent> <leader><Space> :call <SID>Files()<CR>
nnoremap <silent> <leader>ff :Files<CR>
nnoremap <silent> <leader>fg :Rg<CR>
nnoremap <silent> <leader>fl :BLines<CR>
nnoremap <silent> <leader>fh :History<CR>
nnoremap <silent> <leader>fc :Commits<CR>
nnoremap <silent> <leader>fb :BCommits<CR>
nnoremap <silent> <leader>bb :call <SID>Buffers()<CR>
nnoremap <silent> <leader>o :call <SID>Buffers()<CR>
nnoremap <leader>s :Grep<Space>
nnoremap <silent> <Esc><Esc> :nohlsearch<CR>
nnoremap <silent> <leader>e :edit<CR>

" Buffers: Tab / Shift-Tab / Q, plus unimpaired-style [b ]b.
nnoremap <silent> <Tab> :bnext<CR>
nnoremap <silent> Q :bprevious<CR>
nnoremap <silent> <S-Tab> :edit #<CR>
nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> <leader>bd :bdelete<CR>

" Buffer tabs along the top: <Space>1..9 jump to the Nth one (lightline-bufferline).
if s:has('lightline-bufferline')
  for s:i in range(1, 9)
    execute 'nmap <silent> <leader>' . s:i . ' <Plug>lightline#bufferline#go(' . s:i . ')'
  endfor
  unlet s:i
endif

" Vim tab pages are whole window layouts, not files; use them for a second
" workspace. For "one tab per file" use buffers (above).
nnoremap <silent> <leader>tn :tabnew<CR>
nnoremap <silent> <leader>tc :tabclose<CR>
nnoremap <silent> <leader>to :tabonly<CR>
nnoremap <silent> ]t :tabnext<CR>
nnoremap <silent> [t :tabprevious<CR>

" Windows
nnoremap <silent> <C-h> :wincmd h<CR>
nnoremap <silent> <C-j> :wincmd j<CR>
nnoremap <silent> <C-k> :wincmd k<CR>
nnoremap <silent> <C-l> :wincmd l<CR>
nnoremap <silent> <leader>z :ZoomToggle<CR>
nnoremap <silent> <leader>ws :call <SID>MarkWindowSwap()<CR>
nnoremap <silent> <leader>wt :call <SID>DoWindowSwap()<CR><C-w>h

" Save and quit. (<C-S> needs `stty -ixon`, which shell/rc.sh sets.)
nnoremap <silent> <C-s> :update<CR>
inoremap <silent> <C-s> <Esc>:update<CR>a
nnoremap <silent> <leader>q :qa<CR>
nnoremap <silent> <leader>R :ReloadVimrc<CR>

" Scrolling: 3 lines with <C-e>/<C-y>, 10 with <C-n>/<C-p>.
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>
nnoremap <C-n> 10<C-e>
nnoremap <C-p> 10<C-y>

" Move lines with Shift-Up / Shift-Down.
nnoremap <silent> <S-Up>   :move -2<CR>
nnoremap <silent> <S-Down> :move +1<CR>
inoremap <silent> <S-Up>   <Esc>:move -2<CR>a
inoremap <silent> <S-Down> <Esc>:move +1<CR>a
xnoremap <silent> <S-Up>   :<C-u>'<,'>move '<-2<CR>gv=gv
xnoremap <silent> <S-Down> :<C-u>'<,'>move '>+1<CR>gv=gv

" Keep the selection after indenting.
xnoremap > >gv
xnoremap < <gv

" Paste over a selection without clobbering the unnamed register.
xnoremap <leader>p "_dP

" Insert-mode shortcuts
inoremap <C-l> <Esc>
inoremap <C-a> <C-o>0
inoremap <C-e> <C-o>$
inoremap <C-j> <C-o>b
inoremap <C-k> <Esc>ea
inoremap {<CR> {<CR>}<C-o>O
inoremap (<Tab> ()<Left>

" Enter in normal mode adds a blank line below (not in quickfix / cmdline window).
nnoremap <CR> o<Esc>k

" Marks and tags
nnoremap <leader>` :<C-u>marks<CR>:normal! `
nnoremap <silent> <leader>] :call <SID>TagInSplit()<CR>

" Comments (vim-commentary): <Space>/ toggles on a line or a selection.
nmap <leader>/ gcc
xmap <leader>/ gc
nmap <leader>. gcc
xmap <leader>. gc

" Git (fugitive)
nnoremap <silent> <leader>gs :Git<CR>
nnoremap <silent> <leader>gb :Git blame<CR>
nnoremap <silent> <leader>gd :Gdiffsplit<CR>
nnoremap <silent> <leader>gB :BlamerToggle<CR>
nmap <silent> <leader>gm <Plug>(git-messenger)
nnoremap <silent> <leader>gl :Git log --oneline --follow -- %<CR>
nnoremap <silent> <leader>gL :call <SID>LineHistory()<CR>

" Misc
nnoremap <silent> <leader>u :UndotreeToggle<CR>
nnoremap <silent> <leader>0 :Keys<CR>
nnoremap <silent> <leader>? :Keys<CR>
nnoremap <silent> <leader>mp :Md<CR>

" ALE (only when installed)
if s:has('ale') && !s:nvim_ide
  nmap <silent> [e <Plug>(ale_previous_wrap)
  nmap <silent> ]e <Plug>(ale_next_wrap)
  nnoremap <silent> gd :ALEGoToDefinition<CR>
  nnoremap <silent> gr :ALEFindReferences<CR>
  nnoremap <silent> K  :ALEHover<CR>
  nnoremap <silent> <leader>rn :ALERename<CR>
  nnoremap <silent> <leader>x  :ALEFix<CR>
  " Tab completes in the popup menu.
  inoremap <expr> <C-Space> pumvisible() ? "\<C-n>" : "\<C-x>\<C-o>"
endif

" ----------------------------------------------------------------------------
" Autocommands
" ----------------------------------------------------------------------------
augroup EnvSettings
  autocmd!
  " Per-filetype indentation.
  autocmd FileType javascript setlocal shiftwidth=4 tabstop=4
  autocmd FileType html,css   setlocal shiftwidth=2 tabstop=2 indentexpr=
  autocmd FileType yaml       setlocal shiftwidth=2 tabstop=2 indentexpr=
  autocmd FileType json       setlocal shiftwidth=2 tabstop=2
  autocmd FileType make,go    setlocal noexpandtab
  autocmd FileType gitcommit  setlocal spell textwidth=72
  autocmd FileType markdown   setlocal spell

  " <CR> must keep working where it means something.
  autocmd FileType qf nnoremap <buffer> <CR> <CR>
  autocmd CmdwinEnter * nnoremap <buffer> <CR> <CR>

  " Reopen files where you left off.
  autocmd BufReadPost *
        \ if &filetype !~# 'gitcommit\|gitrebase' && line("'\"") > 1 && line("'\"") <= line('$')
        \ | execute 'normal! g`"' | endif

  " Pick up changes made by other programs.
  autocmd FocusGained,BufEnter,CursorHold * if mode() !=# 'c' | silent! checktime | endif

  " Rebalance splits when the terminal is resized.
  autocmd VimResized * wincmd =

  " Create missing parent directories when saving.
  autocmd BufWritePre * call s:MkdirP(expand('<afile>:p:h'), v:cmdbang)

  " Open the quickfix window after :grep / :make when there are results.
  autocmd QuickFixCmdPost [^l]* cwindow
  autocmd QuickFixCmdPost l*    lwindow

  " Close Vim if NERDTree is the last window.
  autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

  " Save a session when leaving Vim (restore with `vimlatest` in the shell).
  autocmd VimLeave * call s:SaveSession()
augroup END

" ----------------------------------------------------------------------------
" Functions and commands
" ----------------------------------------------------------------------------
function! s:MkdirP(dir, force) abort
  if a:dir !~# '^\w\+://' && !isdirectory(a:dir) && (a:force || confirm('Create directory ' . a:dir . '?', "&Yes\n&No", 2) == 1)
    call mkdir(a:dir, 'p')
  endif
endfunction

" fzf file finder: git files in a repo, everything otherwise.
function! s:Files() abort
  if !exists(':Files')
    echohl WarningMsg | echo 'fzf.vim is not installed (run: make vim-plugins)' | echohl None
    return
  endif
  call system('git rev-parse --is-inside-work-tree')
  if v:shell_error | Files | else | GFiles | endif
endfunction

function! s:Buffers() abort
  if exists(':Buffers') | Buffers | else | ls | call feedkeys(':buffer ') | endif
endfunction

" Open the tag under the cursor in a vertical split; undo the split on failure.
function! s:TagInSplit() abort
  let l:word = expand('<cword>')
  vsplit
  try
    execute 'tag' l:word
  catch
    close
    echohl ErrorMsg | echo matchstr(v:exception, 'E\d\+:.*') | echohl None
  endtry
endfunction

" :Grep PATTERN [args]  -> quickfix list via 'grepprg' (ripgrep when available)
command! -nargs=+ -complete=file_in_path Grep execute 'silent grep!' <q-args> | redraw!

" :Redir {command}  -> output of any command in a scratch buffer
command! -nargs=+ -complete=command Redir call s:Redir(<q-args>)
function! s:Redir(cmd) abort
  let l:out = execute(a:cmd)
  new
  setlocal buftype=nofile bufhidden=wipe noswapfile
  call setline(1, split(l:out, "\n"))
endfunction

" :Template NAME -> insert a file from templates/ at the cursor
command! -nargs=1 -complete=customlist,s:TemplateComplete Template call s:Template(<q-args>)
function! s:TemplateComplete(arglead, cmdline, cursorpos) abort
  let l:files = map(glob(s:root . '/templates/*.template', 0, 1), "fnamemodify(v:val, ':t:r')")
  return filter(l:files, 'v:val =~# "^" . a:arglead')
endfunction
function! s:Template(name) abort
  let l:file = s:root . '/templates/' . a:name . '.template'
  if !filereadable(l:file)
    echohl ErrorMsg | echo 'No such template: ' . a:name | echohl None
    return
  endif
  execute 'read' fnameescape(l:file)
endfunction

command! TrimWhitespace let s:v = winsaveview() | keeppatterns %s/\s\+$//e | call winrestview(s:v)

" Zoom the current split to fill the tab, and back.
function! s:ZoomToggle() abort
  if get(t:, 'zoomed', 0)
    execute t:zoom_winrestcmd
    let t:zoomed = 0
  else
    let t:zoom_winrestcmd = winrestcmd()
    resize
    vertical resize
    let t:zoomed = 1
  endif
endfunction
command! ZoomToggle call s:ZoomToggle()

" Swap two windows: mark one, move to the other, swap.
function! s:MarkWindowSwap() abort
  let g:marked_win = winnr()
endfunction
function! s:DoWindowSwap() abort
  if !exists('g:marked_win') | return | endif
  let l:cur_win = winnr()
  let l:cur_buf = bufnr('%')
  execute g:marked_win . 'wincmd w'
  let l:marked_buf = bufnr('%')
  execute 'hide buf' l:cur_buf
  execute l:cur_win . 'wincmd w'
  execute 'hide buf' l:marked_buf
endfunction

" Sessions: ~/.vim/sessions/<dir>/latest.session plus a dated history.
function! s:SaveSession() abort
  if len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) < 2
    return
  endif
  let l:root = s:datadir . '/sessions'
  let l:proj = l:root . '/' . fnamemodify(getcwd(), ':t')
  let l:day = l:proj . '/' . strftime('%Y-%m-%d')
  silent! call mkdir(l:day, 'p')
  execute 'mksession!' fnameescape(l:proj . '/latest.session')
  execute 'mksession!' fnameescape(l:day . '/vim.' . strftime('%H-%M-%S'))
  execute 'mksession!' fnameescape(l:root . '/latest.session')
endfunction

command! ReloadVimrc unlet! g:env_settings_loaded | source $MYVIMRC | echo 'vimrc reloaded'

function! s:ToggleLines() abort
  set number!
  set relativenumber!
endfunction

" Notes mode: continue bullet lists and numbered comments.
function! s:Notes() abort
  setlocal formatoptions=ctnqro
  setlocal comments+=n:*,n:#
endfunction
command! Notes call s:Notes()

function! s:PrettyJson() abort
  if executable('jq')
    %!jq .
  else
    %!python3 -m json.tool
  endif
endfunction

" History of just the current line (git log -L), shown by fugitive.
function! s:LineHistory() abort
  if empty(expand('%'))
    return
  endif
  execute 'Git log -L' . line('.') . ',' . line('.') . ':' . fnameescape(expand('%'))
endfunction

" :Md [file] -> render markdown in the terminal with glow (scripts/md falls back
" to bat/less when glow is missing). Defaults to the current markdown buffer,
" else README.md. q closes it. Neovim also renders inline: <Space>mr toggles.
function! s:Md(file) abort
  let l:file = a:file
  if empty(l:file)
    let l:file = &filetype ==# 'markdown' ? expand('%:p') : (filereadable('README.md') ? 'README.md' : '')
  endif
  if empty(l:file)
    echohl ErrorMsg | echo 'Md: no file given and no README.md here' | echohl None
    return
  endif
  let l:cmd = [s:root . '/scripts/md', l:file]
  if has('nvim')
    tabnew
    let l:buf = bufnr('%')
    let l:opts = { 'on_exit': {-> execute('silent! bdelete! ' . l:buf)} }
    if has('nvim-0.11')
      call jobstart(l:cmd, extend(l:opts, { 'term': v:true }))
    else
      call termopen(l:cmd, l:opts)
    endif
    startinsert
  else
    execute 'tab terminal ++close' join(map(copy(l:cmd), 'shellescape(v:val)'), ' ')
  endif
endfunction
command! -nargs=? -complete=file Md call s:Md(<q-args>)
command! Guide call s:Md(s:root . '/docs/WORKFLOW.md')

" Claude Code in a terminal split. Neovim with claudecode.nvim gets the full
" IDE integration (:ClaudeCode, see nvim/ide.lua); this is the plain Vim fallback.
function! s:Claude(args) abort
  if !executable('claude')
    echohl ErrorMsg | echo 'claude CLI not found (run: make claude)' | echohl None
    return
  endif
  let l:cmd = 'claude' . (empty(a:args) ? '' : ' ' . a:args)
  if has('nvim')
    execute 'vertical botright new | terminal' l:cmd
    startinsert
  else
    execute 'vertical botright terminal ++close' l:cmd
  endif
endfunction
command! -nargs=* Claude call s:Claude(<q-args>)
if !s:nvim_ide
  command! -nargs=* ClaudeCode Claude <args>
  nnoremap <silent> <leader>ac :Claude<CR>
  nnoremap <silent> <leader>ar :Claude --resume<CR>
  nnoremap <silent> <leader>aC :Claude --continue<CR>
endif

" ----------------------------------------------------------------------------
" Help palette  (<Space>? or :Keys): every key, command and how-to, fuzzy searchable
"
" Reads help/help.tsv, the same file behind `h` in the shell and Alt-a ? in tmux,
" so there is one place to keep help up to date. Enter runs the entry when it
" is a Vim command, otherwise shows its details.
" ----------------------------------------------------------------------------
let s:help_file = s:root . '/help/help.tsv'

function! s:HelpRows(layers) abort
  let l:rows = []
  if !filereadable(s:help_file) | return l:rows | endif
  for l:line in readfile(s:help_file)
    if empty(l:line) || l:line[0] ==# '#' | continue | endif
    let l:f = split(l:line, "\t", 1)
    if len(l:f) < 6 | continue | endif
    if !empty(a:layers) && index(a:layers, l:f[0]) < 0 | continue | endif
    call add(l:rows, { 'layer': l:f[0], 'keys': l:f[1], 'title': l:f[2], 'action': l:f[3],
          \ 'details': substitute(join(l:f[5:], ' '), '\\n', "\n", 'g') })
  endfor
  return l:rows
endfunction

function! s:Keys(query) abort
  let s:help_rows = s:HelpRows([])
  if empty(s:help_rows)
    echohl ErrorMsg | echo 'help/help.tsv not found' | echohl None
    return
  endif
  if !exists('*fzf#run')
    call s:Cheatsheet()
    return
  endif
  let l:lines = map(copy(s:help_rows), {i, r -> printf("%d\t%-6s %-24s %s", i + 1, r.layer, r.keys, r.title)})
  call fzf#run(fzf#wrap({
        \ 'source': l:lines,
        \ 'sink': function('s:KeysRun'),
        \ 'options': ['--delimiter', "\t", '--with-nth', '2..', '--prompt', 'help> ', '--no-multi',
        \   '--query', a:query, '--preview-window', 'right,55%,wrap',
        \   '--preview', shellescape(s:root . '/scripts/h') . ' --card {1}'],
        \ }))
endfunction

function! s:KeysRun(line) abort
  let l:idx = str2nr(matchstr(a:line, '^\d\+')) - 1
  if l:idx < 0 || l:idx >= len(s:help_rows) | return | endif
  let l:row = s:help_rows[l:idx]
  if l:row.action =~# '^ex:'
    try
      execute l:row.action[3:]
    catch
      echohl ErrorMsg | echo matchstr(v:exception, 'E\d\+:.*') | echohl None
    endtry
  else
    if l:row.action =~# '^sh:'
      let @" = l:row.action[3:]
    endif
    call s:ShowCard(l:row)
  endif
endfunction

" Details of one entry in a small split. q closes it.
function! s:ShowCard(row) abort
  let l:lines = [a:row.title . '   [' . a:row.layer . ']', a:row.keys, '']
        \ + split(a:row.details, "\n", 1)
  if a:row.action =~# '^sh:'
    call extend(l:lines, ['', 'Run in the shell:  ' . a:row.action[3:] . '   (copied to the unnamed register)'])
  endif
  botright new
  setlocal buftype=nofile bufhidden=wipe noswapfile nonumber norelativenumber nolist nowrap
  call setline(1, l:lines)
  execute 'resize' min([len(l:lines) + 1, 16])
  setlocal nomodifiable
  nnoremap <buffer> <silent> q :close<CR>
endfunction

" One-page list of every Vim/Claude key, generated from the same file.
function! s:Cheatsheet() abort
  let l:lines = ['env-settings key reference   (leader = Space, q closes)', '']
  for l:layer in ['vim', 'nvim', 'claude']
    let l:rows = s:HelpRows([l:layer])
    if empty(l:rows) | continue | endif
    call add(l:lines, toupper(l:layer) . (l:layer ==# 'nvim' ? '  (Neovim only)' : ''))
    for l:r in l:rows
      call add(l:lines, printf('  %-28s %s', l:r.keys, l:r.title))
    endfor
    call add(l:lines, '')
  endfor
  new
  setlocal buftype=nofile bufhidden=wipe noswapfile nonumber norelativenumber nolist nowrap
  call setline(1, l:lines)
  setlocal nomodifiable
  nnoremap <buffer> <silent> q :close<CR>
endfunction

command! -nargs=? Keys call s:Keys(<q-args>)
command! -nargs=? Menu call s:Keys(<q-args>)
command! Cheatsheet call s:Cheatsheet()

" ----------------------------------------------------------------------------
" Local overrides
" ----------------------------------------------------------------------------
if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
endif
