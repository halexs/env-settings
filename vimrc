" plugins
" TODO: separate plugins into a plugins_rc file instead of this file.

set nocompatible
filetype off
" set the runtime path to include Vundle and initialize
"
" To run plugins, run :source %, then refresh the file.
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Nerdtree to replace netrw. Functionality is about the same, but a lot of
" things are more transparent, like how to create/move/delete files. The
" biggest change I like is shifting the 'working directory'. I was never able
" to get that working on netrw. Bookmarks are also nice.
Plugin 'preservim/nerdtree' | 
			\ Plugin 'Xuyuanp/nerdtree-git-plugin'

" Git integration to see if a line was added/changed/deleted.
" Try using git fugitive to make merge conflicts easier for vim.
" Try using both. There shouldn't be any conflicts.
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-fugitive'
" Maps autocomplete to Tab, along with more functionality.
Plugin 'ackyshake/VimCompletesMe'

" Replaces vim's default file find throughout a project. First plugin installs
" (and compiles I think) the fzf tool, while the second integrates the tool
" with vim.
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'

" Colors the bottom
" Plugin 'itchyny/lightline.vim'

" Updates python syntax with features such as f-strings.
Plugin 'vim-python/python-syntax'


" All of your Plugins must be added before the following line
call vundle#end()            " required

filetype plugin indent on    " required

" Status line (bottom) configurations
set laststatus=2
" set statusline+=%{StatuslineGit()}

" Colors here: https://jonasjacek.github.io/colors/
" More usefule statusline: 
" https://stackoverflow.com/questions/5375240/a-more-useful-statusline-in-vim
hi NormalColor ctermbg=155 ctermfg=27 
hi InsertColor ctermbg=189 ctermfg=27 
hi ReplaceColor ctermbg=165 ctermfg=0 
hi VisualColor ctermbg=darkgrey ctermfg=lightgrey
" hi NormalColor ctermbg=155 ctermfg=27 guifg=Black guibg=Green
" hi InsertColor ctermbg=189 ctermfg=27 guifg=Black guibg=Green
" hi ReplaceColor ctermbg=165 ctermfg=0 guifg=Black guibg=Green
" hi VisualColor ctermbg=grey ctermfg=0 guifg=Black guibg=Green

