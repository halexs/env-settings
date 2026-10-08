# shellcheck shell=bash
# env-settings: bash specifics. Sourced by shell/rc.sh.

# --- history ----------------------------------------------------------------
shopt -s histappend cmdhist
HISTSIZE=100000
HISTFILESIZE=200000
HISTCONTROL=ignoreboth:erasedups
HISTTIMEFORMAT='%F %T  '
# Write each command to the history file immediately.
case ";${PROMPT_COMMAND:-};" in
  *";history -a;"*) ;;
  *) PROMPT_COMMAND="history -a${PROMPT_COMMAND:+; $PROMPT_COMMAND}" ;;
esac

# --- behaviour --------------------------------------------------------------
# Each option separately: macOS ships bash 3.2, which lacks globstar/autocd/dirspell.
for _es_opt in checkwinsize globstar autocd cdspell dirspell; do shopt -s "$_es_opt" 2>/dev/null; done
unset _es_opt

# --- completion -------------------------------------------------------------
# bash-completion v2 needs bash 4.2+ (macOS's /bin/bash is 3.2; zsh is the macOS default anyway).
if ! shopt -oq posix && [ "${BASH_VERSINFO[0]}" -ge 4 ]; then
  for _es_f in /usr/share/bash-completion/bash_completion /etc/bash_completion \
               /opt/homebrew/etc/profile.d/bash_completion.sh \
               /usr/local/etc/profile.d/bash_completion.sh; do
    # shellcheck source=/dev/null
    [ -r "$_es_f" ] && { . "$_es_f"; break; }
  done
  unset _es_f
fi

# --- readline ---------------------------------------------------------------
if [[ $- == *i* ]]; then
  bind 'set completion-ignore-case on'
  bind 'set show-all-if-ambiguous on'
  bind 'set menu-complete-display-prefix on'
  bind 'set colored-stats on'
  bind 'set colored-completion-prefix on'
  bind 'set mark-symlinked-directories on'
  bind '"\e[A": history-search-backward'     # prefix history search
  bind '"\e[B": history-search-forward'
  bind '"\e[1;5C": forward-word'             # Ctrl-arrows
  bind '"\e[1;5D": backward-word'
  bind '"\C-x\C-e": edit-and-execute-command'
fi

# --- fallback prompt (replaced by starship when installed) -------------------
PS1='\[\e[34m\]\w\[\e[0m\] \[\e[32m\]❯\[\e[0m\] '
