" Verifies help/help.tsv against the live config: every ex: action must name a
" command that exists and every <leader> key must be mapped. Run by `make check`
" once plugins are installed:
"   vim -es -N -u vimrc -i NONE -S install/check-help.vim
let s:root = fnamemodify(resolve(expand('<sfile>:p')), ':h:h')
let s:vimrc_text = join(readfile(s:root . '/vimrc'), "\n")
let s:bad = []
let s:checked = 0

for s:line in readfile(s:root . '/help/help.tsv')
  if empty(s:line) || s:line[0] ==# '#' | continue | endif
  let s:f = split(s:line, "\t", 1)
  let [s:layer, s:keys, s:action, s:flags] = [s:f[0], s:f[1], s:f[3], s:f[4]]
  " Neovim-only entries cannot be verified from plain Vim.
  if !has('nvim') && (s:layer ==# 'nvim' || (s:layer ==# 'claude' && index(['<leader>ac', '<leader>ar', '<leader>aC'], s:keys) < 0))
    continue
  endif
  if s:layer ==# 'shell' || s:layer ==# 'tmux' || s:layer ==# 'topic' | continue | endif

  if s:action =~# '^ex:'
    let s:ex = s:action[3:]
    if s:ex =~# '^call s:\w\+'
      let s:fn = matchstr(s:ex, 's:\w\+')
      if s:vimrc_text !~# 'function! ' . s:fn . '('
        call add(s:bad, s:keys . ': function ' . s:fn . ' is not defined in vimrc')
      endif
    else
      let s:cmd = matchstr(s:ex, '^\a\+')
      if exists(':' . s:cmd) == 0
        call add(s:bad, s:keys . ': Ex command :' . s:cmd . ' does not exist')
      endif
    endif
    let s:checked += 1
  endif

  if s:flags !~# 'skip' && s:keys =~# '^<leader>\S\+$' && s:keys !~# '\.\.'
    let s:lhs = substitute(s:keys, '<leader>', ' ', '')
    if empty(maparg(s:lhs, 'n'))
      call add(s:bad, s:keys . ': no normal-mode mapping (' . s:layer . ')')
    endif
    let s:checked += 1
  endif
endfor

if empty(s:bad)
  call writefile(['  ' . s:checked . ' Vim help entries verified'], '/dev/stdout')
  qall!
else
  call writefile(['help.tsv is out of date:'] + map(s:bad, '"  " . v:val'), '/dev/stderr')
  cquit
endif
