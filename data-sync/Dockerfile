FROM alpine:latest

RUN apk add --no-cache rsync tzdata

COPY sync.sh /usr/local/bin/sync.sh

RUN chmod +x /usr/local/bin/sync.sh

CMD ["/usr/local/bin/sync.sh"]
