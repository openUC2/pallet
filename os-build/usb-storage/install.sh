#!/bin/bash -eux
sudo apt install -y -o DPkg::Lock::Timeout=60 -o Dpkg::Progress-Fancy=0 \
  udisks2 udisks2-lvm2 \
  exfat-fuse exfatprogs exfat-utils \
  ntfs-3g
