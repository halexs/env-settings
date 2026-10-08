# How to use this setup

Read it any time with `guide` in the shell, `Alt-a` then `/` in tmux, or
`Space ?` in Vim. `q` quits.

## The big picture

```
Terminal app (Ghostty)          just a window; no tabs, no splits
└── tmux                        your workspace: survives closing the terminal
    ├── session  "api"          one per project
    │   ├── window 1  nvim      editing
    │   ├── window 2  shell     server, tests, git
    │   └── window 3  shell     logs, a second repo, Claude
    └── session  "dotfiles"
```

Rule of thumb: **one tmux session per project, always.** Start it with `t` and
stop thinking about terminal tabs.

## Who does what

| Tool | Use it for | Examples |
|------|-----------|----------|
| **Shell** | Running things and moving around | `git`, `make`, `npm test`, `docker`, `ssh`, `cd`/`z`, `md README.md`, one-off `claude` |
| **tmux** | Keeping things alive and side by side | a project session, a dev server running in window 2, panes for logs, detaching, ssh that survives a dropped connection |
| **Vim/Neovim** | Reading and changing code | open files, search, go to definition, blame, diffs, edit with Claude looking at your file |

Quick test: *if it is text I am editing, Vim. If it keeps running while I do other
things, tmux. If it is a command, the shell.* The three nest, so you are never
choosing one forever: a shell runs inside tmux, Vim runs inside a shell, and
Vim has its own terminal for Claude.

## "How do I make tabs?"

"Tab" means three different things. Pick by what you want:

| I want... | Use | Keys |
|-----------|-----|------|
| Another full-screen thing next to my editor (shell, server, logs) | **tmux window** | `Alt-a c` new, `Alt-1`..`Alt-9` jump, `Alt-n`/`Alt-p` next/prev, `Alt-a ,` rename, `Alt-a &` close |
| Another file open in the editor | **Vim buffer**. They show as tabs along the top | `Space Space` find a file, `Tab`/`Q` next/prev, `Space 1`..`9` jump, `Space bd` close |
| Two things visible at once | **tmux pane** (shell) or **Vim split** (files) | tmux: `Alt-a %` side by side, `Alt-a "` stacked, `Alt-h/j/k/l` move. Vim: `:vsplit`, `:split`, `Ctrl-h/j/k/l` move |
| A second layout of windows in the editor (rare) | **Vim tab page** | `Space tn` new, `Space tc` close, `]t`/`[t` switch |

Do not use terminal-app tabs for projects. They die with the terminal; tmux
windows do not.

## A normal day

```bash
cd ~/code/api
t                      # attach to (or create) the session "api"
```
1. In window 1 start the editor: `vim .` (or `nvim .`). The start screen lists recent files.
2. `Alt-a c` for window 2. Run the server or tests there. `Alt-1` / `Alt-2` flips between code and output.
3. Back in Vim: `Space Space` to open files, `Space f g` to search the whole project.
4. Need Claude? `Space a c` inside Neovim opens it beside your code (see below).
5. Done for the day: just close the terminal, or `Alt-a d` to detach. Everything keeps running.
6. Tomorrow: `cd ~/code/api && t` and you are exactly where you left off.

Other projects: from inside tmux run `t other-project` (switches, does not nest),
or `Alt-w` to pick from a tree of every session and window.

### When to bring tmux in

- **Always** for project work. It costs one command (`t`).
- **Definitely** over ssh: if the connection drops, reconnect and `t` again.
- **Skip it** for quick one-off commands in a throwaway terminal.

After a reboot sessions are gone. `tmux-session save` before shutting down and
`tmux-session restore` afterwards recreate sessions and windows (not pane layouts).

## In the editor

