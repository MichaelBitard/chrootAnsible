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
	for pseudo in dev proc sys
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
	sudo chroot $root_dir
}
launchChroot
