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

ENVSETTINGS=$PWD

SOURCE_TEMPLATERC=". $ENVSETTINGS/template_rc"
if ! grep -q "$SOURCE_TEMPLATERC" "$SHELLRC"; then
  echo $SOURCE_TEMPLATERC >> $SHELLRC
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

SOURCE_VIMRC="source $ENVSETTINGS/vimrc"
if ! grep -q "$SOURCE_VIMRC" ~/.vimrc; then
  echo $SOURCE_VIMRC >> ~/.vimrc
  echo 'vimrc now importing from git project'
else
  echo 'vimrc already sourced'
fi

#tmux source-file $ENVSETTINGS/tmux.conf
# can source tmux file from ~/.tmux.conf
SOURCE_TMUX="source-file $ENVSETTINGS/tmux.conf"
#cp $ENVSETTINGS/tmux.conf ~/.tmux.conf
if ! grep -q "$SOURCE_TMUX" ~/.tmux.conf; then
  echo $SOURCE_TMUX >> ~/.tmux.conf
  echo 'tmux now importing from git project'
else
  echo 'tmux already sourced'
fi

#cp $ENVSETTINGS/ctags ~/.ctags

#export PATH
#source $SHELLRC
#echo $SHELLRC
mkdir -p ~/.vim/undo
