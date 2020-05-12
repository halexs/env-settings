" Default command to make sure vim does not behave like vi
set nocompatible


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

inoremap jk <ESC>
inoremap kj <ESC>
"noremap xq <ESC>
"nnoremap tq :rightbelow 20vs<CR>:e .<CR><C-w>r<CR>

" tab key mapping. Does not work well in netrw, since `t` creates file in new
" tab
noremap <C-p> :tabp<cr>
noremap <C-n> :tabn<cr>
noremap tn :tabn<CR>
noremap tp :tabp<CR>
noremap th :tabn 1<CR>
noremap t2 :tabn 2<CR>
noremap t3 :tabn 3<CR>
noremap t4 :tabn 4<CR>
noremap t5 :tabn 5<CR>
noremap t6 :tabn 6<CR>
noremap tt :tablast<CR>

"Search for cpp or use default
syntax enable

set mouse=a

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

augroup ProjectDrawer
  autocmd!
  autocmd VimEnter * :call ToggleNetrw()
augroup END

augroup netrw_mapping
    autocmd!
    autocmd filetype netrw call NetrwMapping()
augroup END

