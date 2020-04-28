#!/usr/bin/env bash
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
DOTFILES_ROOT="$BASEDIR/dot"

source $BASEDIR/functions.sh

# bash
install_dotfile bash_profile

# zsh
install_dotfile zshrc

# oh my zsh
install_from_url https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh 

# tmux
install_dotfile tmux.conf

# tmux plugin manager
install_from_url https://github.com/tmux-plugins/tpm tpm
install_dotfile_support tpm tmux/plugins/tpm

# tmuxinator
install_dotfile tmuxinator/dev.yml config/tmuxinator/dev.yml

# vim
install_dotfile vimrc
# vim: neovim
install_dotfile vimrc config/nvim/init.vim
# vim: plug
mkdir -p ~/.config/nvim/plugged
install_from_url https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim plug.vim
install_dotfile_support plug.vim local/share/nvim/site/autoload/plug.vim 
install_dotfile_support plug.vim vim/autoload/plug.vim 
