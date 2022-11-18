FROM alpine:3.15

RUN apk update && apk upgrade && apk add --no-cache nginx openssl

# configure ssl certificate
RUN mkdir /etc/nginx/ssl
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/nginx/ssl/oaizab.key \
	-out /etc/nginx/ssl/oaizab.crt \
	-subj "/C=MA/ST=Khouribga/L=Khouribga/O=1337 School/OU=oaizab/CN=oaizab"

# configure nginx
RUN mkdir -p /run/nginx
COPY config/nginx.conf /etc/nginx/nginx.conf

# start nginx
ENTRYPOINT ["nginx", "-g", "daemon off;"]