set statusline=
" Change color based on mode.
set statusline+=%#NormalColor#%{(mode()=='n')?'\ \ NORMAL\ ':''}
set statusline+=%#InsertColor#%{(mode()=='i')?'\ \ INSERT\ ':''}
set statusline+=%#ReplaceColor#%{(mode()=='R')?'\ \ REPLACE\ ':''}
set statusline+=%#VisualColor#%{(mode()=='v')?'\ \ VISUAL\ ':''}
" "buffernr
" " set statusline+=\[%n]
" "Modified? Readonly? Top/bot.
set statusline+=\ %m%r%w
" display git branch without-plugin causing slow vim updates.
" set statusline+=%{StatuslineGit()}\ \|
" This requires fugitive vim plugin
set statusline+=\ %{fugitive#head()}\ \|

"File+path
set statusline+=\ %<%f\ \|

" Dividing line, above is left, below is right.
set statusline+=\ %=

"FileType
set statusline+=\ %y\ \|
"Rownumber/total (%)
set statusline+=\ row:%l/%L\ (%03p%%)\ \|
"Colnr
set statusline+=\ col:%03c

set shortmess-=S

" My leader key is space.
map <SPACE> <leader>
" " Search for cpp or use default
syntax enable
" 
set mouse=a

" Allows mac to copy and paste through vim and clipboard
set clipboard=unnamed

" "Line Numbers
set number
set relativenumber

" NERDTree plugin information
" nnoremap <leader>n :NERDTreeFocus<CR>
" nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <leader>n :NERDTreeFind<CR>
let NERDTreeShowHidden=1
" Allows nerdtree to create/add/remove files.
set modifiable

" Start NERDTree and leave the cursor in it.
" autocmd VimEnter * NERDTree
" Start NERDTree and put the cursor back in the other window.
" autocmd VimEnter * NERDTree | wincmd p
" Exit Vim if NERDTree is the only window left.
" autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Vim git gutter information, try using fugitive vim now.

" vim gitgutter plugin update time
set updatetime=100
" highlight GitGutterAdd ctermfg=green guifg=green ctermbg=blue
highlight clear SignColumn
highlight GitGutterAdd ctermfg=darkgrey ctermbg=green 
highlight GitGutterChange ctermfg=darkgrey ctermbg=yellow
highlight GitGutterDelete ctermfg=darkgrey ctermbg=red
" highlight GitGutterDelete ctermfg=black ctermbg=red
highlight GitGutterChangeDelete ctermfg=darkgrey ctermbg=yellow

" let g:gitgutter_highlight_lines = 1
" highlight SignColumn guibg=lightgrey
" highlight SignColumn guibg=blackdfasdfdsfadf
" highlight DiffAdd guibg=green
" highlight DiffAdd ctermbg=green
" highlight DiffChange ctermbg=47
" highlight link GitGutterDeleteLine DiffAdd
" highlight GitGutterAdd guifg=#bbbb00 ctermfg=3
" highlight GitGutterAddLine guifg=darkgrey
" highlight link GitGutterAddLine DiffDelete
" highlight link GitGutterAddLine DiffDelete
" highlight SignColumn guibg=darkgrey

" remap file save, file save+quit, and quit-all
inoremap <C-S> <ESC>:update<CR>a
nnoremap <C-S> :update<CR>
nnoremap <C-x> :x<CR>
nnoremap <C-q> :q<CR>
nnoremap <leader>q :qa<CR>

nnoremap <leader>r :source ~/.vimrc<CR>
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>
"nnoremap <leader>] 10<C-e>
"nnoremap <leader>[ 10<C-y>
" nnoremap <C-j> 10<C-e>
" nnoremap <C-k> 10<C-y>
nnoremap <C-n> 10<C-e>
nnoremap <C-m> 10<C-y>

inoremap <C-l> <ESC>

" Buffers
" nnoremap <C-i> :bn<cr>
" nnoremap <C-o> :bp<cr>
nnoremap <C-d> :bd<cr> 
nnoremap <leader>b :ls<cr>
nnoremap <leader>o :buffers<CR>:b 
"nnoremap <leader>o :buffers<CR>:b

" nnoremap <leader>l :ls<cr>

" Tabs though this may not be necessary since gt and gT switches
" nnoremap <C-u> :tabn<CR>
" nnoremap <C-p> :tabp<CR>

" Use ctrl-[select] the active split!
noremap <silent> <C-k> :wincmd k<CR>
noremap <silent> <C-j> :wincmd j<CR>
noremap <silent> <C-h> :wincmd h<CR>
noremap <silent> <C-l> :wincmd l<CR>
" inoremap <C-k> <C-o>:wincmd k<CR>
" inoremap <C-j> <C-o>:wincmd j<CR>
" inoremap <C-h> <C-o>:wincmd h<CR>
" inoremap <C-l> <C-o>:wincmd l<CR>


"Tab Space
set ts=4
" set ts=2

set expandtab
" Highlight column 80 to unsure lines don't go too long.
set cc=80
highlight ColorColumn ctermbg=white
" highlight ColorColumn guibg=lightgrey ctermbg=lightgrey

" " These commands customize built-in find to make vim search through the
" whole project structure. Unfortunately even if files matched 'ignores'
" node_modules, the searching takes a long time to complete still, leading me
" to believe it's still searching through those files. 
" " replaced with fzf.vim plugin instead.
" set path+=**
" set wildmenu
" "set wildignore+=**/node_modules/**
set wildignore+=**/node_modules/**
" set wildmode=longest,list,full

" Maps fzf plugin to ctrl-a, searches through all NON-gitignore files.
" nnoremap <C-;> :GFiles<CR>
" To search through normal files, do :Files
nnoremap <C-a> :GFiles<CR>
" map <C-a> :Files<CR>

" If splits exists, this will have the split take up the whole page.
nnoremap <silent> <leader>f :ZoomToggle<CR>

"Set ignore Case when Searching with /
set ignorecase
" 
" Smart Casing when searching. This will ignore ignorecase if capital letters
" are specified
set smartcase

" Visual line color. In black background and grey text, cannot see.
" hi Visual  guifg=blue guibg=blue gui=none
hi Visual ctermfg=darkgrey ctermbg=lightblue
" highlight GitGutterDelete ctermfg=black ctermbg=red

" Example of searching/grepping through files and opening in vim.
" :grep bar **/*.py | copen

" "Wrapping
set wrap
" 
"Auto Indent. The following 2 go together.
set ai
set smartindent
" 
" Always Show cmd
set showcmd
" 
" "Underline Current Cursor Line
set cursorline
" "set ruler
" 
" "Show Graphical Menu
" set wildmenu
" 
" "Matching Brackets
set showmatch
" 
"Tenth of a second to blink when matching brackets
set mat=2
" 
"Search as characters are entered
set incsearch
" 
"highlight search matches
set hlsearch
" This will clear the hlsearch
" nnoremap <silent> <C-c> :noh<return><esc>
nnoremap <silent> <leader>c :noh<return><esc>
" 
" 
" "Always show status line
set laststatus=2
" 
" "set background=dark
" 
" Allows to switch buffers even if not written too (which is vim default)
set hidden

" Remap Q to quit
nnoremap Q :q<CR>

" Navigate buffers using tab and shift-tab.
nnoremap <Tab> :bn<CR>
" nnoremap <S-Tab> :bp<CR>
nnoremap <S-Tab> :call MoveBack()<CR>

" Turn on python plugin syntax highlighting
let g:python_highlight_all = 1

" Move lines up and down with shift arrowkey
nnoremap <S-Up> :m-2<CR>
nnoremap <S-Down> :m+<CR>
inoremap <S-Up> <Esc>:m-2<CR>
inoremap <S-Down> <Esc>:m+<CR>

" move selected lines up one line
xnoremap <S-Up>  :m-2<CR>gv=gv

" move selected lines down one line
xnoremap <S-Down> :m'>+<CR>gv=gv

" keep undo history
set undofile                " Save undos after file closes
set undodir=$HOME/.vim/undo " where to save undo histories
set undolevels=1000         " How many undos
set undoreload=10000        " number of lines to save for undo


" command! -nargs=* Xyz :call GrepSearch(<q-args>)

nnoremap <leader>s :call GrepSearch("", "")<left><left><left><left><left><left>
" nnoremap <leader>f :call GrepSearch()<left>
" nnoremap <leader>f :vim  **/* | copen<left><left><left><left><left><left><left><left><left><left><left><left><left>

" pretty print json file.
" nnoremap \jsonpretty execute '%!python -m json.tool' | w 
nnoremap \json-pretty :%!python -m json.tool

" scrolloff to keep the cursor in the center. Try it by default, or move to
" function. Now change it to show at least 10 lines.
" set scrolloff=999
set scrolloff=10

"vim functions

" These do the job, but for some reason causes vim to slow down. Currently
" using fugitive vim instead.
function! GitBranch()
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatuslineGit()
  let l:branchname = GitBranch()
  return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction

" Allows switching between 2 buffers. Called with Shift-Tab
function! MoveBack()
     edit #
endfunction

" Self created function to make grep searching easier.
function! GrepSearch(searchtext, extensionflag) " This is like *args in python, max is 20 args
    " a:0 contains an integer which is the number of arguments passed to the function
    " echom a:0 
    " a:1 contains the first argument passed, a:2 contains the second and so on
    " echom a:1 
    " a:000 contains a list of all arguments that were passed to the function
    " echo a:000 
    " full command:
    " grep/vim [searchtext] **/*[optional filetype] | copen
    " echom a:searchtext
    " echom a:extension
    if len(a:extensionflag) == 0
        let extension = "**/*"
        let found_extension = expand('%:e')
        " echo found_extension
        if len(found_extension) != 0
            let extension = "**/*." . found_extension
        endif
    elseif a:extensionflag == "all"
        let extension = "**/*"
    else
        let extension = "**/*." . a:extensionflag
    endif

    " let file_name = expand('%:t:r')
    " echo expand('%:e')
    let searchcommand = "vim " . a:searchtext . " " . extension . " | copen"
    echom searchcommand
    execute searchcommand
    " echom "vim ".a:searchtext." ".a:extension." | copen"
    " execute "vim ".a:searchtext." ".a:extension." | copen"
    " vim a:searchtext **/* | copen
    " vim a:searchtext a:extension | copen
endfunction

" Zoom / Restore window.
function! s:ZoomToggle() abort
    if exists('t:zoomed') && t:zoomed
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

" function! Lines()
"   set number!
"   set relativenumber!
" endfunction
" 
" function! Notes()
"   setlocal formatoptions=ctnqro
"   setlocal comments+=n:*,n:#
" endfunction




" inoremap <tab> <c-r>=Smart_TabComplete()<CR>
" function! Smart_TabComplete()
"   let line = getline('.')                         " current line
" 
"   let substr = strpart(line, -1, col('.')+1)      " from the start of the current
"                                                   " line to one character right
"                                                   " of the cursor
"   let substr = matchstr(substr, "[^ \t]*$")       " word till cursor
"   if (strlen(substr)==0)                          " nothing to match on empty string
"     return "\<tab>"
"   endif
"   let has_period = match(substr, '\.') != -1      " position of period, if any
"   let has_slash = match(substr, '\/') != -1       " position of slash, if any
"   if (!has_period && !has_slash)
"     return "\<C-X>\<C-P>"                         " existing text matching
"   elseif ( has_slash )
"     return "\<C-X>\<C-F>"                         " file matching
"   else
"     return "\<C-X>\<C-O>"                         " plugin matching
"   endif
" endfunction



" 
" 
" 
" 
" 
" 
" 
" " Default command to make sure vim does not behave like vi
" set tabstop=2
" 
" 
" " mf files, ma, then `argdo open` to open in buffers. How to automate?
" 
" 
" " SNIPPETS
" " Read in and create a python main function
" nnoremap \python-main :read $ENVSETTINGS/templates/python-main.template<CR>o<Tab>
" nnoremap \html-main :read $ENVSETTINGS/templates/html-main.template<CR>
" " For local replace
" nnoremap gr gd[{V%::s/<C-R>///gc<left><left><left>
" 
" " For global replace
" " nnoremap gR gD:%s/<C-R>///gc<left><left><left>
" 
" " set pastetoggle=<leader>9
" " set pastetoggle=<F10>
" " noremap <leader>9 :set pastetoggle<CR>
" 
" noremap <leader>5 :call Lines()<CR>
" noremap <leader>6 :call Notes()<CR>
" noremap <leader>7 :set smartindent!<CR>
" noremap <leader>8 :noh<CR>
" noremap <leader>9 :set paste!<CR>
" 
" noremap <CR> o<Esc>k
" inoremap <C-e> <C-o>$
" inoremap <C-a> <C-o>0
" 
" 
" " nnoremap <leader>s :w<CR>
" " nnoremap <leader>x :x<CR>
" nnoremap <leader>q :qa<CR>
" " nnoremap <leader>qa :qa<CR>
" 
" inoremap {<CR> {<CR>}<C-o><S-o>
" " inoremap {<Tab> {}<Left>
" " inoremap [<Tab> []<Left>
" " inoremap (<Tab> ()<Left>
" " inoremap '<Tab> ''<Left>
" " inoremap \"<Tab> \""<Left>
" " inoremap :<CR> :<CR><Tab>
" "nnoremap <SPACE> <Nop>
" "let mapleader=" "
" 
" "inoremap jk <ESC>
" "inoremap kj <ESC>
" " inoremap ;<space> <ESC>
" " inoremap <Space>; <ESC>
" " inoremap '/ <ESC>
" nmap <silent> <leader>ws :call MarkWindowSwap()<CR>
" nmap <silent> <leader>wt :call DoWindowSwap()<CR><C-w>h
" 
" noremap <leader>e :call ToggleNetrw()<CR>
" 
" 
" 
" function! NetrwMapping()
"   noremap <buffer> <C-v> :call OpenToRight()<CR>
"   noremap <buffer> <C-h> :call OpenBelow()<CR>
" "  set number
" "  set relativenumber
" "  noremap <leader>j :bn<cr>
" "  noremap <leader>k :bp<cr>
" "  noremap <leader>d :bd<cr> 
" "  noremap <leader>l :tabn<CR>
" "  noremap <leader>h :tabp<CR>
" "  noremap <c-k> :wincmd k<CR>
" "  noremap <c-j> :wincmd j<CR>
" "  noremap <c-h> :wincmd h<CR>
" "  noremap <c-l> :wincmd l<CR>
" endfunction
" 
" 
" "noremap xq <ESC>
" "nnoremap tq :rightbelow 20vs<CR>:e .<CR><C-w>r<CR>
" 
" " tab key mapping. Does not work well in netrw, since `t` creates file in new
" " tab
" " noremap <C-p> :tabp<cr>
" " noremap <C-n> :tabn<cr>
" " noremap tn :tabn<CR>
" " noremap tp :tabp<CR>
" " noremap th :tabn 1<CR>
" " noremap t2 :tabn 2<CR>
" " noremap t3 :tabn 3<CR>
" " noremap t4 :tabn 4<CR>
" " noremap t5 :tabn 5<CR>
" " noremap t6 :tabn 6<CR>
" " noremap tt :tablast<CR>
" 
" " Toggles netrw on the left side. Opens by default, toggle with
" " ctrl-e
" 
" " nnoremap <leader>ch vat:s/^\(.*\)$/<!-- \1 -->/
" " <html>
" "  help world
" " </html>
" 
" " macros
" "let @c = 'vat:s/^\(.*\)$/<!-- \1 -->/:noh'
" 
" set nocompatible
" " List of plugins... currently none
" " Plugin 'Chiel92/vim-autoformat'
" 
" 
"Shift Space
"set shiftwidth=4
set shiftwidth=4
" 
" 
" " set pastetoggle=<F10>
" " set pastetoggle=<M-p>
" 
" filetype plugin on
" 
" 
" " TAG JUMPING
" " command! MakeTags !ctags -R .
" command! MakeTags !/usr/local/bin/ctags -R .
" 
" " FILE BROWSING
" "let g:netrw_banner=0        " disable banner
" "let g:netrw_browse_split=4  " open in prior window
" let g:netrw_altv=1          " open splits to the right
" let g:netrw_liststyle=3      " tree view
" let g:netrw_list_hide=netrw_gitignore#Hide()
" let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'
" let g:netrw_bufsettings = 'noma nomod nu nobl nowrap ro'
" 
" " THIS ALLOWS:
" " - :edit a folder to open file browser
" "   <CR>/v/t to open in an h-split/v-split/tab
" "   check |netrw-browse-maps| for more mappings
" 
" 
" " functions
" 
" function! OpenToRight()
"   :normal v
"   let g:path=expand('%:p')
"   :q!
"   execute 'belowright vnew' g:path
"   :normal <C-l>
" endfunction
" 
" function! OpenBelow()
"   :normal v
"   let g:path=expand('%:p')
"   :q!
"   execute 'belowright new' g:path
"   :normal <C-l>
" endfunction
" 
" let g:NetrwIsOpen=0
" 
" function! ToggleNetrw()
"   silent Lexplore
"   vertical resize 30
"   "if g:NetrwIsOpen
"   "  let i = bufnr("$")
"   "  while (i >= 1)
"   "    if (getbufvar(i, "&filetype") == "netrw")
"   "      silent exe "bwipeout " . i
"   "    endif
"   "    let i-=1
"   "  endwhile
"   "  let g:NetrwIsOpen=0
"   "else
"   "  let g:NetrwIsOpen=1
"   "  silent Lexplore
"   "  vertical resize 30
"   "endif
" endfunction
" 
" "fun! ProjectDrawer()
" "  if &ft ==# "netrw"
" "    call ToggleNetrw()
" "  endif
" "endfun
" 
" "augroup ProjectDrawer
" "  autocmd!
" "  autocmd VimEnter * :call ToggleNetrw()
" "augroup END
" 
" augroup netrw_mapping
"   autocmd!
"   autocmd filetype netrw call NetrwMapping()
"   "autocmd filetype netrw call ToggleNetrw()
"   "autocmd VimEnter * :call ProjectDrawer()
"   "autocmd VimEnter * :call ToggleNetrw()
" augroup END
" 
" function! MarkWindowSwap()
"   let g:markedWinNum = winnr()
" endfunction
" 
" function! DoWindowSwap()
"     "Mark destination
"     let curNum = winnr()
"     let curBuf = bufnr( "%" )
"     exe g:markedWinNum . "wincmd w"
"     "Switch to source and shuffle dest->source
"     let markedBuf = bufnr( "%" )
"     "Hide and open so that we aren't prompted and keep history
"     exe 'hide buf' curBuf
"     "Switch to dest and shuffle source->dest
"     exe curNum . "wincmd w"
"     "Hide and open so that we aren't prompted and keep history
"     exe 'hide buf' markedBuf 
" endfunction
" 
" 
" 
" " Buffers
" nnoremap <leader>i :bn<cr>
" nnoremap <leader>o :bp<cr>
" nnoremap <leader>d :bd<cr> 
" " nnoremap <leader>l :ls<cr>
" 
" " Tabs though this may not be necessary since gt and gT switches
" nnoremap <leader>u :tabn<CR>
" nnoremap <leader>p :tabp<CR>
" " nnoremap <leader>t1 :tabn 1<CR>
" " nnoremap <leader>t2 :tabn 2<CR>
" " nnoremap <leader>t3 :tabn 3<CR>
" " nnoremap <leader>t4 :tabn 4<CR>
" " nnoremap <leader>t5 :tabn 5<CR>
" " nnoremap <leader>t5 :tabn 6<CR>
" " nnoremap <leader>t0 :tablast<CR>
" 
" " Use ctrl-[select] the active split!
" "noremap <c-k> :wincmd k<CR>
" "noremap <c-j> :wincmd j<CR>
" "noremap <c-h> :wincmd h<CR>
" "noremap <c-l> :wincmd l<CR>
" noremap <silent> <leader>k :wincmd k<CR>
" noremap <silent> <leader>j :wincmd j<CR>
" noremap <silent> <leader>h :wincmd h<CR>
" noremap <silent> <leader>l :wincmd l<CR>
" " inoremap <C-k> <C-o>:wincmd k<CR>
" " inoremap <C-j> <C-o>:wincmd j<CR>
" " inoremap <C-h> <C-o>:wincmd h<CR>
" " inoremap <C-l> <C-o>:wincmd l<CR>




