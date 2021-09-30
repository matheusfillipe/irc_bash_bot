nick=$(cat - | cut -d\  -f2) 
case "$1" in
  "join")
    echo "/join $2"
  ;;
  "nick")
    echo "/nick $2"
  ;;
  "msg")
    echo "/msg $2 ${@:3}"
  ;;
  "mode") # not implemented
    echo "/mode whatever"
  ;;
  "help")
    echo "$nick: you can use join, nick and msg to do whatever you want with me ;)"
  ;;
esac
