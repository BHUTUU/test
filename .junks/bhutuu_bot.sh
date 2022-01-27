#!/usr/bin/env bash
#CORE Authored by: @Pero_Sar1111
#Post authored by Suman Kumar ~BHUTUU
# shellcheck disable=SC2207
# shellcheck source=/dev/null

R="\e[1;31m"
G="\e[1;32m"
Y="\e[1;33m"
RT="\e[0m"
if [[ ! -f "config.json" ]]; then
read -p "Enter your BOT-TOKEN: " tok
read -p "Enter your chat id as owner: " own
cat <<- COT > config.json
{
  "TOKEN": "${tok}",
  "OWNERID": "${own}"
}
COT
fi
TOKEN=$(cat config.json | jq -r .TOKEN)
OWNERID=$(cat config.json | jq -r .OWNERID)
TGAPI="https://api.telegram.org/bot${TOKEN}"

# Functions
debug() {
	echo -e "${G}[DEBUG]${RT} ""$1"""
}
warn() {
	echo -e "${Y}[WARN]${RT} ""$1"""
}
err() {
	echo -e "${R}[ERROR]${RT} ""$1"""
}
arg() {
	if [[ -z "${args[*]}" ]]; then
		sendmsg "A required arg was missing!"
		return 1
	elif [[ "$cmd" == *"trml"* ]]; then
	:
	elif [[ "$cmd" == *"rm"* ]]; then
                if admeme; then
                	:
                else
			sendmsg "Dont be smart boi... :)"
			return 1 || false
                fi
        else
		true
	fi
}
sendmsg() {
	curl -sX POST """${TGAPI}""/sendMessage" \
		-d "chat_id=$chat" \
		-d "parse_mode=html" \
		-d "disable_web_page_preview=true" \
		-d "reply_to_message_id=$msgid" \
		-d "text=$1"
}

checkupd() {
	if grep -Fxq "$upid" update.id; then
		true
	else
		false
	fi
}
peace() {
	echo "Recieved CTRL+C, Exitting peacefully.."
	exit 0
}
admeme() {
	case "$fromid" in
	"$OWNERID") true ;;
	*) false ;;
	esac
}
fetch() {
args="$@"
PWD=$(pwd)
op_sys=$(uname -o)
kern=$(uname -r)
arch_sys=$(uname -m)
krname=$(uname)
dev_brand(){
printf "`getprop ro.product.manufacturer` %s"
printf "`getprop ro.product.model` %s"
}
Battery=$(termux-battery-status | jq -r .percentage)
charging=$(termux-battery-status | jq -r .status)
plug=$(termux-battery-status|jq -r .plugged)
package() {
apt list --installed 2>/dev/null | wc -l
}

eq() {
  case $1 in
  $2) ;;
  *) return 1 ;;
  esac
}

while read -r line; do
eq "$line" 'MemTotal*' && set -- $line && break
done </proc/meminfo

r1="$(($2/1000))"
ovrm=$(bc <<< "scale=2; $r1 / 1000")
r2=$(free -m | sed -n 's/^Mem:\s\+[0-9]\+\s\+\([0-9]\+\)\s.\+/\1/p')
memory=$(bc <<< "scale=2; $r2 /1000")
echo -e "${R0}"
strused=$(df -h /sdcard | grep "/" | awk '{print $3}')
stravai=$(df -h /sdcard | grep "/" | awk '{print $2}')

#<<======program========>>>
if [[ ${args,,} == 'battery' ]]; then
fetch="""
Battery : ${Battery}% -- ${charging} -- ${plug}
"""
else
fetch="""
Device  : $(dev_brand)
OS      : ${op_sys}
Packages: $(package)
Shell   : $(basename $SHELL)
UpTime  : $(uptime -p | sed 's/up//')
Ram     : ${memory}GB / ${ovrm}GB
Arch    : ${arch_sys}
Kernel  : ${kern}
Storage : ${strused}B used from ${stravai}B
Battery : ${Battery}% -- ${charging} -- ${plug}
"""
fi
}
help="""
=============================
command             usage
----------------------------------------------------------
/help     |- for this help menu.
/say      |- only for BHUTUU 👻.
/fetch   |- To fetch sysinfo.
/battery|- To fetch battery.
______________________________________
"""
pycmd() {
cat <<- CONF > pyscript.py
#!/bin/python
${args[*]}
CONF
python pyscript.py
}

# trap
trap peace INT

while true; do
	resp=$(curl -sX POST "${TGAPI}/getUpdates" -d "offset=-1")
	upid=$(jq .result[0].update_id <<<"$resp")
	if checkupd; then
		continue
	else
		echo "$upid" >>update.id
	fi
	msg=$(jq -r .result[0].message.text <<<"$resp")
	msgid=$(jq -r .result[0].message.message_id <<<"$resp")
	name=$(jq -r .result[0].message.from.username <<<"$resp")
  if [[ $name == null ]]; then
		name=$(jq -r .result[0].message.from.first_name <<<"$resp")
	fi
	args=($(cut -sd" " -f2- <<<"$msg"))
	chat=$(jq -r .result[0].message.chat.id <<<"$resp")
	fromid=$(jq .result[0].message.from.id <<<"$resp")
	cmd=$(awk '{print $1}' <<<"$msg")
	case "${cmd,,}" in
	"/start"|"/start@bhutuu_bot")
		sendmsg "hello there!" #> /dev/null 2>&1
		;;
	"/sh"|"/sh@bhutuu_bot")
#		if admeme; then
		if [[ ${msg} == *'rm'* || ${msg} == *'ls'* ]]; then
			if admeme; then
				arg || continue
	                        out=$(eval "${args[*]}")
	                        sendmsg "<code>$out</code>"
			else
	                        sendmsg "Don't be smart lol :)"
			fi
		else
			arg || continue
			out=$(eval "${args[*]}")
			sendmsg "<code>$out</code>" #> /dev/null 2>&1
		fi
#		else
#			sendmsg "You're not allowed to use this."
#		fi
		;;
	"/py"|"/py@bhutuu_bot")
		if [[ ${msg} == *'rm'* ]]; then
			sendmsg "Don't be smart lol :)"
		else
			arg || continue
			out=$(pycmd)
			sendmsg "<code>$out</code>"
		fi
		;;
	"/battery"|"/battery@bhutuu_bot")
		fetch battery
		sendmsg "$fetch" #> /dev/null 2>&1
		;;
	"/fetch"|"/fetch@bhutuu_bot")
		fetch
		sendmsg "$fetch" #> /dev/null 2>&1
		;;
	"/say"|"/say@bhutuu_bot")
		sendmsg "I love you 😔" #> /dev/null 2>&1
		;;
	"/help"|"/help@bhutuu_bot")
		sendmsg "$help" #> /dev/null 2>&1
		;;
#	"/trhi"|"/trhi@bhutuu_bot")
#		arg || continue
#		out=$(python3 trans.py -H "${args[*]}" -P hindi)
#		sendmsg "<code>$out</code>"
#		;;
#	"/tren"|"/tren@bhutuu_bot")
#                arg || continue
#                out=$(python3 trans.py -H "${args[*]}" -P english)
#                sendmsg "<code>$out</code>"
#                ;;
#	"/trml"|"/trml@bhutuu_bot")
#                arg || continue
#                out=$(python3 trans.py -H "${args[*]}" -P malayalam)
#                sendmsg "<code>$out</code>"
#                ;;
#	"/trbn"|"/trbn@bhutuu_bot")
#                arg || continue
#                out=$(python3 trans.py -H "${args[*]}" -P bengali)
#                sendmsg "<code>$out</code>"
#                ;;
#	"/trne"|"/trne@bhutuu_bot")
#                arg || continue
#                out=$(python3 trans.py -H "${args[*]}" -P nepali)
#                sendmsg "<code>$out</code>"
#                ;;
	esac
	case "${msg,,}" in
	*"how are you"*)
		sendmsg "i am fine @${name}! what about you?" #> /dev/null 2>&1
		;;
	*"good morning"*|"gm"*)
		sendmsg "Good morning @${name} :)" #> /dev/null 2>&1
		;;
	*"good evening"*|"ge"*)
		sendmsg "Good eveninig @${name} :)"
		;;
	*"good night"*|"gn"*)
		sendmsg "Good night @${name} :)"
		;;
#	*"suman_bhutuu"*)
#		sendmsg "I will not respond anywhere for one day since i am doing my assignnents and practical of college. Sorry for inconvenience. See you soon!" ;;
	esac
done
