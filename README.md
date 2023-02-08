# ansible2go

[![Docker Image CI](https://github.com/devopsteamsdb/ansible2go/actions/workflows/docker-image.yml/badge.svg)](https://github.com/devopsteamsdb/ansible2go/actions/workflows/docker-image.yml)


🛠 test the docker image using ansible-playbook:

```bash
alias ansible='docker run --rm -it -v $(pwd):/ansible -v ~/.ssh/id_rsa:/root/.ssh/id_rsa --workdir=/ansible devopsteamsdb/devopsteamsdb:ansible2go_latest ansible $@'

alias ansible-playbook='docker run --rm -it -v $(pwd):/ansible -v ~/.ssh/id_rsa:/root/.ssh/id_rsa --workdir=/ansible devopsteamsdb/devopsteamsdb:ansible2go_latest ansible-playbook $@'

ansible-playbook --version
```


🚀 test the docker image using bash:

```bash
docker run --rm -it -v $(pwd):/ansible -v ~/.ssh/id_rsa:/root/.ssh/id_rsa --workdir=/ansible devopsteamsdb/devopsteamsdb:ansible2go_latest bash
```

via https://labs.play-with-docker.com


Credit:
based on https://github.com/willhallonline/docker-ansible
