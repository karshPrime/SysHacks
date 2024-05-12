#!/usr/bin/env bash

# The purpose of this file is to prevent from polluting any working directory with test directories.
# It integrates with my project init script to create temporary testing dirs with dev template
# setup within /tmp/

# Path for project_initialise script. Replace with "mkdir" to just create new directory within tmp
PROJ_INIT="$HOME/Projects/SysHacks/project_initialise.sh"

# Find the last test directory
highest=$(find /tmp/ -maxdepth 1 -type d -name "test*" | grep -o '[0-9]*$' | sort -n | tail -1)

# If no directory found, set the highest to 0
if [ -z "$highest" ]; then
    highest=0
fi 

# Increment the highest directory number
next=$((highest + 1))

# Trigger project init script 
if [ -n "$1" ]; then
    $PROJ_INIT "test${next}.$1"
    mv "./test${next}" /tmp/.   # moving dir to /tmp/
else
    mkdir "/tmp/test${next}"
fi

cd "/tmp/test${next}/"

