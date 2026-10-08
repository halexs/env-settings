# env-settings: install shell, vim, tmux and ctags config.
#
#   make              show this help
#   make bootstrap    deps + install + plugins (fresh machine)
#   make install      wire the config into your home directory (offline-safe)

ROOT        := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
BLOCK       := $(ROOT)/install/block.sh
PLUGIN_DIR  ?= $(HOME)/.local/share/env-settings/plugins
VIMRC       ?= $(HOME)/.vimrc
TMUXCONF    ?= $(HOME)/.tmux.conf
PLUG_URL    := https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
SH_FILES    := $(wildcard install/*.sh shell/*.sh shell/*.bash scripts/* env_import.sh template_rc)

# Shell rc files to manage: those for shells that are installed. Override with
# RC_FILES="$HOME/.zshrc" make shell
RC_FILES ?= $(strip \
  $(if $(shell command -v zsh 2>/dev/null),$(HOME)/.zshrc) \
  $(if $(shell command -v bash 2>/dev/null),$(HOME)/.bashrc) \
  $(if $(filter Darwin,$(shell uname -s)),$(HOME)/.bash_profile))

# Lines the old env_import.sh appended; removed so nothing loads twice.
define LEGACY_SHELL
. $(ROOT)/template_rc
export ENVSETTINGS=$(ROOT)
export PATH="$${ENVSETTINGS}/scripts:$${PATH}"
endef
export LEGACY_SHELL

.DEFAULT_GOAL := help
.PHONY: help bootstrap install deps dirs shell vim tmux ctags nvim plugins zsh-plugins \
        vim-plugins lsp claude terminal fonts update uninstall doctor check lint

help: ## Show this help
	@awk 'BEGIN {FS = ":.*## "; printf "Usage: make \033[36m<target>\033[0m\n\n"} \
	  /^[a-zA-Z_-]+:.*## / {printf "  \033[36m%-14s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

bootstrap: deps install plugins lsp claude ## Fresh machine: tools, config, plugins, LSP servers, Claude Code
	@echo "All done. Open a new terminal (or run: exec \$$SHELL -l)."

install: dirs shell vim tmux ctags nvim ## Link config into $HOME (no network needed)
	@echo "Installed. Open a new terminal (or run: exec \$$SHELL -l)."

deps: ## Install tools (fzf, ripgrep, fd, bat, eza, zoxide, starship, ...)
	@$(ROOT)/install/deps.sh

dirs:
	@mkdir -p $(HOME)/.vim/undo $(HOME)/.vim/swap $(HOME)/.vim/backup $(HOME)/.vim/sessions \
	          $(HOME)/.local/bin $(PLUGIN_DIR)

shell: ## Source shell/rc.sh from ~/.zshrc and ~/.bashrc
	@for rc in $(RC_FILES); do \
	  printf 'export ENVSETTINGS="%s"\n[ -r "$$ENVSETTINGS/shell/rc.sh" ] && . "$$ENVSETTINGS/shell/rc.sh"\n' '$(ROOT)' \
	    | LEGACY_LINES="$$LEGACY_SHELL" $(BLOCK) add "$$rc" '#'; \
	  echo "shell: updated $$rc"; \
	done
	@[ -e $(HOME)/.shellrc.local ] || { cp $(ROOT)/shell/local.example.sh $(HOME)/.shellrc.local; \
	  echo "shell: created ~/.shellrc.local for machine-specific settings"; }

vim: ## Source the vimrc from ~/.vimrc
	@printf 'source %s/vimrc\n' '$(ROOT)' \
	  | LEGACY_LINES="source $(ROOT)/vimrc" $(BLOCK) add $(VIMRC) '"'
	@echo "vim: updated $(VIMRC)"

tmux: ## Source tmux.conf from ~/.tmux.conf
	@printf 'source-file %s/tmux.conf\n' '$(ROOT)' \
	  | LEGACY_LINES="source-file $(ROOT)/tmux.conf" $(BLOCK) add $(TMUXCONF) '#'
	@echo "tmux: updated $(TMUXCONF)"

ctags: ## Install universal-ctags options (~/.config/ctags)
	@mkdir -p $(HOME)/.config/ctags
	@ln -sfn $(ROOT)/ctags $(HOME)/.config/ctags/env-settings.ctags
	@echo "ctags: linked ~/.config/ctags/env-settings.ctags"

nvim: ## Neovim: load the same vimrc (only if nvim is installed)
	@if command -v nvim >/dev/null 2>&1; then \
	  mkdir -p $(HOME)/.config/nvim; \
	  printf 'source %s/vimrc\n' '$(ROOT)' | $(BLOCK) add $(HOME)/.config/nvim/init.vim '"'; \
	  echo "nvim: updated ~/.config/nvim/init.vim"; \
	fi

plugins: zsh-plugins vim-plugins ## Install zsh and vim plugins (needs network)

zsh-plugins: dirs ## Clone zsh-autosuggestions, syntax-highlighting, completions
	@for repo in zsh-users/zsh-autosuggestions zsh-users/zsh-syntax-highlighting zsh-users/zsh-completions; do \
	  dir=$(PLUGIN_DIR)/$${repo#*/}; \
	  if [ -d "$$dir/.git" ]; then git -C "$$dir" pull --ff-only -q && echo "updated $$repo"; \
	  else git clone --depth 1 -q https://github.com/$$repo "$$dir" && echo "cloned $$repo"; fi; \
	done

