FROM alpine:latest

RUN apk add --no-cache rsync

COPY load.sh /usr/local/bin/load.sh

RUN chmod +x /usr/local/bin/load.sh

CMD ["/usr/local/bin/load.sh"]
