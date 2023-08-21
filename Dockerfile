FROM ubuntu:23.04

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq vim wget curl jq git gnupg2 python3-pip sshpass openssh-client iputils-ping telnet && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq krb5-user krb5-user libkrb5-dev gcc cifs-utils nfs-common expect pipx && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean
  
RUN rm -rf /usr/lib/python3.11/EXTERNALLY-MANAGED && \
    python3 -m pip install --upgrade pip cffi && \
    pip install ansible-core ansible && \
    pip install mitogen ansible-lint jmespath netapp-lib && \
    pip install --upgrade pywinrm && \
    pip install pywinrm[kerberos] requests-kerberos && \
    rm -rf /root/.cache/pip

RUN pip install --upgrade setuptools
RUN pip install PyYAML==5.3.1
RUN pip install pyvmomi pexpect openshift ansible-parallel docker kubernetes
RUN pip install docker-compose --no-dependencies

RUN pip install --upgrade git+https://github.com/vmware/vsphere-automation-sdk-python.git

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

COPY ./powershell_modules.txt /ansible/powershell_modules.txt
COPY ./powershell_install_modules.ps1 /ansible/powershell_install_modules.ps1

RUN pwsh -File "/ansible/powershell_install_modules.ps1"

RUN pwsh -c "Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -ParticipateInCeip 0 -Confirm:0"

WORKDIR /ansible

RUN pip list && \
    ansible-playbook --version && \
    ansible-galaxy collection list && \
    pwsh -c Get-Module -ListAvailable

CMD [ "ansible-playbook", "--version" ]
