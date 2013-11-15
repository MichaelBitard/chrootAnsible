## Setup a chroot with a SSH server running on port 220 and ready to be 'ansiblized'

### Prerequisites
In order for this to work, you must have: 
* debootstrap
* python-jinja2
* python-yaml
* id_rsa.pub present in your ~/.ssh

For ubuntu, you can copy/paste
```bash
 sudo apt-get install debootstrap python-jinja2 python-yaml
```

### Usage
Execute ./launch_chroot.sh

If you dont have a chroot initialized, you will be asked to chose which distribution you want to create the chroot from.
At the end of the setup, ansible will be launched and your chroot configured

#### What the script does 

* mount /proc /dev /sys and /dev/pts
* launch the chroot and an ssh server
* put your ssh public key to the root folder of the chroot so you're able to login without password
 * For the moment, you need to have an id_rsa.pub in your ~/.ssh, else it won't work
* launch ansible
* connect via ssh to the chroot

#### Faq
If you have something like that:
```
 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
 @    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
 IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!
 Someone could be eavesdropping on you right now (man-in-the-middle attack)!
 It is also possible that a host key has just been changed.
 The fingerprint for the ECDSA key sent by the remote host is
 58:45:5b:9f:c5:33:8d:15:45:2b:81:c9:b3:28:1c:39.
 Please contact your system administrator.
 Add correct host key in /home/yourhome/.ssh/known_hosts to get rid of this message.
 Offending ECDSA key in /home/yourhome/.ssh/known_hosts:13
   remove with: ssh-keygen -f "/home/yourhome/.ssh/known_hosts" -R [127.0.0.1]:220
 ECDSA host key for [127.0.0.1]:220 has changed and you have requested strict checking.
 Host key verification failed.
```

it means that you probably had another system running on port 220.
To get rid of this message, simply run the ssh-keygen command promped by the message. In my case, this will be 'ssh-keygen -f "/home/yourhome/.ssh/known_hosts" -R [127.0.0.1]:220', stop your chroot and launch it again.
