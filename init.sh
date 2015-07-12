#!/bin/bash

directory=$HOME/dotfiles
backup_directory=$HOME/old.dotfiles.backup

mkdir -p $backup_directory

curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

for file in $directory/*
do
    filename=$(basename $file)
    echo "File: $file"

    if [[ "$filename" != "$(basename $0)" ]]; then
    	echo "Linking ./$filename to ~/.$filename"
	mv $HOME/.$filename $backup_directory/
	ln -s $directory/$filename $HOME/.$filename
    fi
done

rm $HOME/.README.md
rm $HOME/.LICENSE
rm $HOME/.README.md
