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

" My leader key is space.
map <SPACE> <leader>

" Status line (bottom) configurations
 set laststatus=2
" set statusline+=%{StatuslineGit()}

" Colors here: https://jonasjacek.github.io/colors/
" More useful statusline: 
" https://stackoverflow.com/questions/5375240/a-more-useful-statusline-in-vim
hi NormalColor ctermbg=155 ctermfg=27 
hi InsertColor ctermbg=189 ctermfg=27 
hi ReplaceColor ctermbg=165 ctermfg=0 
hi VisualColor ctermbg=darkgrey ctermfg=lightgrey

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


" Generic Plugin configurations

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

" Vim git gutter information, using both fugitive and git gutter
" vim gitgutter plugin update time
set updatetime=100
highlight clear SignColumn
highlight GitGutterAdd ctermfg=darkgrey ctermbg=green 
highlight GitGutterChange ctermfg=darkgrey ctermbg=yellow
highlight GitGutterDelete ctermfg=darkgrey ctermbg=red
highlight GitGutterChangeDelete ctermfg=darkgrey ctermbg=yellow

" Maps fzf plugin to ctrl-a, searches through all NON-gitignore files.
" nnoremap <C-;> :GFiles<CR>
" To search through normal files, do :Files
nnoremap <C-a> :GFiles<CR>
" map <C-a> :Files<CR>


" vim code help

" " SNIPPETS
" " Read in and create a python main function
" nnoremap \python-main :read $ENVSETTINGS/templates/python-main.template<CR>o<Tab>
" nnoremap \html-main :read $ENVSETTINGS/templates/html-main.template<CR>
" " For local replace
" nnoremap gr gd[{V%::s/<C-R>///gc<left><left><left>
" 
" " For global replace
" " nnoremap gR gD:%s/<C-R>///gc<left><left><left>

" pretty print json file.
" nnoremap \jsonpretty execute '%!python -m json.tool' | w 
nnoremap \json-pretty :%!python -m json.tool

" " nnoremap <leader>ch vat:s/^\(.*\)$/<!-- \1 -->/
" " <html>
" "  help world
" " </html>
" 
" " macros
" "let @c = 'vat:s/^\(.*\)$/<!-- \1 -->/:noh'


"vim general remapped keys (not related to plugins)

" In the future, may want to remap this to be comma separated instead of being
" two separate parameters.
noremap <leader>/ :call AutoComment("","c")<cr>
noremap <leader>. :call AutoComment("","u")<cr>
" noremap <leader>/ :call AutoComment("","c")<left><left><left><left><left><left>
" noremap <leader>. :call AutoComment("","u")<left><left><left><left><left><left>
" noremap <c-/> :call AutoComment("","c")<cr>
" noremap <c-.> :call AutoComment("","u")<cr>
" vnoremap <leader>/ :call AutoComment("","c")<left><left><left><left><left><left>
" vnoremap <leader>. :call AutoComment("","u")<left><left><left><left><left><left>


" If splits exists, this will have the split take up the whole page.
nnoremap <silent> <leader>f :ZoomToggle<CR>

