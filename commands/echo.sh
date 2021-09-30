#!/usr/bin/env bash
info="$(cat -)" # read piped stdin
channel=$(echo "$info" | cut -d\  -f1) 
nick=$(echo "$info" | cut -d\  -f2) 
printf "$nick from $channel: "
echo "$@"
