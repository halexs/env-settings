" Default command to make sure vim does not behave like vi
set nocompatible
" List of plugins... currently none
" Plugin 'Chiel92/vim-autoformat'


"nnoremap <SPACE> <Nop>
"let mapleader=" "
map <SPACE> <leader>

inoremap jk <ESC>
inoremap kj <ESC>

nmap <silent> <leader>wt :call MarkWindowSwap()<CR>
nmap <silent> <leader>ws :call DoWindowSwap()<CR><C-w>h

" Buffers
noremap <leader>j :bn<cr>
noremap <leader>k :bp<cr>
noremap <leader>d :bd<cr> 

" Tabs though this may not be necessary since gt and gT switches
noremap <leader>l :tabn<CR>
noremap <leader>h :tabp<CR>
noremap <leader>t1 :tabn 1<CR>
noremap <leader>t2 :tabn 2<CR>
noremap <leader>t3 :tabn 3<CR>
noremap <leader>t4 :tabn 4<CR>
noremap <leader>t5 :tabn 5<CR>
noremap <leader>t5 :tabn 6<CR>
noremap <leader>t0 :tablast<CR>

" Use ctrl-[elect the active split!
nmap <silent> <c-k> :wincmd k<CR>
nmap <silent> <c-j> :wincmd j<CR>
nmap <silent> <c-h> :wincmd h<CR>
nmap <silent> <c-l> :wincmd l<CR>



function! NetrwMapping()
  noremap <buffer> <C-v> :call OpenToRight()<CR>
  noremap <buffer> <C-h> :call OpenBelow()<CR>
endfunction


" SNIPPETS
" Read in and create a python main function
nnoremap \python-main :read $HOME/env-settings/templates/python-main.template<CR>o<Tab>
" Toggles netrw on the left side. Opens by default, toggle with
" ctrl-e
noremap <silent> <C-E> :call ToggleNetrw()<CR>

"noremap xq <ESC>
"nnoremap tq :rightbelow 20vs<CR>:e .<CR><C-w>r<CR>

" tab key mapping. Does not work well in netrw, since `t` creates file in new
" tab
" noremap <C-p> :tabp<cr>
" noremap <C-n> :tabn<cr>
" noremap tn :tabn<CR>
" noremap tp :tabp<CR>
" noremap th :tabn 1<CR>
" noremap t2 :tabn 2<CR>
" noremap t3 :tabn 3<CR>
" noremap t4 :tabn 4<CR>
" noremap t5 :tabn 5<CR>
" noremap t6 :tabn 6<CR>
" noremap tt :tablast<CR>

" Highlight column 80
set cc=80
highlight ColorColumn guibg=lightgrey ctermbg=lightgrey

" Search for cpp or use default
syntax enable

set mouse=a

set pastetoggle=<F10>

filetype plugin on

" built in plugins for doing stuff
set path+=**
set wildmenu
set wildignore+=**/node_modules/**

" TAG JUMPING
" command! MakeTags !ctags -R .
command! MakeTags !/usr/local/bin/ctags -R .

" FILE BROWSING
"let g:netrw_banner=0        " disable banner
let g:netrw_browse_split=4  " open in prior window
let g:netrw_altv=1          " open splits to the right
let g:netrw_liststyle=3      " tree view
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'

" THIS ALLOWS:
" - :edit a folder to open file browser
"   <CR>/v/t to open in an h-split/v-split/tab
"   check |netrw-browse-maps| for more mappings

set expandtab

"Line Numbers
set number
set relativenumber

"Tab Space
set ts=4

"Shift Space
set sw=4

"Wrapping
set wrap

"Auto Indent
set ai

"Always Show cmd
set showcmd

"Underline Current Cursor Line
set cursorline
"set ruler

"Show Graphical Menu
set wildmenu

"Matching Brackets
set showmatch

"Tenth of a second to blink when matching brackets
set mat=2

"Search as characters are entered
set incsearch

"highlight search matches
set hlsearch

"Set ignore Case when Searching
set ignorecase

"Smart Casing when searching
set smartcase

"Always show status line
set laststatus=2

"set background=dark

set hidden

" functions

function! OpenToRight()
  :normal v
  let g:path=expand('%:p')
  :q!
  execute 'belowright vnew' g:path
  :normal <C-l>
endfunction

function! OpenBelow()
  :normal v
  let g:path=expand('%:p')
  :q!
  execute 'belowright new' g:path
  :normal <C-l>
endfunction

let g:NetrwIsOpen=0

function! ToggleNetrw()
  if g:NetrwIsOpen
    let i = bufnr("$")
    while (i >= 1)
      if (getbufvar(i, "&filetype") == "netrw")
        silent exe "bwipeout " . i
      endif
      let i-=1
    endwhile
    let g:NetrwIsOpen=0
  else
    let g:NetrwIsOpen=1
    silent Lexplore
    vertical resize 30
  endif
endfunction

"fun! ProjectDrawer()
"  if &ft ==# "netrw"
"    call ToggleNetrw()
"  endif
"endfun

"augroup ProjectDrawer
"  autocmd!
"  autocmd VimEnter * :call ToggleNetrw()
"augroup END

augroup netrw_mapping
  autocmd!
  autocmd filetype netrw call NetrwMapping()
  "autocmd filetype netrw call ToggleNetrw()
  "autocmd VimEnter * :call ProjectDrawer()
  "autocmd VimEnter * :call ToggleNetrw()
augroup END

function! MarkWindowSwap()
    let g:markedWinNum = winnr()
endfunction

function! DoWindowSwap()
    "Mark destination
    let curNum = winnr()
    let curBuf = bufnr( "%" )
    exe g:markedWinNum . "wincmd w"
    "Switch to source and shuffle dest->source
    let markedBuf = bufnr( "%" )
    "Hide and open so that we aren't prompted and keep history
    exe 'hide buf' curBuf
    "Switch to dest and shuffle source->dest
    exe curNum . "wincmd w"
    "Hide and open so that we aren't prompted and keep history
    exe 'hide buf' markedBuf 
endfunction



