FROM ubuntu:latest AS build
WORKDIR /var/build
RUN apt-get update
RUN apt install -y jq netcat iproute2 iputils-ping telnet curl openssl wireshark xterm xauth traceroute vim tcpdump net-tools openssh-client openssh-server
RUN systemctl enable ssh
#RUN mkdir -p /tmp/.X11-unix
RUN mkdir -p /private
RUN ln -s /tmp /private/tmp
RUN echo 'export PS1="🐳 \e[0;34m\${PROMPT}\e[0m \w # "' >> ~/.profile
# CMD [ "bash", "-l"]
# ENTRYPOINT [ "yarn", "e2e:CI" ] 
