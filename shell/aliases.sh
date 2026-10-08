# shellcheck shell=bash
# shellcheck disable=SC2262,SC2263
# Aliases shared by bash and zsh.

# --- modern replacements, only when installed -------------------------------
# Debian/Ubuntu install bat and fd under different names.
if ! command -v bat >/dev/null 2>&1 && command -v batcat >/dev/null 2>&1; then alias bat=batcat; fi
if ! command -v fd  >/dev/null 2>&1 && command -v fdfind >/dev/null 2>&1; then alias fd=fdfind;  fi

if command -v eza >/dev/null 2>&1; then
  alias ls='eza --group-directories-first'
  alias ll='eza -l --group-directories-first --git --time-style=relative'
  alias la='eza -la --group-directories-first --git --time-style=relative'
  alias lt='eza --tree --level=2 --group-directories-first'
else
  if ls --color=auto >/dev/null 2>&1; then alias ls='ls --color=auto'; else alias ls='ls -G'; fi
  alias ll='ls -lh'
  alias la='ls -lAh'
fi
alias grep='grep --color=auto'

# --- navigation -------------------------------------------------------------
alias ..='cd ..'
alias ...='cd ../..'
alias c-env='cd "$ENVSETTINGS"'
alias c-share='cd ~/Work/docker/share'

# --- editing the config files -----------------------------------------------
alias v-n='vim ~/notes'
alias v-ssh='vim ~/.ssh/config'
alias v-vrc='vim "$ENVSETTINGS/vimrc"'
alias v-rc='vim "$ENVSETTINGS/shell"'
alias v-tmux='vim "$ENVSETTINGS/tmux.conf"'
alias s-rc='exec "$SHELL" -l'            # restart the shell with fresh config
alias tmux-init='tmux source-file ~/.tmux.conf'

# --- git --------------------------------------------------------------------
alias g='git'
alias gs='git status -sb'
alias gd='git diff'
alias gds='git diff --staged'
alias gl="git log --oneline --graph --decorate -20"
alias gla="git log --oneline --graph --decorate --all"
alias gacomm='git add . ; git commit'
alias gitacomm='git add . ; git commit'   # old name

# --- docker / misc ----------------------------------------------------------
alias dc='docker compose'
alias dc-res='docker compose down; docker compose up -d'
alias dump_history='history >> ~/history.txt'
alias re-ctag='ctags -R --exclude=.git --exclude=build --exclude=node_modules .'

# --- AI ---------------------------------------------------------------------
alias cc='claude'
alias ccc='claude --continue'
alias ccr='claude --resume'

# --- docs -------------------------------------------------------------------
alias mdf='md -f'                                         # pick a markdown file with fzf
alias guide='md "$ENVSETTINGS/docs/WORKFLOW.md"'          # how to use this setup
alias tl='tmux list-sessions'
