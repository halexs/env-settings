#!/bin/bash

if [[ "$SHELL" == *"/bash"* ]]; then
  SHELLRC=~/.bashrc
elif [[ "$SHELL" == *"/zsh"* ]]; then
  SHELLRC=~/.zshrc
# another if for bash_profile on macs
else
  SHELLRC=~/.bash_profile
fi

echo $SHELLRC
#echo $SHELL


TEMPLATERC=". $ENVSETTINGS/template_rc"
if ! grep -q "$TEMPLATERC" "$SHELLRC"; then
  echo $TEMPLATERC >> $SHELLRC
  echo "rc $SHELLRC now importing templaterc"
  source $SHELLRC
else
  echo "rc $SHELLRC already sourced"
fi

ENVEXPORT="export ENVSETTINGS=$PWD"
if ! grep -q "$ENVEXPORT" "$SHELLRC"; then
  echo $ENVEXPORT >> $SHELLRC
  echo 'export env-settings path'
else
  echo 'env-settings path already set'
fi

PATHEXPORT='export PATH="${ENVSETTINGS}/scripts:${PATH}"'
if ! grep -q "$PATHEXPORT" "$SHELLRC"; then
  echo $PATHEXPORT >> $SHELLRC
  echo 'export env-settings scripts path'
else
  echo 'env-settings scripts already in path'
fi

#[[ ":$PATH:" != *":$ENVSETTINGS:"* ]] && export PATH="${ENVPATH}:${PATH}" && echo "env scripts added to path"

TEMPLATEVIMRC="source $ENVSETTINGS/vimrc"
if ! grep -q "$TEMPLATEVIMRC" ~/.vimrc; then
  echo $TEMPLATEVIMRC >> ~/.vimrc
  echo 'vimrc now importing from git project'
else
  echo 'vimrc already sourced'
fi

#tmux source-file $ENVSETTINGS/tmux.conf
# can source tmux file from ~/.tmux.conf
cp $ENVSETTINGS/tmux.conf ~/.tmux.conf
cp $ENVSETTINGS/ctags ~/.ctags

#export PATH

