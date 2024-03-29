#!/bin/bash

today="$(date -I)"
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
