#!/usr/bin/env bash

if git rev-parse --is-inside-work-tree &> /dev/null; then
    PROJECT_NAME=$(git rev-parse --show-toplevel)
    TMUX_PANE="code" # rename window to this if within tmux session

    case "$1" in
        readme)
            $EDITOR "$PROJECT_NAME/README*"
            ;;

        gitignore)
            $EDITOR "$PROJECT_NAME/.gitignore"
            ;;

        gitconfig)
            $EDITOR "$PROJECT_NAME/.git/config"
            ;;

        makefile)
            $EDITOR "$PROJECT_NAME/Makefile"
            ;;

        main)
            $EDITOR $(find $PROJECT_NAME -type d -name ".git" -prune -o -type f\
                -iname "main*" ! -iname "main.o" -print)
            ;;

        parent)
            cd $PROJECT_NAME
            ;;

        alltype) 
            # open all project codefile in buffer. comes handy with telescope buffer when
            # new files are not git commited, or when git commits also consists of a lot
            # of binaries and non-code files
            if [ -z "$2" ]; then
                echo -e "Usage: \e[33mcode \e[34m<file_extensions>"
                exit 1
            fi

            if [ "$2" == "." ]; then
                WORKDIR=". -maxdepth 1"
            else
                WORKDIR="$PROJECT_NAME"
            fi

            # Shift the parameters to access $3, $4, and so on
            shift

            # Build the find command dynamically based on the provided file extensions
            find_cmd="find $WORKDIR -type f"
            for extension in "$@"; do
                find_cmd+=" -iname '*.$extension' -o"
            done
            find_cmd=${find_cmd% -o}  # Remove the trailing '-o'

            # Rename tmux pane to $TMUX_PANE if within tmux session
            if [[ ! -z "$TMUX" ]]; then
                tmux renamew "$TMUX_PANE"
            fi

            # Open all files with the specified extensions in the editor
            $EDITOR $(eval $find_cmd)
            ;;
    esac

else
    echo -e "\e[31mError: \e[0mThis action requires the project to be within a git repo."
fi

