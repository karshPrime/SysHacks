
#!/usr/bin/env bash

RENAME_BUFFER="/tmp/RENAME_BUFFER"
echo "DONT DELETE ANY FILES IN HERE" > "$RENAME_BUFFER" || {
    echo "Failed to create $RENAME_BUFFER";
    exit 1;
}

ORIGINAL_NAMES=()

if [ $# -eq 0 ]; then
    IFS=$'\n'
    for arg in $(ls); do
        echo "$arg" >> "$RENAME_BUFFER"
        ORIGINAL_NAMES+=("$arg")
    done
    unset IFS
else
    for arg in "$@"; do
        clean_arg="${arg#./}"
        echo "$clean_arg" >> "$RENAME_BUFFER"
        ORIGINAL_NAMES+=("$clean_arg")
    done
fi

LINES_BEFORE=$(wc -l < "$RENAME_BUFFER" | tr -d ' ')

$EDITOR "$RENAME_BUFFER"

LINES_AFTER=$(wc -l < "$RENAME_BUFFER" | tr -d ' ')

if [ "$LINES_BEFORE" != "$LINES_AFTER" ]; then
    echo -e "\033[31mError:\033[0m Name list mismatch"
    rm "$RENAME_BUFFER"
    exit 1
fi

for (( i=2; i<=$LINES_BEFORE; i++ )); do
    original_name="${ORIGINAL_NAMES[$i-2]}"
    new_name=$(awk "NR==$i" "$RENAME_BUFFER")

    # do nothing if filename isn't changed
    if [[ "$original_name" == "$new_name" ]]; then
        continue

    # if the file extensions are the same
elif [[ "${original_name##*.}" == "${new_name##*.}" ||
    "$new_name" == "${new_name%.*}" ||
    "$original_name" == "${original_name%.*}" ]];
then
    echo -e "\033[33mRenaming \033[36m$original_name \033[33mto \033[0m$new_name"
    mv "./$original_name" "./$new_name"

    # check if ffmpeg is installed
elif ! command -v ffmpeg &> /dev/null; then
    echo -e "\033[31mError:\033[0m Install ffmpeg to perform filetype conversions."
    echo -e "\033[33mRenaming \033[36m$original_name \033[33mto \033[0m${new_name%.*}.${original_name##*.}"
    mv "./$original_name" "./${new_name%.*}.${original_name##*.}"

    # convert file
else
    echo -e "\033[33mConverting \033[36m$original_name \033[33mto \033[0m$new_name"
    ffmpeg -i "$original_name" "$new_name" -loglevel warning

        # check if ffmpeg was successful
        if [ $? -eq 0 ]; then
            rm "$original_name"
        else
            echo -e "\033[31mError:\033[0m Conversion failed for $original_name"
        fi
    fi
done

rm "$RENAME_BUFFER"