### Find and move
| Keys | Does |
|------|------|
| `Space Space` | find file (git-aware fuzzy) |
| `Space f g` | search text in the project (ripgrep) |
| `Space f l` | search lines in this file |
| `Space b b` or `Space o` | pick an open buffer |
| `Ctrl-t` | file tree. `Space n` reveals the current file |
| `gd` / `gr` / `K` | definition / references / docs (Neovim LSP, or ALE in Vim) |
| `Space ]` | jump to a tag in a vertical split |
| `Ctrl-o` / `Ctrl-i` | back / forward through places you jumped |

### Git
Dimmed text at the end of the current line is the **inline blame**:
`Alice, 3 days ago • fix login redirect`. It follows your cursor, like GitLens.

| Keys | Does |
|------|------|
| `Space g m` | popup with the full commit behind this line (diff included). `q` closes |
| `Space g L` | every commit that touched this line (`git log -L`) |
| `Space g l` | history of this file |
| `Space g b` | full blame in a side window (`Enter` opens that commit) |
| `Space g B` | turn inline blame off/on |
| `Space g s` | git status. `-` stage, `cc` commit, `dv` diff |
| `Space g d` | diff this file against the index |
| `[c` `]c` | previous/next changed hunk; `Space h p` previews it, `Space h s`/`u` stage/undo |

The sign column on the left shows added, changed and removed lines.

### Claude Code
| Where | How |
|-------|-----|
| Neovim | `Space a c` toggles Claude in a panel. It sees your current file and selection. Proposed edits appear as diffs: `Space a a` accepts, `Space a d` denies. `Space a b` adds the file, visual `Space a s` sends the selection |
| Vim | `:Claude` (or `Space a c`) opens the CLI in a split |
| tmux | `Alt-a C` opens Claude in a pane on the right |
| Shell | `cc` (or `ccc` to continue, `ccr` to resume) |

### Reading markdown (READMEs, docs)
| Where | How |
|-------|-----|
| Shell | `md` renders `README.md`; `md FILE`; `md -f` picks a file with live preview. Needs `glow` (`make deps`) |
| tmux | `Alt-a m` pops up the README over whatever you are doing, `Alt-a M` lets you pick |
| Vim | `Space m p` renders the current file or README. In **Neovim** markdown buffers also render in place (headings, tables, code); `Space m r` toggles that |

### Help inside Vim
`Space 0` opens a searchable menu of actions. `:Cheatsheet` lists keys. `Space` and pause
(Neovim) shows what each key group does.

## tmux keys

Prefix is `Alt-a` (Option on a Mac). Press it, release, then the key.

| Keys | Does |
|------|------|
| `Alt-1`..`9`, `Alt-n`, `Alt-p` | switch window (no prefix needed) |
| `Alt-h/j/k/l` | move between panes (no prefix) |
| `Alt-z` | zoom a pane full-screen and back |
| `Alt-w` / `Alt-s` | tree of windows / sessions |
| `Alt-r` | reload `tmux.conf` |
| prefix `c` | new window (same directory) |
| prefix `%` `"` or `\|` `-` | split side by side / stacked |
| prefix `H J K L` | resize panes (repeatable) |
| prefix `d` | detach |
| prefix `[` | copy mode: move with vim keys, `v` select, `y` copy. Also copies to the system clipboard |
| prefix `m` / `M` / `/` | README popup / pick markdown / this guide |
| prefix `C` | Claude in a right-hand pane |

Mouse works too: click to focus a pane, drag to select, scroll.

## When something is off

- **tmux Alt keys type odd characters (macOS):** Option is not acting as Alt. `make terminal` configures Ghostty; iTerm2: *Left Option key: Esc+*; Terminal.app: *Use Option as Meta key*.
- **Vim looks washed out:** the terminal lacks true colour (Terminal.app). Use Ghostty, iTerm2 or WezTerm.
- **A Vim plugin command is missing:** `make vim-plugins`, then restart Vim.
- **No LSP in Neovim:** needs Neovim 0.11+ and `make lsp`.
- **`md` shows plain text:** install `glow` (`make deps`).
- **What did I install?** `make doctor`. **Update everything:** `make update`.
