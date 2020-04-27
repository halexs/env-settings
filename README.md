# env-settings
This is generic environment settings for development.

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
curl -XGET https://raw.githubusercontent.com/halexs/env-settings/master/.bashrc >> ~/.bashrc && source ~/.bashrc
curl -XGET https://raw.githubusercontent.com/halexs/env-settings/master/.bashrc >> ~/.bash_profile && source ~/.bash_profile
curl -XGET https://raw.githubusercontent.com/halexs/env-settings/master/.bashrc >> ~/.zshrc && source ~/.zshrc
```
