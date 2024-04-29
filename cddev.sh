#!/usr/bin/env bash

PROJECT_NAME=$(git rev-parse --show-toplevel)

case "$1" in
    readme)
        $EDITOR $PROJECT_NAME/README.md
        ;;

    gitignore)
        $EDITOR $PROJECT_NAME/.gitignore
        ;;
        
    gitconfig)
        $EDITOR $PROJECT_NAME/.git/config
        ;;

    makefile)
        $EDITOR $PROJECT_NAME/Makefile
        ;;

    main)
        $EDITOR $(find $PROJECT_NAME -type d -name .git -prune -o -iname "main*" -print)
        ;;

    alltype) 
        # open all project codefile in buffer. comes handy with telescope buffer when new
        # files are not git commited, or when git commits also consists of a lot of
        # binaries and non-code files
        if [ -z "$2" ]; then
            echo -e "Usage: \e[33mcode \e[34m<file_extensions>"
            exit 1
        fi

        # Shift the parameters to access $3, $4, and so on
        shift

        # Build the find command dynamically based on the provided file extensions
        find_cmd="find $PROJECT_NAME -type f"
        for extension in "$@"; do
            find_cmd+=" -iname '*.$extension' -o"
        done
        find_cmd=${find_cmd% -o}  # Remove the trailing '-o'

        # Open all files with the specified extensions in the editor
        $EDITOR $(eval $find_cmd)
       ;;
esac

