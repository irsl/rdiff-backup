#!/bin/bash

if [ -z "$DEST" ]; then
   echo "DEST is not configured"
   exit 1
fi

last_filename=/tmp/last

while :; do
   today="$(date -I)"
   last="$(cat $last_filename)"
   if [ "$today" = "$last" ]; then
     sleep 3600
	 continue
   fi
   
   echo "$today" > "$last_filename"
   if rdiff-backup /src/ "$DEST"; then
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
   
   rdiff-backup --remove-older-than 4W "$DEST"
done
