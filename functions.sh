#!/usr/bin/env bash

# actions: copy, copy (with delete after), symlink
# flags: --preview

start_message () {
	echo "-=[ dotfiles ]=-"
	echo ""
	echo ""
}

run_supporting_file () {
	chmod +x $SUPPORTING_FILES_DIRECTORY/$1
	$SUPPORTING_FILES_DIRECTORY/$1
}

create_symlink () {
	target=$1
	link_name=$2
	log_prefix=" . [ $link_name -> symlink to existing target -> $target ] : "
    if test -f "$link_name"; then
		echo "$log_prefix skipped (present)"
    else
        link_name_directory=$( dirname ${link_name} )
		echo "link name dir $link_name_directory";
        if [ ! -d "$link_name_directory" ]; then
            mkdir -pv $link_name_directory
			log_mkdir=" created parent directories and"
        fi
        ln -sv -T $target $link_name
    fi
}

install_dotfile () {
    target="$DOTFILES_ROOT/$1"

    if [ "x$2" != "x" ]; then
        link_name="$HOME/.$2"
    else
        link_name="$HOME/.$1"
    fi

    create_symlink $target $link_name
}

link_supporting_file () {
    target="$SUPPORTING_FILES_DIRECTORY/$1"
    link_name="$HOME/$2"
	create_symlink $target $link_name
}

download_supporting_file () {
    url="$1"
    saved_filename="$SUPPORTING_FILES_DIRECTORY/$2"
	log_prefix=" v [ $url --> $saved_filename ] : "

    if [ -f "$saved_filename" ]; then
		echo "$log_prefix skipped (present)"
    else
        saved_filename_directory=$( dirname ${saved_filename} )
		if [ "x${url:0:19}" == "xhttps://github.com/" ]; then
			saved_filename_directory=$( dirname ${saved_filename} )
			if [ ! -d "$saved_filename_directory" ]; then
				mkdir -pv $saved_filename_directory
				echo "$log_prefix created parent directory $saved_file_directory"
			fi
			if git clone $url $saved_filename &> /dev/null; then
				echo "$log_prefix cloned git repostitory"
			else
				echo "$log_prefix FAILED to clone git repostitory"
			fi
		else
			if curl -fLo $saved_filename --create-dirs $url &> /dev/null; then
				echo "$log_prefix downloaded via curl"
			else
				echo "$log_prefix FAILED to download via curl"
			fi
		fi
    fi
}
