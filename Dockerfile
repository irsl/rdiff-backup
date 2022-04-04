FROM alpine

RUN apk add python3 rdiff-backup bash
ADD backup.sh /opt
ENTRYPOINT /opt/backup.sh
