#!/usr/bin/env bash

# This script automates project setup tasks, including directory creation, Git
# initialisation, README file generation and commit, language-specific file 
# setup, and .gitignore configuration. 

# Project Description
LANGUAGE="${1#*.}"
TITLE="${1%%.*}"

# User Info
GIT_USER="karshPrime"


# Get Started -----------------------------------------------------------------
echo "Initializing Project at $(pwd)/$TITLE"

mkdir "$TITLE"
cd "$TITLE"

# Initialize git & Commit license
git init --quiet
cp ~/Projects/LICENSE .
git add LICENSE
git commit -m "Apache 2.0"

# Create todo & .gitignore
touch todo
echo -e ".gitignore\n\ntodo\n" > .gitignore

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
    touch main.go
    git add main.go go.mod
    git commit -m "project init"

# C/C++
elif [ "$LANGUAGE" = "c" ] || [ "$LANGUAGE" = "cpp" ]; then
    mkdir src obj bin
    touch Makefile "src/main.$LANGUAGE"
    echo -e "\nbin/\nobj/\n" >> .gitignore
    git add Makefile src/main.$LANGUAGE
    git commit -m "project init"

# Rust
elif [ "$LANGUAGE" = "rs" ]; then
    cargo init
    echo -e "Cargo.lock\n\ntarget/\n" >> .gitignore
    git add Cargo.toml src/main.rs 
    git commit -m "project init"
fi


# Push to GitHub -------------------------------------------------------------
# This step presumes a repo for this project has been already created on
# github. Else extent this portion to include gh-cli to create a repo from
# here as well.
# It is also presumed that the said repo is of the same name as $TITLE

git remote add origin "git@github.com:$GIT_USER/$TITLE.git"
git push -u origin master

