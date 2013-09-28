## Setup a chroot with a SSH server running on port 220 and ready to be 'ansiblized'

1. Create the chroot
  1. Launch 'sudo ./create_chroot.sh' (make sure you have debootstrap installed before)
  2. You will be prompted for the ubuntu distribution you want to create the chroot from
  3. Wait for it
  4. Congratulations, you have a chroot created in the chroot directory
2. Use the chroot
  1. Now there is a directory named chroots_dir/${distrib}
    1. The global structure is: 
       * chroot: contains the chroot
       * chrootAnsible: contains all file to customize the chroot with ansible
         * ansible contains the chroot.yml which is the parent yml file
       * launch_chroot.sh
       * stop_chroot.sh


If you execute ./launch_chroot.sh it will 
* mount /proc /dev /sys and /dev/pts
* launch the chroot and an ssh server
* put your ssh public key to the root folder of the chroot
* launch ansible

Once this is over, you have your prompt back and you can connect to the chroot by using 'ssh root@localhost -p 220'.
