FROM ubuntu:latest AS build
WORKDIR /var/build
RUN apt-get update
RUN apt install -y jq netcat iproute2 iputils-ping telnet curl openssl wireshark xterm xauth traceroute vim tcpdump net-tools openssh-client openssh-server
RUN mkdir /root/.ssh
RUN ssh-keygen -b 2048 -t rsa -f /root/.ssh/id_rsa -q
RUN cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys
RUN echo "PermitRootLogin without-password" >> /etc/ssh/sshd_config


RUN service ssh start
#RUN mkdir -p /tmp/.X11-unix
RUN mkdir -p /private
RUN ln -s /tmp /private/tmp
RUN echo 'export PS1="🐳 \e[0;34m\${PROMPT}\e[0m \w # "' >> ~/.profile
RUN echo 'export PS1="🐳 \e[0;34m\${PROMPT}\e[0m \w # "' >> /root/.profile
# CMD [ "bash", "-l"]
# ENTRYPOINT [ "yarn", "e2e:CI" ] 
