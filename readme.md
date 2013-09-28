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
