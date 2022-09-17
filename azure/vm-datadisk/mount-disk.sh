#!/bin/bash
sudo parted /dev/sdc --script mklabel gpt mkpart xfspart xfs 0% 100%
sudo mkfs.xfs /dev/sdc1
sudo partprobe /dev/sdc1
sudo mkdir /datadrive
sudo mount /dev/sdc1 /datadrive
uid=`sudo blkid | grep /dev/sdc1 | awk -F ' ' '{print $2}' | tr -d 'UUID=' | tr -d '"'`
str="UUID=$uid   /datadrive   xfs   defaults,nofail   1   2"
sudo echo "${str}" | sudo tee -a /etc/fstab
lsblk -o NAME,HCTL,SIZE,MOUNTPOINT | grep -i "sd"