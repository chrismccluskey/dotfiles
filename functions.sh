#!/usr/bin/env bash

# actions: copy, copy (with delete after), symlink
# flags: --preview

start_message () {
	echo "-=[ dotfiles ]=-"
	echo ""
	echo ""
}

run_suporting_file () {
	chmod +x $SUPPORTING_FILES_DIRECTORY/$1
	$SUPPORTING_FILES_DIRECTORY/$1
}

install_dotfile () {
    source="$DOTFILES_ROOT/$1"

    if [ "x$2" != "x" ]; then
        target="$HOME/.$2"
    else
        target="$HOME/.$1"
    fi
	log_prefix=" . [ $source --> $target ] : "

    if test -f "$target"; then
		echo "$log_prefix skipped (present)"
    else
        target_directory=$( dirname ${target} )
        if [ -d "$target_directory" ]; then
            mkdir -p $target_directory
			log_mkdir=" created parent directories and"
        fi
        if ln -s $source $target; then
			echo "$log_prefix $log_mkdir linked"
		else
			echo "$log_prefix $log_mkdir FAILED to link"
		fi
    fi
}

link_supporting_file () {
    source="$SUPPORTING_FILES_DIRECTORY/$1"
    target="$HOME/$1"
	log_prefix=" s [ $source --> $target ] : "

    if test -f "$target"; then
		echo "$log_prefix skipped (present)"
    else
        target_directory=$( dirname ${target} )
        if [ -d "$target_directory" ]; then
            mkdir -p $target_directory
			log_mkdir=" created parent directories and"
        fi
        if ln -s $source $target; then
			echo "$log_prefix $log_mkdir linked"
		else
			echo "$log_prefix $log_mkdir FAILED to link"
		fi
    fi
}

download_supporting_file () {
    source="$1"
    target="$SUPPORTING_FILES_DIRECTORY/$2"
	log_prefix=" v [ $source --> $target ] : "

    if test -f "$target"; then
		echo "$log_prefix skipped (present)"
    else
        target_directory=$( dirname ${target} )
		if [ "x${source:0:19}" == "xhttps://github.com/" ]; then
			if git clone $source $target &> /dev/null; then
				echo "$log_prefix cloned git repostitory"
			else
				echo "$log_prefix FAILED to clone git repostitory"
			fi
		else
			if curl -fLo $target --create-dirs $source &> /dev/null; then
				echo "$log_prefix downloaded via curl"
			else
				echo "$log_prefix FAILED to download via curl"
			fi
		fi
    fi
}
