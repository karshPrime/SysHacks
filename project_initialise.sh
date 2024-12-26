#!/usr/bin/env bash

# This script automates project setup tasks, including directory creation, Git
# initialisation, README file generation and commit, language-specific file 
# setup, and .gitignore configuration. 

# Configs
export GIT_USER="karshPrime"
LICENSE="$HOME/Projects/LICENSE"
SCRIPTS="$HOME/Projects/SysHacks/pinit-templates"

# Project Description
LANGUAGE="${1##*.}"
export PROJECT_TITLE="${1%.*}"

echo "Initializing Project at $(pwd)/$PROJECT_TITLE"

# Initialise Project
mkdir "$PROJECT_TITLE"
cd "$PROJECT_TITLE"
cp $LICENSE .
echo -e "# $PROJECT_TITLE\n\n" > README.md

# Initialise Git
git init --quiet
git remote add origin "git@github.com:$GIT_USER/$PROJECT_TITLE.git"
echo -e "\n# .gitignore\n\n**/.DS_Store\n**/todo" > .gitignore

if [ -f "${SCRIPTS}/${LANGUAGE}.sh" ]; then
    "${SCRIPTS}/${LANGUAGE}.sh"
else
    echo "Template for $LANGUAGE not found."
fi

# Commit Template
git add -A
git commit -m "init: project"

