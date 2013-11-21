#!/bin/bash
# -*- coding: UTF8 -*-
bindir=$(dirname $0)
root_dir=$bindir/chroot


update() {
    git fetch -v --dry-run 2> output
    if grep "up to date" output
    then
        echo "no changes to pull"
    else
        echo "You are not at the last version, a pull will be made in 5 seconds (CTRL+C to abort)"
        echo "If you dont want this message, run with ./launch_chroot.sh no-update"
        sleep 5
        git pull
    fi
    rm output
}

if [ "$1" != "no-update" ]
then
    update
fi

netstat -ano|grep ':220 '|grep LISTEN|grep -v LISTENING > /dev/null

if [[ $? == 0 ]] ;
then
  echo "A chroot is already launched"
  ssh -X root@127.0.0.1 -p220
  exit 1
fi

if [ ! -d "$root_dir" ]
then
    echo "no chroot present, creating one"
    sudo ./util_create_chroot.sh
    sudo mv $bindir/chroots_dir/*/chroot/ $root_dir
fi

echo "Launching chroot"

mountFileSystems() {
	sudo echo -ne "mounting pseudo filesystems:"
	for pseudo in dev dev/pts proc sys
	do
		sudo mount --bind /$pseudo  $root_dir/$pseudo
		echo -ne " $pseudo"
	done
	echo ""
  	echo "cp resolv.conf for network"
  	sudo cp /etc/resolv.conf $root_dir/etc/resolv.conf
}

launchChroot() {
	#custom root/.bashrc
	mountFileSystems
	sudo chroot $root_dir /init_ssh.sh
}
if [ ! -f $root_dir/root/.ssh/authorized_keys ]; then
	user=`whoami`
	USER_HOME=$(getent passwd $user | cut -d: -f6)
	echo "no ssh key for autolog configured, using default $USER_HOME/.ssh/id_rsa.pub"
	sudo cp $USER_HOME/.ssh/id_rsa.pub $root_dir/root/.ssh/authorized_keys
	sudo chmod 600 $root_dir/root/.ssh/authorized_keys
fi

launchAnsible() {
	ansiblePath=$bindir/ansible/
	source $ansiblePath/ansible_sources/hacking/env-setup
	ansible-playbook $ansiblePath/chroot.yml -i $ansiblePath/ansible_hosts
}

cloneAnsibleIfNotAlreadyDone() {
	ansiblePath=$bindir/ansible/
	if [ "$(ls -A ${ansiblePath}/ansible_sources)" ]; then
		echo "No need to clone ansible submodule"
	else
		echo "Ansible submodule needs to be cloned"
		git submodule update --init
	fi
}

launchChroot
cloneAnsibleIfNotAlreadyDone
launchAnsible
ssh -X root@127.0.0.1 -p220
