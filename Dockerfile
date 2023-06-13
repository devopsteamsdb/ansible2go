FROM ubuntu:23.04

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq vim wget curl jq git gnupg2 python3-pip sshpass openssh-client iputils-ping telnet && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq krb5-user krb5-user libkrb5-dev gcc cifs-utils nfs-common expect pipx && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean
    
RUN rm -rf /usr/lib/python3.11/EXTERNALLY-MANAGED && \
    python3 -m pip install --upgrade setuptools==62.0.0 && \
    python3 -m pip install --upgrade git+https://github.com/vmware/vsphere-automation-sdk-python.git

RUN python3 -m pip install --upgrade pip cffi && \
    pip install ansible-core ansible && \
    pip install mitogen ansible-lint jmespath netapp-lib && \
    pip install --upgrade pywinrm && \
    pip install pywinrm[kerberos] requests-kerberos pyvmomi pexpect kubernetes openshift docker docker-compose ansible-parallel && \
    rm -rf /root/.cache/pip
