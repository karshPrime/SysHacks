#!/bin/env bash

BEFORE=$(free -h | grep Mem | awk '{print $2 "\t\t" $3 "\t\t\\e[1;33m" $4 "\t\t\\e[0;37m" $5 "\t\t\\e[1;31m" $6 "\t\t\\e[0;37m" $7}')

su -c "echo 1 >'/proc/sys/vm/drop_caches'"

AFTER=$(free -h | grep Mem | awk '{print $2 "\t\t" $3 "\t\t\\e[1;33m" $4 "\t\t\\e[0;37m" $5 "\t\t\\e[1;31m" $6 "\t\t\\e[0;37m" $7}')

echo -e " \e[1;37m        total\t\tused\t\tfree\t\tshared\t\tbuff/cache      available"
echo -e "Before:\e[0;37m  $BEFORE"
echo -e "\e[1;37mAfter :\e[0;37m  $AFTER"

