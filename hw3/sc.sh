#!/usr/bin/bash

# checking dependencies
DIALOG_INSTALLED=$(dpkg -l | cut -d " " -f 3 | grep "^dialog")
WHOIS_INSTALLED=$(dpkg -l | cut -d " " -f 3 | grep "^whois")

if [[ -z "$DIALOG_INSTALLED" ]]; then
  sudo apt install -yqq dialog &>/dev/null
fi

if [[ -z "$WHOIS_INSTALLED" ]]; then
  sudo apt install -yqq whois &>/dev/null
fi

# define variables
PROCESS_PID=$(dialog --inputbox "Enter PID or Process Name: " 10 40 --keep-tite 3>&1 1>&2 2>&3 3>&-)
PROCESS_PID="${PROCESS_PID,,}"
# exit if process/pid is not provided
if [[ -z "$PROCESS_PID" ]]; then
  dialog --title "Invalid arguments" --msgbox "Process/PID not provided" 10 40 --keep-tite
  exit
fi

STATE=$(dialog --inputbox "Enter connection state: " 10 40 --keep-tite 3>&1 1>&2 2>&3 3>&-)
STATE="${STATE^^}"

LINES_COUNT=$(dialog --inputbox "Enter lines count: " 10 40 5 --keep-tite 3>&1 1>&2 2>&3 3>&-)

# trying to find given process/pid
PARSING_RESULTS=$(sudo netstat -tunapl | awk -v process_pid="$PROCESS_PID" -v state="$STATE" '$0 ~ process_pid && $0 ~ state {print $5}')

if [[ -z "$PARSING_RESULTS" ]]; then
  dialog --title "No process found" --msgbox "No results found by given process/pid" 10 40 --keep-tite
  exit
fi

# get rid of ports and non-uniq addresses
IP_LIST=$(cut -d: -f 1 <<<"$PARSING_RESULTS" | sort -u | tail -n "$LINES_COUNT")

RESULTS=()

# iterating though the ip list
while read -r IP; do
  OUTPUT=$(whois "$IP" | awk -v ip="$IP" -F ':' '/^Organization/ {print ip $2}')
  if [[ -n "$OUTPUT" ]]; then
    RESULTS+=("$OUTPUT")
  fi
done <<<"$IP_LIST"

RESULTS_WITH_NEWLINES=$(printf '%s\n' "${RESULTS[@]}")
dialog --title "Whois results" --msgbox "$RESULTS_WITH_NEWLINES" 20 60 --keep-tite
