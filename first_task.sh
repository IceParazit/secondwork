#!/bin/bash


tmp_file=$(mktemp)

grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b"  /home/lin-admin/test.txt | sort | uniq -c | sort -nr > "$tmp_file"

while read -r count ip; do
    if [ "$count" -gt 10 ]; then
        echo "Блокировка IP $ip (попыток: $count)"
        sudo iptables -A INPUT -s "$ip" -j DROP
    fi
done < "$tmp_file"


rm "$tmp_file"
