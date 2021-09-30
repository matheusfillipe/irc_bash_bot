# Irc Bash bot
A simple to add commands, irc bot written fully in bash using netcat for handling the connection. This is a proof of concept and might have security flaws.

# Usage 
## Installation

Install netcat and make sure you have the `-v` and `-c` options enabled on it. On some distros this is called `ncat`:

``` sh
sudo apt install ncat
```

Edit `config.sh` with your bot's nickname, irc hort, port, and optionally the netcat command. 

    - NC_COMMAND: Netcat command. Usually ncat is fine.
    - HOST: Irc server hostname
    - PORT: Irc server port
    - NAME: Nickname and Username of the irc bot
    - CHAN: Channel the bot will join (it will join any other channel when it receives invitation)
    - PREF: Prefix the bot commands should begin with. Usually something like '!', '=', '$', '@' etc...
    - PING: Ping period in seconds. 10 is usually fine.
    
## Defining new commands

Anything inside the `commands` folder without extension or with the extension `.sh` will be a bot command, matching the file name. It does not need execution permissions. 

For example, create a shell script named `command.sh` inside the `commands` folder. You can now run `=command argument1 argument2` on your bot (without having to restart it even!). Inside `command.sh` you can address "argument1" with `$1` and "argument2" with `$2`. Whatever this script's stdout is it's returned to the irc channel the command was called from. You can send multiple lines.

## Read channel and nickname

Channel and nickname information are relayed by stdin. Basically `"$channel $nick"` (notice the space in between) is piped to every command script. Check out echo.sh to know how to handle this. Also notice that if you are creating commands by simply copying or symlinking existing commands into `commands/` and this command reads stin you will probably get some undesired behaviour, so always create a script yourself inside `commands/` and call whatever you want like `some_command $@`.

Example:
```shell
info="$(cat -)" # read piped stdin
channel=$(echo "$info" | cut -d\  -f1) 
nick=$(echo "$info" | cut -d\  -f2) 
```

## Use other common irc commands

If your command script has a line starting with "/" on its stdout it will be read as an irc command like on most irc clients. The currently supported commands are `/nick` `/msg` (for private or channel messages, like sending to another channel) and `/join`. These commands are case insensitive.

Example:
```shell
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
  "help")
    echo "$nick: you can use join, nick and msg to do whatever you want with me ;)"
  ;;
esac
```

