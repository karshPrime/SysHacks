#!/usr/bin/env bash

SEDEDIT="/tmp/edit_$(basename $2).tmp"

[ -n "$1" ] && [ -n "$2" ] || {
	echo "usage: rp [regular expression] file"
	exit 1
}

sed "$1" "$2" > $SEDEDIT || exit 1
cat $SEDEDIT

echo -e "\033[34m"
read -p "Do you wish to proceed [Y/n] " response

if [[ "$response" == "n" ]]; then
    echo -e "\033[31mAborting.\033[0m"
	rm $SEDEDIT
    exit 1
else
    echo -e "\033[33mFinalising the changes...\033[0m"
	mv $SEDEDIT $2
fi

