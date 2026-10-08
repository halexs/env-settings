#!/usr/bin/env bash
# Manage a marked block of text inside a config file, idempotently.
#
#   block.sh add    FILE COMMENT_PREFIX < body   (insert or replace the block)
#   block.sh remove FILE COMMENT_PREFIX          (delete the block)
#
# Lines listed in $LEGACY_LINES (newline separated, exact match) are dropped
# first. That cleans up the bare lines the old env_import.sh appended.
# The first time a file is modified a copy is saved as FILE.env-settings.bak.
set -euo pipefail

action=${1:?usage: block.sh add|remove FILE COMMENT_PREFIX}
file=${2:?missing FILE}
prefix=${3:-#}

begin="$prefix >>> env-settings >>>"
end="$prefix <<< env-settings <<<"

[ "$action" = add ] || [ -e "$file" ] || exit 0
mkdir -p "$(dirname "$file")"
touch "$file"

if [ ! -e "$file.env-settings.bak" ]; then
  cp -p "$file" "$file.env-settings.bak"
fi

tmp=$(mktemp "${TMPDIR:-/tmp}/env-settings.XXXXXX")
trap 'rm -f "$tmp"' EXIT

# Copy everything except the old block and legacy lines.
# (legacy lines go through the environment: BSD awk rejects newlines in -v)
LEGACY_LINES="${LEGACY_LINES:-}" awk -v begin="$begin" -v end="$end" '
  BEGIN { n = split(ENVIRON["LEGACY_LINES"], l, "\n"); for (i = 1; i <= n; i++) if (l[i] != "") drop[l[i]] = 1 }
  $0 == begin { skip = 1; next }
  $0 == end   { skip = 0; next }
  skip || ($0 in drop) { next }
  { print }
' "$file" > "$tmp"

if [ "$action" = add ]; then
  # Separate the block from existing content with a blank line.
  if [ -s "$tmp" ] && [ -n "$(tail -n 1 "$tmp")" ]; then
    echo >> "$tmp"
  fi
  {
    echo "$begin"
    cat
    echo "$end"
  } >> "$tmp"
fi

# Write through cat so a symlinked rc file stays a symlink.
cat "$tmp" > "$file"
