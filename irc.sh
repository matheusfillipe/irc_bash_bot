#!/usr/bin/env bash
source ./config.sh

mainloop () {
  echo "NICK ${NAME}"
  echo "USER ${NAME} * * : ${NAME}"
  sleep 3
  while sleep ${PING}; do echo PING :${RANDOM}; done &
  echo "JOIN ${CHAN}"
  echo "PRIVMSG ${CHAN} :Hi, I am a bash bot!"
  O_CHAN=$CHAN

	while read line; do
		UNIX=$(echo "${line}" | tr -d '\r')
		META=$(echo "${UNIX}" | cut -d':' -f2 )
		TEXT=$(echo "${UNIX}" | cut -d':' -f3-)
		CHAN=$(echo "${META}" | cut -d' ' -f3)
		WHO=$( echo "${META}" | cut -d'!' -f1)
		case "$UNIX" in
		*" PRIVMSG ${CHAN} :${PREF}"*)
      CMD=${TEXT%% *}
      CMD=${CMD/"${PREF}"}
      TEXT=${TEXT/"${PREF}${CMD} "}
      read -ra args <<< "$TEXT"
      OUT=""
      FILE=""
      [[ -f "./commands/$CMD" ]] && FILE="./commands/$CMD" 
      [[ -f "./commands/$CMD.sh" ]] && FILE="./commands/$CMD.sh" 
      [ -n "$FILE" ] && OUT=$(echo "$CHAN $WHO" | bash "$FILE" ${args[@]})

      if [ -n "$OUT" ]
      then
        while read -r line
        do
          if [[ $line == /* ]]
          then
            args="$(echo ${line} | cut -d' ' -f 2-)"
            case "${line^^}" in
              "/JOIN "*)
                echo "JOIN $args"; 
              ;;
              "/MSG "*)
                echo "PRIVMSG $(echo $args | cut -d\  -f1) :$(echo $args | cut -d\  -f 2-)";
              ;;
              "/NICK "*)
                echo "NICK $args";
              ;;
            esac
          else
            echo "PRIVMSG ${CHAN} :${line}"; 
          fi
        done < <(echo "$OUT")
      fi
			;;

		*" PRIVMSG ${NAME} :"*)
			echo "PRIVMSG ${WHO} :I am in: '${O_CHAN}', as of $(date)"
			;;
		*" INVITE ${NAME}"*)
      [[ "$WHO" == "$ADMIN" ]] && echo "JOIN ${UNIX##* }"
			;;
		*" KICK "*" ${NAME} "*)
			echo "JOIN ${CHAN}"
			echo "PRIVMSG ${CHAN} :Hey ${WHO} ! What does '${TEXT}' mean?!"
			echo "PART ${CHAN} :BOT RAGE QUIT"
			;;
		*)
			test -n "${LOGTO}" && echo "PRIVMSG ${LOGTO} : ${UNIX}"
			;;
		esac
	done
}


tee /dev/stderr | mainloop | tee /dev/stderr

