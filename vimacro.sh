#!/bin/bash

# check arguments or piped input
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <input> <vim_commands>"
    echo "Or use with piped input: echo -e \"one\ntwo\" | $0 \"normal d0gUU\""
    exit 1
fi

# if input is from stdin or arguments
if [ -t 0 ]; then
    # no piped input
    # use the first argument as input and the second as vim commands
    input="$1"
    vi_commands="norm $2"
else
    # use piped input
    input=$(cat)
    vi_commands="norm $1"
fi

# process each line individually with Vim commands
output=$(echo "$input" | awk -v vim_cmd="$vim_commands" '{
cmd = "echo " $0 " | vi -E -s -u NONE -c \"" vi_cmd "\" -c \"wq! /dev/stdout\" /dev/stdin"
cmd | getline result
close(cmd)
print result
}')

# print result
echo "$output"

