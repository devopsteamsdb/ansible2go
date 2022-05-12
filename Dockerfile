FROM ubuntu:20.04

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y vim wget curl jq git gnupg2 python3-pip sshpass openssh-client iputils-ping telnet && \
    DEBIAN_FRONTEND=noninteractive apt-get -yq install krb5-user krb5-user libkrb5-dev gcc python-dev cifs-utils nfs-common expect

RUN python3 -m pip install --upgrade pip cffi && \
    pip install ansible-core ansible && \
    pip install mitogen ansible-lint jmespath netapp-lib && \
    pip install --upgrade pywinrm && \
    pip install pywinrm[kerberos] requests-kerberos pyvmomi docker pexpect kubernetes && \
    rm -rf /root/.cache/pip

RUN mkdir /ansible && \
    mkdir -p /etc/ansible && \
    echo 'localhost ansible_connection=local' > /etc/ansible/hosts

RUN ansible-galaxy collection install ansible.netcommon && \
    ansible-galaxy collection install ansible.utils && \
    ansible-galaxy collection install ansible.windows && \
    ansible-galaxy collection install cisco.aci && \
    ansible-galaxy collection install cisco.ios && \
    ansible-galaxy collection install community.crypto && \
    ansible-galaxy collection install community.docker && \
    ansible-galaxy collection install community.general && \
    ansible-galaxy collection install community.vmware && \
    ansible-galaxy collection install community.windows && \
    ansible-galaxy collection install check_point.mgmt && \
    ansible-galaxy collection install netapp.ontap

# Install Powershell 7 and modules
RUN wget https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    apt-get update && \
    apt-get install -y powershell
RUN pwsh -c install-module vmware.powercli,importexcel,pscribo,dbatools,sqlserverdsc,cisco.imc,cisco.ucs.core,jenkins,pswindowsupdate,pester -AcceptLicense -Force
RUN pwsh -c "Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -ParticipateInCeip 0 -Confirm:0"

# Install Openshift linux client
RUN curl -fsSL https://raw.githubusercontent.com/cptmorgan-rh/install-oc-tools/master/install-oc-tools.sh -o install-oc-tools.sh  && chmod +x install-oc-tools.sh && ./install-oc-tools.sh --version 4.10.5

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /ansible

CMD [ "ansible-playbook", "--version" ]
