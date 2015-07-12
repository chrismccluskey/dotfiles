#!/bin/bash

directory=$HOME/dotfiles
backup_directory=$HOME/old.dotfile.backup

mkdir -p $backup_directory

for file in $directory/*
do
    filename=$(basename $file)
    echo $file

    if [[ "$filename" != "$(basename $0)" ]]; then
    	echo "Linking .$filename"
	mv $HOME/.$filename $backup_directory/
	ln -s $directory/$filename $HOME/.$filename
    fi
done
