#!/bin/bash

if [ -z "$DEST" ]; then
   echo "DEST is not configured"
   exit 1
fi

if [ -z "$OPTIONS" ]; then
   OPTIONS="-v3"
fi

dir="$(dirname $0)"

export last_filename=/tmp/last

while :; do
	if [ -z "$RTCWAKE_HOST" ]; then
	   today="$(date -I)"
	   last="$(cat $last_filename)"
	   if [ "$today" = "$last" ]; then
		 sleep 3600
		 continue
	   fi

	   $dir/backup-logic.sh	   
	else
	   echo "RTC mode"
	   while :; do
	      if ssh "$RTCWAKE_HOST" id; then
		    break
		  fi
		  sleep 60
	   done
	   echo "RTC host is up!"
	   
	   $dir/backup-logic.sh
	   
	   # seconds until next midnight:
	   sleep_sec="$(($(date -d 23:59:59 +%s) - $(date +%s) + 1))"
	   
	   if [ ! -f /tmp/do_not_trigger_standby ]; then
		# put remote host asleep
		ssh "$RTCWAKE_HOST" rtcwake -m mem -s "$sleep_sec" &
	   else
		echo "NOT triggering standby"
	   fi
	   
	   # and some local sleep
	   sleep "$sleep_sec"
	fi
done

# while :; do
# ntpdate
# iwconfig
# openvpn
# ping $LISTEN_PORT
# sleep mode: https://unix.stackexchange.com/questions/692147/how-can-i-suspendhibernate-for-certain-time
# done
