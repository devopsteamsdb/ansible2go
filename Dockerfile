FROM ubuntu:23.04

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq vim wget curl jq git gnupg2 python3-pip sshpass openssh-client iputils-ping telnet && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq krb5-user krb5-user libkrb5-dev gcc cifs-utils nfs-common expect && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

RUN python3 -m pip install --upgrade setuptools==62.0.0 && \
    python3 -m pip install --upgrade git+https://github.com/vmware/vsphere-automation-sdk-python.git

RUN python3 -m pip install --upgrade pip cffi && \
    pip install ansible-core ansible && \
    pip install mitogen ansible-lint jmespath netapp-lib && \
    pip install --upgrade pywinrm && \
    pip install pywinrm[kerberos] requests-kerberos pyvmomi pexpect kubernetes openshift docker docker-compose ansible-parallel && \
    rm -rf /root/.cache/pip

RUN mkdir /ansible && \
    mkdir -p /etc/ansible && \
    echo 'localhost ansible_connection=local' > /etc/ansible/hosts

COPY ./requirements.yml /ansible/requirements.yml
RUN ansible-galaxy install -r /ansible/requirements.yml

# Install Powershell  7 and modules
RUN wget https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    apt-get update && \
    apt-get install -y powershell && \
    rm -rf /packages-microsoft-prod.deb && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

RUN pwsh -c install-module vmware.powercli,importexcel,pscribo,dbatools,sqlserverdsc,cisco.imc,cisco.ucs.core,jenkins,pswindowsupdate,pester -AcceptLicense -Force

RUN pwsh -c "Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -ParticipateInCeip 0 -Confirm:0"

WORKDIR /ansible

RUN pip list && \
    ansible-playbook --version && \
    pwsh -c Get-Module -ListAvailable

CMD [ "ansible-playbook", "--version" ]
