#!/bin/bash

# Define directories
base_directory=$HOME/dotfiles
dot_directory=$base_directory/dot
backup_directory=$HOME/dotfiles.backup
vim_directory=$HOME/.vim 

# Install plug.vim
if [ -f "$vim_directory/autoload/plug.vim" ]; then
    echo "Skipped plug.vim installation (already installed)"
else
    curl -fLo $vim_directory/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    echo "Installed plug.vim"
fi

# Create vim back/swap/undo directories
for directory in .backup .swp .undo
do
    if [ ! -d "$vim_directory/$directory" ]; then
        mkdir $vim_directory/$directory
        echo "Created $vim_directory/$directory"
    fi
done

# Install Oh My ZSH!
curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh

# Install everything in the dot directory
for file in $dot_directory/*
do
    filename=$(basename $file)
    if [[ "$filename" != "$(basename $0)" ]]; then

	# Backup file if one already exists
	if [ -f "$HOME/.$filename" ]; then

            # Make directory for backups if one doesn't exist
            if [ ! -d "$backup_directory" ]; then
                mkdir -p $backup_directory
            fi

	    # Backup existing file
	    mv $HOME/.$filename $backup_directory/
	fi
	ln -s $dot_directory/$filename $HOME/.$filename
    	echo "Linked ./dot/$filename to ~/.$filename"
    fi
done