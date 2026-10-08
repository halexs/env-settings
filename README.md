# env-settings

My development environment: shell (zsh/bash), Vim/Neovim, tmux and a few
scripts. Built for **macOS on Apple Silicon (M-series)**, and works on Linux
(Debian/Ubuntu, Fedora, Arch).

| Piece | What you get |
|-------|--------------|
| Shell | zsh (or bash) with [starship](https://starship.rs) prompt, fzf, zoxide, eza, bat, autosuggestions, syntax highlighting, sane history |
| Vim / Neovim | One vimscript config for both. Catppuccin theme, lightline, fzf, git, ALE linting. In Neovim also LSP, completion and **Claude Code** |
| tmux | Alt-based keys, true colour, system clipboard, Catppuccin status bar, Claude split |
| Makefile | Installs and updates all of it |

## Install

```bash
git clone https://github.com/halexs/env-settings.git
cd env-settings
make bootstrap      # tools + config + plugins + LSP servers + Claude Code
exec $SHELL -l
```

On a Mac install [Homebrew](https://brew.sh) first. Optionally run `make fonts terminal`
for the Ghostty terminal and a Nerd Font.

**New to tmux/Vim, or wondering where tabs fit?** Read [docs/WORKFLOW.md](docs/WORKFLOW.md):
what belongs in the shell vs tmux vs Vim, how to make tabs, and a typical day. Once installed,
`guide` shows it rendered in the terminal.

`make` alone lists every target. The useful ones:

| Target | Does |
|--------|------|
| `make install` | Wire config into `$HOME` (no network). Re-run any time; it is idempotent |
| `make deps` | Install tools with brew / apt / dnf / pacman |
| `make plugins` | zsh plugins + vim-plug and all Vim plugins |
| `make lsp` | Language servers for Neovim via Mason |
| `make claude` | Claude Code CLI |
| `make terminal` | Ghostty config (Option acts as Alt, needed by tmux keys) |
| `make update` | `git pull` + update plugins |
| `make doctor` | Which tools are installed |
| `make check` | Syntax-check shell, vim and tmux configs (also run in CI) |
| `make uninstall` | Remove what `install` added |

Nothing is overwritten: `install` appends one marked block
(`# >>> env-settings >>>`) to `~/.zshrc`, `~/.bashrc`, `~/.vimrc`, `~/.tmux.conf`,
backs each file up once as `*.env-settings.bak`, and removes the bare lines the old
`env_import.sh` added. Machine-specific settings go in `~/.shellrc.local` and
`~/.vimrc.local` (not tracked; `shell/local.example.sh` has the old docker/vagrant/aws
aliases to copy from).

## Using it as a VS Code replacement

Neovim 0.11+ (installed by `make deps` on macOS) gets an IDE layer from `nvim/ide.lua`:

- **LSP**: go to definition (`gd`), references (`gr`), hover (`K`), rename (`<Space>rn`),
  code actions (`<Space>ca`), format (`<Space>x`), diagnostics (`[e` `]e`); completion
  popup as you type. Servers are installed by `make lsp`.
- **Search / files**: fzf (`<Space>a`, `<Space>fg`), NERDTree (`<C-t>`), Git via fugitive and gitgutter.
- **Git, GitLens style**: the current line shows its blame inline (`Alice, 3 days ago • fix login redirect`).
  `<Space>gm` pops up the full commit, `gL` the history of just that line, `gb` a blame window, `gB` toggles the inline text.
- **Editor tabs**: open buffers show as a tab bar along the top; `<Space>1`..`9` jump to one. Start screen with recent files.
- **Discoverability**: press `<Space>` and wait for which-key. `<Space>0` opens a fuzzy menu, `:Cheatsheet` lists keys.
- **Claude Code** ([claudecode.nvim](https://github.com/coder/claudecode.nvim)) uses the same protocol as the VS Code extension:
  Claude sees your open file and selection and proposes edits as diffs inside Neovim.

  | Keys | Action |
  |------|--------|
  | `<Space>ac` | toggle Claude panel |
  | `<Space>af` | focus it |
  | `<Space>ar` / `aC` | resume / continue last conversation |
  | `<Space>ab` | add current file to context |
  | `<Space>as` (visual) | send selection |
  | `<Space>aa` / `ad` | accept / deny a proposed diff |

On Linux, distro packages of Neovim are often older than 0.11; install a current release (or `brew install neovim`) to get the IDE layer. Older Neovim and Vim fall back to the Vim feature set.

Plain Vim has no editor integration protocol, so it gets `:Claude` (and the same `<Space>ac`),
which runs the CLI in a terminal split, with ALE for linting and completion. Outside any
editor, `cc` runs `claude`, and `prefix C` in tmux opens Claude in a split.

## Reading markdown in the terminal

`md` renders `README.md` (or any file) with [glow](https://github.com/charmbracelet/glow); `md -f` picks a file with
fzf and a live preview. In tmux, `Alt-a m` pops the README over your work. In Vim, `<Space>mp` or `:Md`; in Neovim
markdown buffers also render in place (`<Space>mr` toggles). Falls back to bat/less when glow is not installed.

## Keys worth knowing

- Leader is `<Space>`. Vim: `<Tab>`/`Q` next/previous buffer, `<Space>/` toggle comment, `<S-Up/Down>` move line.
- tmux prefix is `Alt-a`; `Alt-h/j/k/l` move between panes, `Alt-1..9` windows, `Alt-r` reload.
  **On macOS Option must act as Alt**: `make terminal` configures Ghostty; in iTerm2 set
  *Left Option key: Esc+*; in Terminal.app enable *Use Option as Meta key*.
- Terminal.app lacks true colour, so Vim falls back to a 256-colour scheme there. Ghostty, iTerm2 and WezTerm give the full theme.

## Layout

```
Makefile            installer
install/            helper scripts (deps, marked-block editing, Claude, Mason)
shell/              rc.sh entry point, aliases, functions, zsh/bash specifics, starship.toml
vimrc               Vim + Neovim config (vim-plug)
nvim/ide.lua        Neovim-only: LSP, Claude Code, which-key
tmux.conf           tmux config
ctags               universal-ctags options
docs/WORKFLOW.md    how to use all of this
scripts/            on PATH: t (project tmux session), md (render markdown), ssh-key-copy, tmux-session
templates/          snippets for :Template
terminal/           Ghostty config
```

## Notes on changes from the old setup

- Vundle replaced by vim-plug; NERDTree, fzf, fugitive and gitgutter kept.
- Dropped mappings that broke built-ins: `Shift-R` (shadowed Replace mode) and `<C-m>` (is Enter).
  `Enter` still adds a blank line, except in quickfix.
- The ad-hoc comment toggle and menu were replaced by vim-commentary and a fuzzy `:Menu`.
- `ctags` targets universal-ctags (native TypeScript), so no custom regexes.
- `template_rc` and `env_import.sh` remain as thin shims for old rc files.
