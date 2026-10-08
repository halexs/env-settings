#!/usr/bin/env bash
# Install the command line tools these dotfiles are built around.
# Supports Homebrew, apt, dnf and pacman. Anything unavailable is skipped
# with a warning rather than aborting the whole run.
set -uo pipefail

say()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33mwarn:\033[0m %s\n' "$*" >&2; }
have() { command -v "$1" >/dev/null 2>&1; }

SUDO=""
if [ "$(id -u)" -ne 0 ] && have sudo; then SUDO="sudo"; fi

# Install packages one at a time so a missing package does not block the rest.
install_each() {
  local installer=$1; shift
  local pkg
  for pkg in "$@"; do
    $installer "$pkg" || warn "could not install '$pkg'"
  done
}

mkdir -p "$HOME/.local/bin"

if [ "$(uname -s)" = Darwin ] && ! have brew; then
  # Apple Silicon installs to /opt/homebrew, which may not be on PATH yet.
  for b in /opt/homebrew/bin/brew /usr/local/bin/brew; do [ -x "$b" ] && eval "$("$b" shellenv)"; done
  have brew || warn "Homebrew missing. Install it from https://brew.sh, then re-run: make deps"
fi

if have brew; then
  say "Using Homebrew"
  install_each "brew install" git vim neovim tmux zsh fzf ripgrep fd bat eza zoxide starship \
    universal-ctags shellcheck shfmt jq git-delta gh node
elif have apt-get; then
  say "Using apt"
  $SUDO apt-get update
  install_each "$SUDO apt-get install -y" git curl vim tmux zsh fzf ripgrep fd-find bat \
    eza zoxide universal-ctags shellcheck jq
  # Debian/Ubuntu ship these under different names; expose the usual ones.
  have fdfind && ! have fd  && ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
  have batcat && ! have bat && ln -sf "$(command -v batcat)" "$HOME/.local/bin/bat"
elif have dnf; then
  say "Using dnf"
  install_each "$SUDO dnf install -y" git curl vim-enhanced tmux zsh fzf ripgrep fd-find bat \
    eza zoxide starship ctags ShellCheck jq
elif have pacman; then
  say "Using pacman"
  $SUDO pacman -Sy --needed --noconfirm git curl vim tmux zsh fzf ripgrep fd bat eza zoxide \
    starship ctags shellcheck jq || warn "pacman reported errors"
else
  warn "No supported package manager found (brew, apt, dnf, pacman). Install tools manually."
fi

# starship is not in apt; use the official installer into ~/.local/bin.
if ! have starship; then
  say "Installing starship prompt to ~/.local/bin (official installer)"
  if have curl; then
    curl -fsSL https://starship.rs/install.sh | sh -s -- --yes --bin-dir "$HOME/.local/bin" \
      || warn "starship install failed"
  else
    warn "curl missing; skipping starship"
  fi
fi

say "Done. Run 'make doctor' to see what is available."
