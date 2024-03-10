#!/bin/bash

ps --no-headers -eo pid,%mem,rss,comm --sort=-rss | head -n 15 | awk '{printf "%d\t%.1f%s\t%s\n", $1, $2, ($3 >= 2^30 ? "G" : ($3 >= 2^20 ? "M" : "K")), $4}'
