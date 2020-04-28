#!/usr/bin/env bash
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
DOTFILES_ROOT="$BASEDIR/dot"

# actions: copy, copy (with delete after), symlink
# flags: --preview
install_dotfile_support () {
	install_dotfile downloaded-dotfiles-support/$1 $2
}

install_dotfile () {
    source="$DOTFILES_ROOT/$1"

    if [ "x$2" != "x" ]; then
        target="$HOME/.$2"
    else
        target="$HOME/.$1"
    fi

    if test -f "$target"; then
        echo "Target for $target already exists"
    else
        target_directory=$( dirname ${target} )
        if [ -d "$target_directory" ]; then
            echo "Target directory $target_directory does not exist, creating..."
            mkdir -p $target_directory
        fi
        ln -s $source $target
        echo "Linked $source --> $target"
    fi
}

install_from_url() {
    source="$1"
    target="$DOTFILES_ROOT/downloaded-dotfiles-support/$2"

    if test -f "$target"; then
        echo "Target $target for $1 already exists"
    else
        target_directory=$( dirname ${target} )
		if [ "x${source:0:19}" == "xhttps://github.com/" ]; then
			echo "Cloning via git.."
			git clone $source $target
		else
			echo "Downloading via cURL.."
			curl -fLo $target --create-dirs $source
		fi
        echo "Downloaded $source --> $target"
    fi
}

echo "-=[ dotfiles [re]init ]=-"
echo ""
echo "Installing dotfiles from $DOCFILES_ROOT to $BASEDIR..."
echo ""

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
