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
esac

