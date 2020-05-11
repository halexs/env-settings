# env-settings
This is generic environment settings for development.

# How to Use
run `git clone [repo]` in home directory, and run the `rc-import.sh` script.
Generic imports will be done in repo, and will automatically be sourced.
The following sections can still be done, but no longer necessary.

.vimrc settings:
```bash
wget -P ~/ https://raw.githubusercontent.com/halexs/env-settings/master/.vimrc
```

.bashrc / .bash_profile / .zsh
```bash
wget -P ~/ https://raw.githubusercontent.com/halexs/env-settings/master/.bashrc
wget -P ~/ https://raw.githubusercontent.com/halexs/env-settings/master/.bash_profile
wget -P ~/ https://raw.githubusercontent.com/halexs/env-settings/master/.zshrc
```

To dump alias into an existing `*rc` file. Do NOT run this command multiple times.
```bash
curl -XGET https://raw.githubusercontent.com/halexs/env-settings/master/template_rc >> ~/.bashrc && source ~/.bashrc
curl -XGET https://raw.githubusercontent.com/halexs/env-settings/master/template_rc >> ~/.bash_profile && source ~/.bash_profile
curl -XGET https://raw.githubusercontent.com/halexs/env-settings/master/template_rc >> ~/.zshrc && source ~/.zshrc
```
