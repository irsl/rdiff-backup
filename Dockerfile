FROM alpine

RUN apk add python3 rdiff-backup bash openssh-client-default curl
ADD backup.sh /opt
ENTRYPOINT /opt/backup.sh
