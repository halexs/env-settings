if [ "$SHELL" = "/bin/bash" ]; then
  SHELLRC=~/.bashrc
elif [ "$SHELL" = "/bin/zsh" ]; then
  SHELLRC=~/.zshrc
# another if for bash_profile on macs
else
  SHELLRC=~/.bash_profile
fi

TEMPLATERC='. $HOME/env-settings/template_rc'
if ! grep -q "$TEMPLATERC" "$SHELLRC"; then
  echo $TEMPLATERC >> $SHELLRC
  echo 'rc now importing templaterc'
else
  echo 'rc already sourced'
fi

TEMPLATEVIMRC='source ~/env-settings/.vimrc'
if ! grep -q "$TEMPLATEVIMRC" ~/.vimrc; then
  echo $TEMPLATEVIMRC >> ~/.vimrc
  echo 'vimrc now importing from git project'
else
  echo 'vimrc already sourced'
fi
