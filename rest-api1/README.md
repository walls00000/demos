# Setup a client and server to enable and view tcp level analysis

## Server

In a separate terminal perform the following

```
source ./docker-run.sh
export PROMPT=server
run /bin/bash -l
```

setup a netcat listener to listen on the telnet port (23)

```
nc -l 23
```

## Hacker (White hat hacker)

In a separate terminal use ssh to login to the client and perform the following

```
source ./docker-run.sh
export PROMPT=hacker
run /bin/bash -l
```

Listen on an interface in promiscuous mode: "snoop on the wire" (on port 23)

```
tcpdump -i eth0 port 23 -w out.pcap
```

## Client

In a separate terminal perform the following

```
source ./docker-run.sh
export PROMPT=client
run /bin/bash -l
```

start up an ssh server

```
service ssh start
```

using another terminal, login with ssh

```
ssh root@<ip>
```

use nc to connect on port 23

```
nc -vvv ip-of-server 23
```

## helpful commands:

Find the ip address

```
ip addr
```

or

```
ifconfig
```