vim-plugins: dirs ## Install vim-plug and all vim plugins (needs network)
	@if [ ! -e $(HOME)/.vim/autoload/plug.vim ]; then \
	  curl -fsSLo $(HOME)/.vim/autoload/plug.vim --create-dirs $(PLUG_URL) && echo "vim: fetched vim-plug"; \
	fi
	@vim -es -N -u $(ROOT)/vimrc -i NONE '+PlugInstall --sync' +qa </dev/null || true
	@if command -v nvim >/dev/null 2>&1; then \
	  curl -fsSLo "$${XDG_DATA_HOME:-$(HOME)/.local/share}/nvim/site/autoload/plug.vim" --create-dirs $(PLUG_URL); \
	  nvim --headless -u $(ROOT)/vimrc '+PlugInstall --sync' +qa; \
	fi
	@echo "vim: plugins installed"

LSP_SERVERS ?= lua-language-server pyright ruff typescript-language-server bash-language-server \
               json-lsp yaml-language-server html-lsp css-lsp

lsp: ## Neovim: install language servers via Mason (needs nvim 0.11+)
	@command -v nvim >/dev/null 2>&1 || { echo "nvim not installed; run 'make deps'"; exit 1; }
	@nvim --headless -u $(ROOT)/vimrc -l $(ROOT)/install/mason-install.lua $(LSP_SERVERS)

claude: ## Install the Claude Code CLI (powers :ClaudeCode in Neovim)
	@$(ROOT)/install/claude.sh

terminal: ## Install the Ghostty terminal config (Option-as-Alt for tmux)
	@mkdir -p $(HOME)/.config/ghostty
	@if [ -e $(HOME)/.config/ghostty/config ] && [ ! -L $(HOME)/.config/ghostty/config ]; then \
	  echo "terminal: ~/.config/ghostty/config exists, not overwriting"; \
	else ln -sfn $(ROOT)/terminal/ghostty.config $(HOME)/.config/ghostty/config; echo "terminal: linked ghostty config"; fi

fonts: ## macOS: install Ghostty and a Nerd Font via Homebrew casks
	@command -v brew >/dev/null 2>&1 || { echo "Homebrew required"; exit 1; }
	brew install --cask ghostty font-jetbrains-mono-nerd-font

update: ## Pull this repo and update all plugins
	@git -C $(ROOT) pull --ff-only
	@$(MAKE) --no-print-directory zsh-plugins
	@vim -es -N -u $(ROOT)/vimrc -i NONE '+PlugUpdate --sync' +qa </dev/null || true
	@echo "updated"

uninstall: ## Remove the blocks added to your rc files
	@for rc in $(RC_FILES); do LEGACY_LINES="$$LEGACY_SHELL" $(BLOCK) remove "$$rc" '#'; done
	@LEGACY_LINES="source $(ROOT)/vimrc" $(BLOCK) remove $(VIMRC) '"'
	@LEGACY_LINES="source-file $(ROOT)/tmux.conf" $(BLOCK) remove $(TMUXCONF) '#'
	@[ ! -e $(HOME)/.config/nvim/init.vim ] || $(BLOCK) remove $(HOME)/.config/nvim/init.vim '"'
	@rm -f $(HOME)/.config/ctags/env-settings.ctags
	@echo "Removed. Plugins in ~/.vim and $(PLUGIN_DIR) were left alone."

doctor: ## Show which tools are installed
	@for t in git vim nvim claude tmux zsh bash fzf rg fd fdfind bat batcat eza zoxide starship ctags shellcheck jq; do \
	  if p=$$(command -v $$t 2>/dev/null); then printf '  \033[32m✔\033[0m %-11s %s\n' $$t "$$p"; \
	  else printf '  \033[31m✘\033[0m %-11s\n' $$t; fi; \
	done
	@printf '\n  ENVSETTINGS=%s\n' '$(ROOT)'

check: lint ## Syntax-check every config (shell, vim, tmux)
	@echo "vim:"; vim -es -N -u $(ROOT)/vimrc -i NONE \
	  -c 'if v:errmsg != "" | echo v:errmsg | cquit | endif' -c 'qa!' </dev/null && echo "  vimrc ok"
	@echo "tmux:"; rc=0; tmux -L es-check -f /dev/null new-session -d -s check \; source-file $(ROOT)/tmux.conf || rc=$$?; \
	  tmux -L es-check kill-server 2>/dev/null; \
	  if [ $$rc -eq 0 ]; then echo "  tmux.conf ok"; else echo "  tmux.conf has errors"; exit 1; fi

lint: ## Lint shell scripts (bash -n, zsh -n, shellcheck)
	@for f in $(SH_FILES); do bash -n $$f || exit 1; done; echo "bash -n ok"
	@if command -v zsh >/dev/null 2>&1; then zsh -n shell/zsh.zsh && echo "zsh -n ok"; else echo "zsh not installed, skipped"; fi
	@if command -v shellcheck >/dev/null 2>&1; then shellcheck -x $(SH_FILES) && echo "shellcheck ok"; \
	  else echo "shellcheck not installed, skipped"; fi
