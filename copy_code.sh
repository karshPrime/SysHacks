#!/bin/bash

copy_clipboard() {
    if command -v pbcopy >/dev/null 2>&1; then
        pbcopy
    elif command -v clip.exe >/dev/null 2>&1; then
        clip.exe
    elif command -v wl-copy >/dev/null 2>&1; then
        wl-copy
    elif command -v xclip >/dev/null 2>&1; then
        xclip -selection clipboard
    elif command -v xsel >/dev/null 2>&1; then
        xsel --clipboard --input
    elif command -v termux-clipboard-set >/dev/null 2>&1; then
        termux-clipboard-set
    else
        cat >/dev/null
        echo "copy_code: no clipboard utility found" >&2
        return 1
    fi
}

# Initialise arrays
DIRS=()        # For arguments that start with a dot
EXTENSIONS=()  # For arguments that do not start with a dot

# Temporary file buffer
CATBUFFER=$(mktemp)

# Loop through all arguments
for arg in "$@"; do
    if [[ $arg == .* ]]; then
        DIRS+=( "$arg" )
    else
        EXTENSIONS+=( "-iname" "*.$arg" "-o" )
    fi
done

if [ ${#DIRS[@]} -eq 0 ]; then
    DIRS+=( "." )
fi

# Loop through all directories
for dir in "${DIRS[@]}"; do
    # remove trailing '-o' if present
    if [ ${#EXTENSIONS[@]} -gt 0 ]; then
        if [ ${EXTENSIONS[${#EXTENSIONS[@]}-1]} = "-o" ]; then
            EXTENSIONS=("${EXTENSIONS[@]:0:${#EXTENSIONS[@]}-1}")
        fi

        # find files based on constructed conditions, excluding .git directory
        find "$dir" -type f          \
            \( "${EXTENSIONS[@]}" \) \
            -not -path './build/*'   \
            -not -path '*/.*'        \
            -exec sh -c              \
                'for file; do echo "======================[ $file ]======================" \
                >> "$0"; cat "$file" >> "$0"; done' "$CATBUFFER" {} +

    else
        find "$dir" -type f          \
            -not -path './build/*'   \
            -not -path '*/.*'        \
            -exec sh -c              \
                'for file; do echo "======================[ $file ]======================" \
                >> "$0"; cat "$file" >> "$0"; done' "$CATBUFFER" {} +
    fi
done

# Remove temporary file buffer
copy_clipboard < "$CATBUFFER"
rm "$CATBUFFER"

