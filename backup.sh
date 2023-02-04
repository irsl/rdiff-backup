#!/bin/bash

if [ -z "$DEST" ]; then
   echo "DEST is not configured"
   exit 1
fi

if [ -z "$OPTIONS" ]; then
   OPTIONS="-v3"
fi

last_filename=/tmp/last

while :; do
   today="$(date -I)"
   last="$(cat $last_filename)"
   if [ "$today" = "$last" ]; then
     sleep 3600
	 continue
   fi
   
   echo "$(date -Is) --------------------------------------------- begin"
   
   echo "$today" > "$last_filename"
   if eval "rdiff-backup $OPTIONS /data/ \"$DEST\""; then
      # indicate success
	  status="success"
   else
      # indicate failure
	  status="FAILURE"
   fi

   if [ -n "$BACKUP_INDICATE_DIR" ]; then
      rmdir "$BACKUP_INDICATE_DIR"/b-*
	  mkdir "$BACKUP_INDICATE_DIR"/b-$status-$today
   fi
   
   if [ -n "$BACKUP_FCM_AUTH" ]; then
		curl -X POST --header "Authorization: key=$BACKUP_FCM_AUTH"     --Header "Content-Type: application/json"     https://fcm.googleapis.com/fcm/send     -d "{\"to\":\"$BACKUP_FCM_TARGET\",\"notification\":{\"title\":\"Geza backup\",\"body\":\"$status $today\"}}"  
   fi

   if [ -n "$BACKUP_URL_NOTIFICATION" ]; then        
		curl "$BACKUP_URL_NOTIFICATION$status+$today"
   fi
   
   rdiff-backup --force --remove-older-than 4W "$DEST"
   
   echo "$(date -Is) --------------------------------------------- ready: $status"
   echo
done
