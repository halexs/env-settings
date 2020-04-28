" Default command to make sure vim does not behave like vi
set nocompatible

"Search for cpp or use default
syntax enable

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

" SNIPPETS
" Read in and create a python main function
nnoremap \python-main :read $HOME/.vim/templates/.python-main.template<CR>o<Tab>

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


