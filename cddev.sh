#!/usr/bin/env bash

# ensure the script is being run inside a git repository
if ! git rev-parse --is-inside-work-tree &> /dev/null; then
    echo -e "\e[31mError: \e[0mThis action requires the project to be within a git repo."
    exit 1
fi

PROJECT_NAME=$(git rev-parse --show-toplevel)
TMUX_PANE="code" # rename window to this if within tmux session

case "$1" in
    readme)
        "$EDITOR" "$PROJECT_NAME/README"*
        ;;

    gitignore)
        "$EDITOR" "$PROJECT_NAME/.gitignore"
        ;;

    gitconfig)
        "$EDITOR" "$PROJECT_NAME/.git/config"
        ;;

    makefile)
        "$EDITOR" "$PROJECT_NAME/Makefile"
        ;;

    parent)
        cd "$PROJECT_NAME" || exit
        ;;

    alltype)
        WORKDIR="$PROJECT_NAME"
        CONDITIONS=()

        # construct find conditions based on arguments
        for ARG in "$@"; do
            if [ "$ARG" == "." ]; then
                WORKDIR=$(pwd)
            else
                CONDITIONS+=("-iname" "*.$ARG" "-o")
            fi
        done

        # remove trailing '-o' if present
        [ ${#CONDITIONS[@]} -gt 0 ] && unset 'CONDITIONS[-1]'

        # find files based on constructed conditions, excluding .hidden directory
        if [ ${#CONDITIONS[@]} -gt 2 ]; then
            FILES=$(find "$WORKDIR" -type f \( "${CONDITIONS[@]}" \) -not -path '*/.**/*')
        else
            FILES=$(find "$WORKDIR" -type f -not -path '*/.git/*')
        fi

        # trim the project path from the results
        trimmed_paths=()
        while IFS= read -r path; do
            trimmed_path="${path#$WORKDIR/}"
            trimmed_paths+=("$trimmed_path")
        done <<< "$FILES"

        # use fzf to select files, displaying with bat
        pushd "$WORKDIR" > /dev/null || exit
        FILES_CMD=$(printf "%s\n" "${trimmed_paths[@]}" |
            fzf --layout=reverse --cycle -i -m --preview="bat --color=always --number {}")
        popd > /dev/null || exit

        # open the selected files in the editor
        if [ -n "$FILES_CMD" ]; then
            "$EDITOR" $(echo "$FILES_CMD" | sed "s|^|$WORKDIR/|")
        fi
        ;;
esac

