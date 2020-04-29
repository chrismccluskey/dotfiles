#!/usr/bin/env bash
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
DOTFILES_ROOT="$BASEDIR/dot"
SUPPORTING_FILES_DIRECTORY="$BASEDIR/supporting-files"
source $BASEDIR/functions.sh
start_message
INSTALL="FALSE"

if [ "x$1" == "xstatus" ]; then
	echo "Status:"
	echo "Home: $HOME"
	echo "Base: $BASEDIR"
	echo "Dotfiles Root: $DOTFILES_ROOT"
	echo ""
	ls -lah $HOME/.bash_profile
	ls -lah $HOME/.zshrc
	ls -lah $HOME/.tmux.conf
	ls -lah $HOME/.tmux/plugins/tpm
	ls -lah $HOME/.config/tmuxinator/dev.yml
	ls -lah $HOME/.vimrc 
	ls -lah $HOME/.config/nvim/init.vim
	ls -lah $HOME/.local/share/nvim/site/autoload/plug.vim
	ls -lah $HOME/vim/autoload/plug.vim
	ls -lah $DOTFILES_ROOT
	ls -lah $SUPPORTING_FILES_DIRECTORY
	exit
fi

if [ "x$1" == "xclean" ]; then
	echo "Status:"
	echo "Home: $HOME"
	echo "Base: $BASEDIR"
	echo "Dotfiles Root: $DOTFILES_ROOT"
	echo ""
	rm -fv $HOME/.bash_profile
	rm -fv $HOME/.zshrc
	rm -fv $HOME/.tmux.conf
	rm -frv $HOME/.tmux/plugins/tpm
	rm -fv $HOME/.config/tmuxinator/dev.yml
	rm -fv $HOME/.vimrc 
	rm -fv $HOME/.config/nvim/init.vim
	rm -fv $HOME/.local/share/nvim/site/autoload/plug.vim
	rm -fv $HOME/vim/autoload/plug.vim
	rm -rf $HOME/.oh-my-zsh
	rm -frv $SUPPORTING_FILES_DIRECTORY
	if [ "x$2" == "xinstall" ]; then
		echo ""
		echo "Installing fresh..."
		echo ""
		INSTALL="TRUE"
	else
		exit
	fi
fi

if [ "x$1" == "xinstall" ]; then
	INSTALL="TRUE"
fi

if [ "x$INSTALL" == "xTRUE" ]; then
	# bash
	install_dotfile bash_profile

	# zsh
	install_dotfile zshrc

	# oh my zsh
	download_supporting_file https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh install.sh
	run_supporting_file install.sh

	# tmux
	install_dotfile tmux.conf

	# tmux plugin manager
	download_supporting_file https://github.com/tmux-plugins/tpm tpm
	link_supporting_file tpm .tmux/plugins/tpm

	# tmuxinator
	install_dotfile tmuxinator/dev.yml config/tmuxinator/dev.yml

	# vim
	install_dotfile vimrc
	# vim: neovim
	install_dotfile vimrc config/nvim/init.vim
	# vim: plug
	mkdir -p ~/.config/nvim/plugged
	download_supporting_file https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim plug.vim
	link_supporting_file plug.vim .local/share/nvim/site/autoload/plug.vim 
	link_supporting_file plug.vim .vim/autoload/plug.vim 
fi
