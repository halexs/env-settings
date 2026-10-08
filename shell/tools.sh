# shellcheck shell=bash
# Initialise optional tools. Everything is guarded, so a missing tool is fine.

have() { command -v "$1" >/dev/null 2>&1; }

# --- fzf --------------------------------------------------------------------
if have fzf; then
  if have fd; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
  elif have rg; then
    export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git"'
    export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
  fi
  # Catppuccin Mocha colours.
  export FZF_DEFAULT_OPTS="--height=40% --layout=reverse --border=rounded --info=inline \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8,border:#6c7086"
  if have bat; then
    export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:200 {}'"
  fi
  export FZF_ALT_C_OPTS="--preview 'ls -1 {}'"

  # Newer fzf (0.48+) can print its own integration; older ones ship files.
  if [ "$ES_SHELL" = zsh ] && fzf --zsh >/dev/null 2>&1; then
    # shellcheck disable=SC1090
    source <(fzf --zsh)
  elif [ "$ES_SHELL" = bash ] && fzf --bash >/dev/null 2>&1; then
    eval "$(fzf --bash)"
  else
    for _es_f in "/usr/share/doc/fzf/examples" "/usr/share/fzf" "/opt/homebrew/opt/fzf/shell" \
                 "/usr/local/opt/fzf/shell" "$HOME/.fzf"; do
      if [ -r "$_es_f/key-bindings.$ES_SHELL" ]; then
        # shellcheck source=/dev/null
        . "$_es_f/key-bindings.$ES_SHELL"
        # shellcheck source=/dev/null
        [ -r "$_es_f/completion.$ES_SHELL" ] && . "$_es_f/completion.$ES_SHELL"
        break
      fi
    done
    unset _es_f
  fi
fi

# --- zoxide: smarter cd (`z foo`, `zi` for interactive) ----------------------
if have zoxide; then
  eval "$(zoxide init "$ES_SHELL")"
fi

# --- pyenv ------------------------------------------------------------------
if have pyenv; then
  eval "$(pyenv init -)"
  # shellcheck disable=SC2015
  pyenv commands 2>/dev/null | grep -qx virtualenv-init && eval "$(pyenv virtualenv-init -)" || true
fi

# --- prompt: starship, last so it wins over the fallback prompt --------------
if have starship; then
  export STARSHIP_CONFIG=${STARSHIP_CONFIG:-$ENVSETTINGS/shell/starship.toml}
  eval "$(starship init "$ES_SHELL")"
fi

unset -f have
