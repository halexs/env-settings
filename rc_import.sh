if [ "$SHELL" = "/bin/bash" ]; then
  SHELLRC=~/.bashrc
elif [ "$SHELL" = "/bin/zsh" ]; then
  SHELLRC=~/.zshrc
# another if for bash_profile on macs
else
  SHELLRC=~/.bash_profile
fi

export ENVSETTINGS=$PWD

TEMPLATERC=". $ENVSETTINGS/template_rc"
if ! grep -q "$TEMPLATERC" "$SHELLRC"; then
  echo $TEMPLATERC >> $SHELLRC
  echo 'rc now importing templaterc'
else
  echo 'rc already sourced'
fi

ENVEXPORT="export ENVSETTINGS=$PWD"
#echo $ENVEXPORT
if ! grep -q "$ENVEXPORT" "$SHELLRC"; then
  echo $ENVEXPORT >> $SHELLRC
  echo 'export env-settings path'
else
  echo 'env-settings path already set'
fi

TEMPLATEVIMRC="source $ENVSETTINGS/.vimrc"
if ! grep -q "$TEMPLATEVIMRC" ~/.vimrc; then
  echo $TEMPLATEVIMRC >> ~/.vimrc
  echo 'vimrc now importing from git project'
else
  echo 'vimrc already sourced'
fi
#echo $ENVSETTINGS
#echo $TEMPLATERC
#echo $TEMPLATEVIMRC
