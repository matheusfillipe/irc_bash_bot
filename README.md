# Irc Bash bot
A simple to add commands, irc bot written fully in bash using netcat for handling the connection. This is a proof of concept and might have security flaws.

# Usage 
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
    
Anything inside the `commands` folder without extension or with the extension `.sh` will be a bot command, matching the file name. It does not need execution permissions. 

For example, create a shell script named `command.sh` inside the `commands` folder. You can now run `=command argument1 argument2` on your bot (without having to restart it even!). Inside `command.sh` you can address "argument1" with `$1` and "argument2" with `$2`. Whatever this script's stdout is it's returned to the irc channel the command was called from. You can send multiple lines.
