#!/usr/bin/env bash
source ./config.sh

mainloop () {
  echo "NICK ${NAME}"
  echo "USER ${NAME} * * : ${NAME}"
  sleep 3
  while sleep ${PING}; do echo PING :${RANDOM}; done &
  echo "JOIN ${CHAN}"
  echo "PRIVMSG ${CHAN} :Hi, I am a bash bot!"

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
      TEXT=$(printf '%q' "$TEXT" | sed 's/\\ / /g')
      OUT=""
      FILE=""
      [[ -f "./commands/$CMD" ]] && FILE="./commands/$CMD" 
      [[ -f "./commands/$CMD.sh" ]] && FILE="./commands/$CMD.sh" 
      [ -n "$FILE" ] && OUT=$(bash "$FILE" $TEXT)
      [ -n "$OUT" ] && echo "PRIVMSG ${CHAN} :${OUT}"
			;;
		*" PRIVMSG ${NAME} :"*)
			echo "PRIVMSG ${WHO} :I am in: '${CHAN}', as of $(date)"
			;;
		*" INVITE ${NAME}"*)
			echo "JOIN ${TEXT}"
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

