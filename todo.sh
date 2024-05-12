#!/usr/bin/env bash

SAVE_PATH="$HOME/Documents/todo/"

# Project Description ---------------------------------------------------------

# Project Path
if git rev-parse --is-inside-work-tree &> /dev/null; then
    TITLE_PATH=$(git rev-parse --show-toplevel)
else
    TITLE_PATH=$(pwd)
fi

# Project Name
PROJECT_NAME=$(basename $TITLE_PATH)


# User Commands ---------------------------------------------------------------

# Check for flags
contains_flag() {
    local flag="-$1"
    shift
    for arg in "$@"; do
        [[ "$arg" == "$flag" ]] && return 0
    done
    return 1
}

# Create new file if one doesn't already exists
# default + support for -l
if [ -n $(find $SAVE_PATH -type f -name "$PROJECT_NAME.todo") ] ||
    [ -n $(find $TITLE_PATH -type f -name "$PROJECT_NAME.todo") ]; then
    
    if contains_flag "l" "$@"; then
        touch "$TITLE_PATH/$PROJECT_NAME.todo"
    else
        touch "$SAVE_PATH/$PROJECT_NAME.todo"
    fi
fi
