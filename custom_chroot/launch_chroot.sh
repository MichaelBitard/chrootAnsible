#!/bin/bash
# -*- coding: UTF8 -*-
bindir=$(dirname $0)
root_dir=$bindir/chroot

ps aux|grep $root_dir| grep -v grep| grep -v helper | grep -v gedit > /dev/null

if [[ $? == 0 ]] ;
then
  echo "A chroot is already launched"
  exit 1
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

launchChroot
