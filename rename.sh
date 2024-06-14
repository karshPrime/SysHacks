#!/usr/bin/env bash

if [ $# -eq 0 ]; then
    echo -e "\033[31mError: \033[0mNo arguments provided."
    exit 1
fi

echo "DONT DELETE ANY FILES IN HERE" > \~RENAME_BUFFER
echo "$@" | sed 's/ .\//\n.\//g' >> \~RENAME_BUFFER

LINES_BEFORE=$(wc -l < \~RENAME_BUFFER | tr -d ' ')

$EDITOR \~RENAME_BUFFER

LINES_AFTER=$(wc -l < \~RENAME_BUFFER | tr -d ' ')

if [ "$LINES_BEFORE" != "$LINES_AFTER" ]; then
    echo -e "\033[31mError:\033[0m Name list mismatch"
    rm \~RENAME_BUFFER
    exit 1
fi

original_names=("$@")

for i in $(seq 2 $LINES_BEFORE); do
    original_name=${original_names[$((i-2))]}
    new_name=$(awk "NR==$i" \~RENAME_BUFFER)

    if [[ $original_name = $new_name ]]; then
        continue;
    fi

    echo -e "\033[33mrenaming \033[36m$original_name \033[33mto \033[0m$new_name"
    mv "$original_name" "$new_name"
done

rm \~RENAME_BUFFER

