FROM ubuntu:20.04

LABEL maintainer="devops.team.sdb@gmail.com" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.name="devopsteamsdb/ansible2go" \
    org.label-schema.description="Ansible 2 Go" \
    org.label-schema.url="https://github.com/devopsteamsdb/ansible2go" \
    org.label-schema.vcs-url="https://github.com/devopsteamsdb/ansible2go" \
    org.label-schema.vendor="DevOps Team" \
    org.label-schema.docker.cmd="docker run --rm -it -v $(pwd):/ansible -v ~/.ssh/id_rsa:/root/id_rsa devopsteamsdb/devopsteamsdb:ansible2go_latest"

# Ansible Dependencies
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install -y vim wget curl jq git gnupg2 python3-pip sshpass openssh-client && \
    DEBIAN_FRONTEND=noninteractive apt-get -yq install krb5-user krb5-user libkrb5-dev gcc python-dev cifs-utils nfs-common && \
    rm -rf /var/lib/apt/lists/*

# ImportExcel Powershell Module Dependencies
# RUN apt-get update && apt-get install -y --no-install-recommends libgdiplus libc6-dev

# Ansible 2.x Core
RUN python3 -m pip install --upgrade pip cffi && \
    pip install ansible-core ansible && \
    pip install mitogen ansible-lint jmespath netapp-lib && \
    pip install --upgrade pywinrm && \
    pip install pywinrm[kerberos] requests-kerberos pyvmomi && \
    rm -rf /root/.cache/pip

RUN mkdir /ansible && \
    mkdir -p /etc/ansible && \
    echo 'localhost ansible_connection=local' > /etc/ansible/hosts

# Ansible Collections
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

# Powershell 7
RUN wget https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    apt-get update && \
    apt-get install -y powershell && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

# Powershell 7 Modules
RUN pwsh -c install-module vmware.powercli,importexcel,pscribo,dbatools,sqlserverdsc,sharepointdsc,cisco.imc,cisco.ucs.core,jenkins,polaris,pswindowsupdate,powershell-yaml -AcceptLicense -Force

# Ignore powercli warning
RUN pwsh -c "Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -ParticipateInCeip 0 -Confirm:0"

RUN apt-get clean

WORKDIR /ansible

CMD [ "ansible-playbook", "--version" ]