nnoremap <CR> o<Esc>k
inoremap <C-e> <C-o>$
inoremap <C-a> <C-o>0
inoremap {<CR> {<CR>}<C-o><S-o>
" inoremap {<Tab> {}<Left>
" inoremap [<Tab> []<Left>
" inoremap (<Tab> ()<Left>
" inoremap '<Tab> ''<Left>
" inoremap \"<Tab> \""<Left>
" inoremap :<CR> :<CR><Tab>
"nnoremap <SPACE> <Nop>


" Visual line color. In black background and grey text, cannot see.
" hi Visual  guifg=blue guibg=blue gui=none
hi Visual ctermfg=darkgrey ctermbg=lightblue
" highlight GitGutterDelete ctermfg=black ctermbg=red
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
" Buffers
" nnoremap <C-i> :bn<cr>
" nnoremap <C-o> :bp<cr>
nnoremap <leader>d :bd<cr> 
nnoremap <leader>b :ls<cr>
nnoremap <leader>o :buffers<CR>:b 

" nnoremap <leader>l :ls<cr>


" Use ctrl-[select] the active split!
noremap <silent> <C-k> :wincmd k<CR>
noremap <silent> <C-j> :wincmd j<CR>
noremap <silent> <C-h> :wincmd h<CR>
noremap <silent> <C-l> :wincmd l<CR>
" inoremap <C-k> <C-o>:wincmd k<CR>
" inoremap <C-j> <C-o>:wincmd j<CR>
" inoremap <C-h> <C-o>:wincmd h<CR>
" inoremap <C-l> <C-o>:wincmd l<CR>
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
" This will clear the hlsearch
" nnoremap <silent> <C-c> :noh<return><esc>
nnoremap <silent> <leader>c :noh<return><esc>

" command! -nargs=* Xyz :call GrepSearch(<q-args>)

nnoremap <leader>s :call GrepSearch("")<left><left>

nnoremap <leader>0 :call VimSettings()<cr>
" nmap <silent> <leader>ws :call MarkWindowSwap()<CR>
" nmap <silent> <leader>wt :call DoWindowSwap()<CR><C-w>h
" 



"vim settings

" " FILE BROWSING with netrw
" "let g:netrw_banner=0        " disable banner
" "let g:netrw_browse_split=4  " open in prior window
" let g:netrw_altv=1          " open splits to the right
" let g:netrw_liststyle=3      " tree view
" let g:netrw_list_hide=netrw_gitignore#Hide()
" let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'
" let g:netrw_bufsettings = 'noma nomod nu nobl nowrap ro'

" " Default command to make sure vim does not behave like vi
" set tabstop=2

" " Search for cpp or use default
syntax enable
" 
set mouse=a

" Allows mac to copy and paste through vim and clipboard
set clipboard=unnamed

" "Line Numbers
set number
set relativenumber

set expandtab
" Highlight column 80 to unsure lines don't go too long.
set cc=80
highlight ColorColumn ctermbg=white
" highlight ColorColumn guibg=lightgrey ctermbg=lightgrey

" " These commands customize built-in find to make vim search through the
" whole project structure. Unfortunately even if files matched 'ignores'
" node_modules, the searching takes a long time to complete still, leading me
" to believe it's still searching through those files. 
" replaced with fzf.vim plugin instead.
" Still useful for quick files.
" set path+=**
set wildmenu
set wildignore+=**/node_modules/**
set wildmode=longest,list,full

"Set ignore Case when Searching with / and using vimgrep (GrepSearch)
set ignorecase

" Smart Casing when searching. This will ignore ignorecase if capital letters
" are specified
" Does not affect vimgrep. Need to turn off ignorecase (set noic)
set smartcase

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

" "Always show status line
set laststatus=2
" 
" "set background=dark
" 
" Allows to switch buffers even if not written too (which is vim default)
set hidden

" keep undo history
set undofile                " Save undos after file closes
set undodir=$HOME/.vim/undo " where to save undo histories
set undolevels=1000         " How many undos
set undoreload=10000        " number of lines to save for undo

"Tab Space
set ts=4
" set ts=2

" scrolloff to keep the cursor in the center. Try it by default, or move to
" function. Now change it to show at least 10 lines.
" set scrolloff=999
set scrolloff=10

"Shift Space
"set shiftwidth=4
set shiftwidth=4




"vim functions

function! VimSettings()
    let settings = {
                \   '0': 'do nothing',
                \   '1': 'call Lines() " numbers!, relativenumbers!',
                \   '2': 'call Notes() " formatoptions=ctnqro, comments+=n:*,n:#',
                \   '5': 'ZoomToggle " Toggle fullscreen the current view',
                \   '6': 'let @+ = expand("%:p") " Get full filepath into yank',
                \   '8': 'set smartindent!',
                \   '9': 'set paste!',
                \}
    " execute 'call Test()'
    for [key,value] in items(settings)
        echo key . ' ' . value
    endfor

    call inputsave()
"     echo 'Enter option: '
"     let action = getchar()
    let action = input('Enter option: ')
    call inputrestore()
    if action != 0 && has_key(settings, action)
        execute settings[action]
    endif
endfunction

" Timer to check if file has been updated by external program, and to reload.
" if ! exists("g:CheckUpdateStarted")
"     let g:CheckUpdateStarted=1
"     call timer_start(1,'CheckUpdate')
" endif
" function! CheckUpdate(timer)
"     silent! checktime
"     call timer_start(1000,'CheckUpdate')
" endfunction

" If commentchar is specified, do that.
"   If else check filetype, refer to dictionary to find char
"   If not in list, default to #
" https://github.com/KarimElghamry/vim-auto-comment
" Autocommenting is hard and annoying. Just manually comment or uncomment
function! AutoComment(comment_char, comment_boolean)
    let comments = {
                \   '"': ['vim'],
                \   '#': ['py', 'sh'],
                \   '//': ['js', 'ts', 'cpp', 'c', 'java'],
                \}
    let cur_filetype = &filetype
    let comment_type = '#'

    if len(a:comment_char) == 0
        for [comment_char,comment_filetype] in items(comments)
            if index(comment_filetype, cur_filetype) >= 0
                let comment_type = comment_char
            endif
        endfor
    else
        let comment_type = comment_char
    endif

    let line=getline('.')

    if a:comment_boolean == 'c'
        let line = comment_type . ' ' . line
    elseif a:comment_boolean == 'u'
        if line[0] == comment_type
            let line = line[2:]
        endif
    endif

    " if line[0] == comment_type
    "     let line = line[2:]
    " elseif line[0] != comment_type
    "     let line = comment_type . ' ' . line
    " endif
    call setline('.',line)

endfunction

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
    
" rewrite to split on , to differentiate number of args
" If second is blank, default to current filetype
"   If default filetype is blank, default to all
" If second is all, default to call
" If second is another specified filetype, then search using that.
function! GrepSearch(parametersplit)
    let parameters = split(a:parametersplit, ",")
    if len(parameters) == 1
        let found_extension = expand('%:e')
        " echo found_extension
        if len(found_extension) != 0
            call add(parameters, found_extension)
        else
            call add(parameters, 'all')
        endif
    endif
    let extension = "**/*"
    if parameters[1] != "all"
        let extension = extension . "." . parameters[1]
    endif
    let searchcommand = "vim " . parameters[0] . " " . extension . " | copen"
    echom searchcommand
    execute searchcommand
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



function! Lines()
  set number!
  set relativenumber!
endfunction

function! Notes()
  setlocal formatoptions=ctnqro
  setlocal comments+=n:*,n:#
endfunction




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
" " mf files, ma, then `argdo open` to open in buffers. How to automate?
" 
" noremap <leader>e :call ToggleNetrw()<CR>
" 
" 
" function! NetrwMapping()
"   noremap <buffer> <C-v> :call OpenToRight()<CR>
"   noremap <buffer> <C-h> :call OpenBelow()<CR>
" endfunction
" 
" 
" "noremap xq <ESC>
" "nnoremap tq :rightbelow 20vs<CR>:e .<CR><C-w>r<CR>
" 
" " Toggles netrw on the left side. Opens by default, toggle with
" " ctrl-e
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

" Helpful guides and how-tos for testing/quick reference purposes

" function! Demo()
"   let curline = getline('.')
"   call inputsave()
"   let name = input('Enter name: ')
"   call inputrestore()
"   call setline('.', curline . ' ' . name)
" endfunction

function! Test()
    echo "working Test"
endfunction




