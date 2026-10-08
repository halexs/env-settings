# shellcheck shell=bash
# env-settings: entry point for interactive bash and zsh.
# Sourced from ~/.bashrc / ~/.zshrc by `make shell`.

# Only run once, and only for interactive shells.
[ -n "${ENV_SETTINGS_LOADED:-}" ] && return 0
case $- in *i*) ;; *) return 0 ;; esac
export ENV_SETTINGS_LOADED=1

# Work out where this repo lives if the installer did not export it.
if [ -z "${ENVSETTINGS:-}" ]; then
  if [ -n "${ZSH_VERSION:-}" ]; then
    eval '_es_src=${(%):-%x}'
  else
    _es_src=${BASH_SOURCE[0]}
  fi
  ENVSETTINGS=$(cd "$(dirname "$_es_src")/.." && pwd)
  unset _es_src
fi
export ENVSETTINGS

if [ -n "${ZSH_VERSION:-}" ]; then ES_SHELL=zsh; else ES_SHELL=bash; fi

# Homebrew (Apple Silicon, Intel, Linuxbrew): put its tools on PATH first.
for _es_brew in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
  if [ -x "$_es_brew" ]; then eval "$("$_es_brew" shellenv)"; break; fi
done
unset _es_brew

# PATH: repo scripts and ~/.local/bin, without duplicates.
for _es_dir in "$HOME/.local/bin" "$ENVSETTINGS/scripts"; do
  case ":$PATH:" in *":$_es_dir:"*) ;; *) PATH="$_es_dir:$PATH" ;; esac
done
unset _es_dir
export PATH

# Editor, pager, colours.
if command -v nvim >/dev/null 2>&1 && [ -n "${ES_PREFER_NVIM:-}" ]; then
  export EDITOR=nvim
else
  export EDITOR=vim
fi
export VISUAL=$EDITOR
export LESS='-R -F -X -i'
export CLICOLOR=1
[ -n "${TMUX:-}" ] || export TERM=${TERM:-xterm-256color}

# Ctrl-S / Ctrl-Q flow control would swallow vim's <C-s> mapping.
[ -t 0 ] && stty -ixon 2>/dev/null

# shellcheck source=shell/aliases.sh
. "$ENVSETTINGS/shell/aliases.sh"
# shellcheck source=shell/functions.sh
. "$ENVSETTINGS/shell/functions.sh"

if [ "$ES_SHELL" = zsh ]; then
  # shellcheck source=/dev/null
  . "$ENVSETTINGS/shell/zsh.zsh"
else
  # shellcheck source=shell/bash.bash
  . "$ENVSETTINGS/shell/bash.bash"
fi

# shellcheck source=shell/tools.sh
. "$ENVSETTINGS/shell/tools.sh"

# Machine-specific overrides (not tracked). See shell/local.example.sh.
# shellcheck source=/dev/null
[ -r "$HOME/.shellrc.local" ] && . "$HOME/.shellrc.local"

# zsh-syntax-highlighting must be loaded after everything else.
if [ "$ES_SHELL" = zsh ] && typeset -f _es_load_syntax_highlighting >/dev/null 2>&1; then
  _es_load_syntax_highlighting
fi
return 0
