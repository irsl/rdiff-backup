FROM alpine

RUN apk add python3 rdiff-backup bash openssh-client-default
ADD backup.sh /opt
ENTRYPOINT /opt/backup.sh
