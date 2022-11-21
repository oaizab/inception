FROM debian:buster

RUN apt update && apt upgrade -y && apt install -y curl

RUN curl -L https://github.com/google/cadvisor/releases/download/v0.37.5/cadvisor -o /usr/bin/cadvisor --silent 

RUN chmod +x /usr/bin/cadvisor

ENTRYPOINT [ "/usr/bin/cadvisor", "-logtostderr" ]
