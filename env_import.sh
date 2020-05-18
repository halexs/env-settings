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

export ENVSETTINGS=$PWD

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

TEMPLATEVIMRC="source $ENVSETTINGS/.vimrc"
if ! grep -q "$TEMPLATEVIMRC" ~/.vimrc; then
  echo $TEMPLATEVIMRC >> ~/.vimrc
  echo 'vimrc now importing from git project'
else
  echo 'vimrc already sourced'
fi

#ENVPATH="$ENVSETTINGS/scripts"
#[[ ":$PATH:" != *":$ENVSETTINGS:"* ]] && PATH="${ENVPATH}:${PATH}" && echo "env scripts added to path"
#export PATH

