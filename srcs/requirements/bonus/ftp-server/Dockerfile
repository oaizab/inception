FROM alpine:3.13

RUN apk update && apk upgrade && apk add --no-cache vsftpd

COPY config/vsftpd.conf /tmp/vsftpd.conf
COPY config/configure.sh /tmp/configure.sh

ENTRYPOINT [ "sh", "/tmp/configure.sh" ]
