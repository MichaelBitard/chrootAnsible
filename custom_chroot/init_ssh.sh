#!/bin/bash
/etc/init.d/ssh start
#Try upstart mecanism if init.d fails
[ $? -ne 0 ] && service ssh start

