#!/usr/bin/env bash

# Get the base project directory
base_dir=$(pwd)

# Recursively search for code files with specified extensions and append them to buffer
function process_directory {
    local dir="$1"
    shift
    local extensions=("$@")

    for filename in "$dir"/*; do
        if [ -d "$filename" ]; then
            process_directory "$filename" "${extensions[@]}"

        else
            for ext in "${extensions[@]}"; do
                if [ "${filename##*.}" = "$ext" ]; then
                    # get relative path from base project directory
                    relative_path=${filename#$base_dir/}
                    echo "### $relative_path ======" >> catbuffer.txt

                    cat "$filename" >> catbuffer.txt
                    echo >> catbuffer.txt

                    break
                fi
            done
        fi
    done
}

# Check for correct number of arguments
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <file_extension1> [<file_extension2> ...]"
    exit 1
fi

# Create an empty buffer file
> catbuffer.txt

# Start processing from the current directory
process_directory "$(pwd)" "$@"

# Put content of the buffer file to clipboard
wl-copy < catbuffer.txt

# Delete the buffer file
rm catbuffer.txt

echo -e "All \e[33m$@ \e[0mfiles content have been concatenated to clipboard"

