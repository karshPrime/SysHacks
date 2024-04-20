#!/usr/bin/env bash

TODO_PATH="$HOME/Desktop"

if git rev-parse --is-inside-work-tree &> /dev/null; then
    TITLE_PATH=$(git rev-parse --show-toplevel)
else
    TITLE_PATH=$(pwd)
fi

$EDITOR $TODO_PATH/"$(basename $TITLE_PATH)".todo

