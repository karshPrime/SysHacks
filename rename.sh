#!/usr/bin/env bash

if [ $# -eq 0 ]; then
    echo -e "\033[31mError: \033[0mNo arguments provided."
    exit 1
fi

echo "DONT DELETE ANY FILES IN HERE" > ./~RENAME_BUFFER
for arg in "$@"; do
    echo "$arg" >> ./~RENAME_BUFFER
done

LINES_BEFORE=$(wc -l < ./~RENAME_BUFFER | tr -d ' ')

$EDITOR ./~RENAME_BUFFER

LINES_AFTER=$(wc -l < ./~RENAME_BUFFER | tr -d ' ')

if [ "$LINES_BEFORE" != "$LINES_AFTER" ]; then
    echo -e "\033[31mError:\033[0m Name list mismatch"
    rm ./~RENAME_BUFFER
    exit 1
fi

original_names=("$@")

for (( i=2; i<=$LINES_BEFORE; i++ )); do
    original_name="${original_names[$((i-2))]}"
    new_name=$(awk "NR==$i" ./~RENAME_BUFFER)

    # do nothing if filename isn't changed
    if [[ "$original_name" == "$new_name" ]]; then
        continue

    # if the file extensions are the same
    elif [[ "${original_name##*.}" == "${new_name##*.}" || "$new_name" == ".${new_name##*.}" ]]; then
        echo -e "\033[33mrenaming \033[36m$original_name \033[33mto \033[0m$new_name"
        mv "$original_name" "$new_name"

    # check if ffmpeg is installed
    elif ! command -v ffmpeg &> /dev/null; then
        echo -e "\033[31mError: \033[0mInstall ffmpeg to perform filetype conversions."
        mv "$original_name" "$new_name"

    # convert file
    else
        echo -e "\033[33mconverting \033[36m$original_name \033[33mto \033[0m$new_name"
        ffmpeg -i "$original_name" "$new_name"

        # Check if ffmpeg was successful
        if [ $? -eq 0 ]; then
            rm "$original_name"
        else
            echo -e "\033[31mError: \033[0mConversion failed for $original_name"
        fi
    fi
done

rm ./~RENAME_BUFFER

