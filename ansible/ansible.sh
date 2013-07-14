#!/bin/bash
ansible_sources/hacking/env-setup
ansible-playbook chroot.yml -i ansible_hosts
