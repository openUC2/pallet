#!/bin/bash -eux
# Cockpit enables system administration from a web browser.

# Install cockpit
sudo -E apt-get install -y --no-install-recommends -o Dpkg::Progress-Fancy=0 \
  cockpit cockpit-networkmanager cockpit-storaged

# install cockpit-navigator
wget -O /tmp/cockpit-navigator.deb https://github.com/45Drives/cockpit-navigator/releases/download/v0.5.10/cockpit-navigator_0.5.10-1focal_all.deb
ls
sudo apt-get install -y /tmp/cockpit-navigator.deb
rm /tmp/cockpit-navigator.deb

echo "Installation complete. Access Cockpit at https://<IP-ADDRESS>:9090/"
