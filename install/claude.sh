#!/usr/bin/env bash
# Install the Claude Code CLI (used by :ClaudeCode in Neovim, :Claude in Vim,
# and the `cc` shell alias).
set -uo pipefail
have() { command -v "$1" >/dev/null 2>&1; }

if have claude; then
  echo "claude already installed: $(command -v claude)"
  exit 0
fi

if have brew; then
  brew install --cask claude-code && exit 0
fi

if have curl; then
  # Official native installer (https://docs.anthropic.com/en/docs/claude-code/setup)
  curl -fsSL https://claude.ai/install.sh | bash && exit 0
fi

if have npm; then
  npm install -g @anthropic-ai/claude-code && exit 0
fi

echo "Could not install Claude Code automatically. See https://docs.anthropic.com/en/docs/claude-code/setup" >&2
exit 1
