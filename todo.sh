#!/usr/bin/env bash

# Project Description ---------------------------------------------------------

# Centralised todo location
SAVE_PATH="$HOME/Documents/todo/"

# Project Path
TITLE_PATH=$(git rev-parse --is-inside-work-tree &> /dev/null && git rev-parse --show-toplevel || pwd)

# Project Name
PROJECT_NAME=$(basename "$TITLE_PATH")


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

# Create new file if one doesn't already exist
# default + support for -l
if contains_flag "l" "$@"; then
    TODO_FILE="$TITLE_PATH/$PROJECT_NAME.todo"
    touch "$TODO_FILE"
fi

# Check if TODO exists
# -e
if contains_flag "e" "$@"; then
    if [ -f "$SAVE_PATH/$PROJECT_NAME.todo" ]; then
        echo -e "\033[31mCentralised :\033[0m Present"
    else
        echo -e "\033[31mCentralised :\033[0m Not Present"
    fi

    if [ -f "$TITLE_PATH/$PROJECT_NAME.todo" ]; then
        echo -e "\033[31mIn Project  :\033[0m Present"
    else
        echo -e "\033[31mIn Project  :\033[0m Not Present"
    fi
    exit 0
fi


# Edit the TODO file ----------------------------------------------------------

TODO_FILE="$SAVE_PATH/$PROJECT_NAME.todo"
$EDITOR "$TODO_FILE"
