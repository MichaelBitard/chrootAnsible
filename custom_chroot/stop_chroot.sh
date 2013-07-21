#!/bin/bash
# -*- coding: UTF8 -*-
pushd `dirname $0` > /dev/null
scriptPath=`pwd`
popd > /dev/null
root_dir=$scriptPath/chroot
echo "stop all things launched by ansible and stop the chroot"

killAllChroot() {
echo "killing all things remaining in the chroot"
found=0
for rootProc in /proc/*/root; do
        LINK=$(sudo readlink $rootProc)
        if [ "x$LINK" != "x" ]; then
                if [ "x${LINK:0:${#root_dir}}" = "x$root_dir" ]; then
                        # this process is in the chroot...
                        PID=$(basename $(dirname "$rootProc"))
                        echo "$PID is in the chroot and is associated to `ps -p $PID -o comm=`, killing..."
                        sudo kill -9 "$PID"
			found=1
                fi
        fi
done

if [[ "$found" == "1" ]]; then
	echo "we killed some process, we recheck to be sure that nothing is remaining"
	killAllChroot
fi
}

unmountFileSystems() {
        sudo echo -ne "unmounting pseudo filesystems:"
        for pseudo in dev dev/pts proc sys
        do
                sudo umount $root_dir/$pseudo
                echo -ne " $pseudo"
        done
        echo ""
}

killAllChroot
unmountFileSystems
