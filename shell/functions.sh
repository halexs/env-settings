# shellcheck shell=bash
# Small shell functions shared by bash and zsh.

# mkdir + cd
mkcd() { mkdir -p -- "$1" && cd -- "$1" || return; }

# Reopen the last vim session for the current directory (see SaveSession in vimrc).
vimlatest() {
  local dir=$HOME/.vim/sessions/${PWD##*/}/latest.session
  if [ -f "$dir" ]; then
    vim -S "$dir"
  else
    vim -S "$HOME/.vim/sessions/latest.session"
  fi
}

# Persist `alias NAME='cd $PWD'` for the current directory.
add_dir() {
  [ -n "$1" ] || { echo "usage: add_dir NAME" >&2; return 1; }
  echo "alias $1='cd $PWD'" >> "$HOME/.shellrc.local"
  # shellcheck source=/dev/null
  . "$HOME/.shellrc.local"
}

# Copy your public key to a host: ssh_add_key user@host
ssh_add_key() {
  local key=${ES_SSH_KEY:-$HOME/.ssh/id_ed25519}
  if command -v ssh-copy-id >/dev/null 2>&1; then
    ssh-copy-id -i "$key.pub" "$@"
  else
    ssh "$1" 'mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys' < "$key.pub"
  fi
}

# Extract any common archive.
extract() {
  local f
  for f in "$@"; do
    case $f in
      *.tar.bz2|*.tbz2) tar xjf "$f" ;;
      *.tar.gz|*.tgz)   tar xzf "$f" ;;
      *.tar.xz)         tar xJf "$f" ;;
      *.tar)            tar xf  "$f" ;;
      *.zip)            unzip "$f" ;;
      *.gz)             gunzip "$f" ;;
      *.bz2)            bunzip2 "$f" ;;
      *.7z)             7z x "$f" ;;
      *) echo "extract: don't know how to extract '$f'" >&2; return 1 ;;
    esac
  done
}

# fzf helpers (defined only when fzf is installed).
if command -v fzf >/dev/null 2>&1; then
  # Fuzzy cd into a subdirectory.
  fcd() {
    local dir
    if command -v fd >/dev/null 2>&1; then
      dir=$(fd --type d --hidden --exclude .git . "${1:-.}" | fzf --height 40% --reverse) || return
    else
      dir=$(find "${1:-.}" -type d -not -path '*/.git/*' 2>/dev/null | fzf --height 40% --reverse) || return
    fi
    cd -- "$dir" || return
  }

  # Fuzzy git branch checkout.
  fgb() {
    local branch
    branch=$(git branch --all --sort=-committerdate --format='%(refname:short)' |
      fzf --height 40% --reverse --preview 'git log --oneline --graph --color=always -20 {}') || return
    git checkout "${branch#origin/}"
  }
fi
