FROM python:3.13.5-slim
RUN apt-get update

RUN apt-get install -yq vim wget curl jq git gnupg2 python3-pip python3-dnf sshpass openssh-client iputils-ping telnet krb5-user krb5-user libkrb5-dev gcc cifs-utils nfs-common expect pipx && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

RUN pip install --no-cache-dir ansible
RUN pip install --upgrade pip


WORKDIR /ansible

COPY ./requirements.txt /ansible/requirements.txt
RUN pip install --no-cache-dir -r /ansible/requirements.txt && \
rm -rf /ansible/requirements.txt

RUN mkdir -p /etc/ansible && \
    echo 'localhost ansible_connection=local' > /etc/ansible/hosts

COPY ./requirements.yml /ansible/requirements.yml
RUN ansible-galaxy install -r /ansible/requirements.yml && \
rm -rf /ansible/requirements.yml

# Install Powershell 7 and modules.
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

RUN pip list && \
    ansible-playbook --version && \
    ansible-galaxy collection list && \
    pwsh -c Get-Module -ListAvailable

CMD [ "ansible-playbook", "--version" ]
