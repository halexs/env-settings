# env-settings: zsh specifics. Sourced by shell/rc.sh. No oh-my-zsh needed.

ES_PLUGIN_DIR=${ES_PLUGIN_DIR:-$HOME/.local/share/env-settings/plugins}

# --- options ----------------------------------------------------------------
setopt auto_cd auto_pushd pushd_ignore_dups pushd_silent
setopt interactive_comments no_beep extended_glob
setopt share_history inc_append_history extended_history
setopt hist_ignore_dups hist_ignore_all_dups hist_ignore_space hist_reduce_blanks hist_verify
HISTFILE=${HISTFILE:-$HOME/.zsh_history}
HISTSIZE=100000
SAVEHIST=100000

# "Freeze" tty settings so a program cannot leave the terminal in a bad state.
ttyctl -f 2>/dev/null

# --- completion -------------------------------------------------------------
[ -d "$ES_PLUGIN_DIR/zsh-completions/src" ] && fpath=("$ES_PLUGIN_DIR/zsh-completions/src" $fpath)
[ -d /opt/homebrew/share/zsh/site-functions ] && fpath=(/opt/homebrew/share/zsh/site-functions $fpath)

autoload -Uz compinit
_es_zcompdump=${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump
mkdir -p "${_es_zcompdump:h}"
# Rebuild the dump at most once a day; otherwise trust the cache.
if [[ -n ${_es_zcompdump}(#qN.mh+24) ]]; then
  compinit -d "$_es_zcompdump"
else
  compinit -C -d "$_es_zcompdump"
fi
unset _es_zcompdump

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'

# --- key bindings -----------------------------------------------------------
bindkey -e
autoload -Uz edit-command-line up-line-or-beginning-search down-line-or-beginning-search
zle -N edit-command-line
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^x^e' edit-command-line                 # edit the command in $EDITOR
bindkey '^[[A' up-line-or-beginning-search       # prefix history search
bindkey '^[[B' down-line-or-beginning-search
bindkey '^[OA' up-line-or-beginning-search
bindkey '^[OB' down-line-or-beginning-search
bindkey '^[[1;5C' forward-word                   # Ctrl-arrows
bindkey '^[[1;5D' backward-word
bindkey '^[[3~' delete-char

# git autocorrect gets in the way
alias git='nocorrect git'

# --- plugins (installed by `make plugins`, or by your package manager) -------
_es_source_first() {
  local f
  for f in "$@"; do
    [ -r "$f" ] && { source "$f"; return 0; }
  done
  return 1
}

_es_source_first \
  "$ES_PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh" \
  /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
  /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
  /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
  /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#6c7086'

# Called last by rc.sh.
_es_load_syntax_highlighting() {
  _es_source_first \
    "$ES_PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" \
    /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
    /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
    /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
    /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
}

# --- fallback prompt (replaced by starship when installed) -------------------
setopt prompt_subst
PROMPT='%F{blue}%~%f %(?.%F{green}.%F{red})❯%f '

# --- help palette: Alt-/ anywhere on the prompt ------------------------------
# Opens the same fuzzy help as `h`. Picking a command puts it on the command
# line (not run) so you can edit it; other entries print their details.
# ES_SLASH_HELP=1 (set in ~/.shellrc.local) also opens it when you type / on an
# empty line; cancelling leaves the / so paths still work.
_es_help_widget() {
  local pick action
  zle -I
  _es_help_chosen=
  pick=$(h --pick </dev/tty) || { zle reset-prompt; return 0 }
  if [[ -n $pick ]]; then
    _es_help_chosen=1
    action=${pick%%$'\t'*}
    [[ $action == sh:* ]] && { BUFFER=${action#sh:}; CURSOR=${#BUFFER} }
  fi
  zle reset-prompt
}
zle -N _es_help_widget
bindkey '^[/' _es_help_widget

_es_slash_widget() {
  if [[ -n ${ES_SLASH_HELP:-} && -z $BUFFER ]]; then
    _es_help_widget
    [[ -z $_es_help_chosen ]] && { BUFFER=/; CURSOR=1 }
  else
    zle self-insert
  fi
}
zle -N _es_slash_widget
bindkey '/' _es_slash_widget
