#!/bin/bash -eux
# # Note: we need to adjust update-initramfs's behavior to make apt-get finish successfully; see
# https://github.com/PlanktoScope/PlanktoScope/pull/596 and
# https://github.com/RPi-Distro/repo/issues/382 for details.
adjust_initramfs_scope=false
if grep -q 'MODULES=dep' /etc/initramfs-tools/initramfs.conf; then
  adjust_initramfs_scope=true
  sudo sed -i 's~MODULES=dep~MODULES=most~' /etc/initramfs-tools/initramfs.conf
fi
sudo apt install -y -o DPkg::Lock::Timeout=60 -o Dpkg::Progress-Fancy=0 \
  udisks2 udisks2-lvm2 \
  exfat-fuse exfatprogs \
  ntfs-3g
if [ "$adjust_initramfs_scope" = true ]; then
  sudo sed -i 's~MODULES=most~MODULES=dep~' /etc/initramfs-tools/initramfs.conf
fi

sudo groupadd storage
sudo usermod -aG storage "$USER"
