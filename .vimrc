" Default command to make sure vim does not behave like vi
set nocompatible

"Search for cpp or use default, some languages need to be added (like typescript)
syntax enable

filetype plugin on

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


"  FINDING FILES:
set path+=**
set wildmenu

" TAG JUMPING
" command! MakeTags !ctags -R .
command! MakeTags !/usr/local/bin/ctags -R .
