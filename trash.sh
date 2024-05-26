#!/usr/bin/env bash

# This script enhances file deletion safety by mimicking the behavior of the
# graphical environment's trash system directly from the terminal. Instead of
# permanently deleting files or directories, it moves them to the system's trash
# directory. The files can then be restored or permanently deleted later, based
# on user settings or manual intervention.

# To use this script as a safer alternative to the 'rm' command:
#   1. Make the script executable:
#       $ chmod +x /path/to/this_script.sh
#   2. Alias the 'rm' command to this script:
#       $ alias rm='/path/to/this_script.sh'

# Note:
# This script assumes compliance with the FreeDesktop.org Trash specification
# and should work across various desktop environments (DEs) such as GNOME, KDE,
# XFCE, and LXQt.

TRASH_DIR="$HOME/.Trash"

# Check if no arguments were given
if [ $# -eq 0 ]; then
    echo -e "\033[33mUsage: \033[31mtrash.sh \033[0m[file_or_directory ...]"
    exit 1
fi

# Move each argument
for item in "$@"; do
    # Check if the item exists
    if [ -e "$item" ]; then
        base_name=$(basename "$item")

        # Generate the new name with timestamp
        current_time=$(date "+%d-%m-%y_%H-%M-%S")
        new_name="${current_time}_${base_name}"

        mv "$item" "$TRASH_DIR/$new_name"
        echo -e "\033[31mDeleted \033[0m$item"
    else
        echo -e "\033[31mWarning: \033[33m'$item' \033[0mdoes not exist"
    fi
done

