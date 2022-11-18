FROM alpine:3.15

RUN apk update && apk upgrade && apk add --no-cache mariadb mariadb-client

COPY config/config.sh /tmp/config.sh

ENTRYPOINT [ "sh", "/tmp/config.sh" ]
