#!/usr/bin/env bash

# This script automates project setup tasks, including directory creation, Git
# initialisation, README file generation and commit, language-specific file 
# setup, and .gitignore configuration. 

# Project Description
LANGUAGE="${1##*.}"
TITLE="${1%.*}"

# User Info
GIT_USER="karshPrime"

# Directories
TEMPLATE="$HOME/Projects/SysHacks/Makefiles/"  # default makefile directory
LICENSE="$HOME/Projects/LICENSE"    # license file; can be upgraded for dynamic 
                                    # licenses per project
TMUXIFIER_LAYOUT="$HOME/.config/tmux/tmuxifier/layouts"


# Get Started -----------------------------------------------------------------

echo "Initializing Project at $(pwd)/$TITLE"

mkdir "$TITLE"
cd "$TITLE"

# Initialize git & Commit license
git init --quiet
cp $LICENSE .
git add LICENSE
git commit -m "Apache 2.0"

# Create .gitignore
echo -e ".gitignore\n.DS_Store\n" > .gitignore

# Write & Commit basic readme
echo -e "# $TITLE\n\n" > README.md
git add README.md 
git commit -m "readme"


# Language specific actions ---------------------------------------------------

# Go
if [ "$LANGUAGE" = "go" ]; then
    echo -e "go.sum\n\nbin/\n" >> .gitignore
    go mod init "$TITLE"
    mkdir cmd
    echo -e "package main\n\nimport (\n\n)\n\nfunc main() {\n\n}\n" > main.go
    git add main.go go.mod
    git commit -m "project init"


# C/C++
elif [ "$LANGUAGE" = "c" ] || [ "$LANGUAGE" = "cpp" ]; then
    mkdir src obj
    echo -e "\nint main()\n{\n    return 0;\n}\n" > "src/main.$LANGUAGE"
    echo -e "bin\nobj/\n" >> .gitignore
    git add src/main.$LANGUAGE
    git commit -m "project init"
    cp $TEMPLATE/$LANGUAGE ./Makefile
    git add Makefile 
    git commit -m "Makefile"

# Lua
elif [ "$LANGUAGE" = "lua" ]; then
    mkdir -p "lua/$TITLE"
    touch "lua/$TITLE/init.lua"
    echo -e "[format]\nindent = 4\nline_width = 100\nquote_style = "Auto"" > stylua.toml
    git add -A && git commit -m "project init"

# Python
elif [ "$LANGUAGE" = "py" ]; then
    python3 -m venv ./.venv
    echo -e "\n.venv/" >> .gitignore
    echo -e "\n# $TITLE\n\ndef main():\n\tpass\n\nif __name__ == \"__main__\":
    main()\n" > main.py

# Rust
elif [ "$LANGUAGE" = "rs" ]; then
    cargo init
    echo -e "Cargo.lock\n\ntarget/\n" >> .gitignore
    git add Cargo.toml src/main.rs 
    git commit -m "project init"

fi


# FLags Actions ---------------------------------------------------------------

# Check if the -g flag is present
contains_flag() {
    local flag="-$1"
    shift # Remove the first argument which is the flag we are checking for
    for arg in "$@"; do
        [[ "$arg" == "$flag" ]] && return 0
    done
    return 1
}

# Push to GitHub
# This step presumes a repo for this project has been already created on
# github. Else extent this portion to include gh-cli to create a repo from
# here as well.
# It is also presumed that the said repo is of the same name as $TITLE

if contains_flag "g" "$@"; then
    git remote add origin "git@github.com:$GIT_USER/$TITLE.git"
    git push -u origin main
fi


# Set up Tmuxifier Layout 

if contains_flag "t" "$@"; then
    # setting up basic template
    echo -e "session_root \"$(pwd)\"\n" > "$TITLE.session.sh"
    echo -e "if initialize_session \"$TITLE\"; then\n" >> "$TITLE.session.sh"
    echo -e "fi\n\nfinalize_and_go_to_session\n" >> "$TITLE.session.sh"

    $EDITOR "$TITLE.session.sh"
    git add "$TITLE.session.sh"
    git commit -m "tmuxifier layout"
    ln -s "$(pwd)/$TITLE.session.sh" $TMUXIFIER_LAYOUT
fi

