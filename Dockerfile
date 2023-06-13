FROM ubuntu:23.04

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq vim wget curl jq git gnupg2 python3-pip sshpass openssh-client iputils-ping telnet && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq krb5-user krb5-user libkrb5-dev gcc cifs-utils nfs-common expect && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean
