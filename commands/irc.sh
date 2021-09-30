ADMIN="mattf"
info="$(cat -)" # read piped stdin     
channel=$(echo "$info" | cut -d\  -f1) 
nick=$(echo "$info" | cut -d\  -f2)    

case "$1" in
  "admin")
    echo "|$ADMIN|"
  ;;
  "me")
    echo "|$nick|"
  ;;
  "channel")
    echo "|$channel|"
  ;;
  "join")
    echo "/join $2"
  ;;
  "nick")
    echo "/nick $2"
  ;;
  "msg")
    echo "/msg $2 ${@:3}"
  ;;
  "mode")
    echo "/mode $@"
  ;;
  "op")
    [[ "$nick" == "$ADMIN" ]] && echo "/mode $channel +o $2"
  ;;
  "help")
    echo "$nick: you can use join, nick and msg to do whatever you want with me ;)"
  ;;
esac
