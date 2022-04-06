# ansible2go

to test the docker image use this command:

alias ansible='docker run --rm -it -v $(pwd):/ansible -v ~/.ssh/id_rsa:/root/.ssh/id_rsa --workdir=/ansible devopsteamsdb/devopsteamsdb:ansible2go_latest ansible $@'
alias ansible-playbook='docker run --rm -it -v $(pwd):/ansible -v ~/.ssh/id_rsa:/root/.ssh/id_rsa --workdir=/ansible devopsteamsdb/devopsteamsdb:ansible2go_latest ansible-playbook $@'

ansible-playbook --version

via https://labs.play-with-docker.com
