#!/bin/bash -eux
# The localization configuration provides a set of defaults for internationalization and
# localization settings.

# Generate the en_US and en_DK UTF-8 locales to make them available for use. Refer to the contents
# of /usr/share/i18n/SUPPORTED for a list of locales which can be generated.
sudo bash -c 'cat > /etc/locale.gen' <<EOT
en_US.UTF-8 UTF-8
de_DE.UTF-8 UTF-8
EOT
sudo dpkg-reconfigure --frontend=noninteractive locales
# Note: https://wiki.debian.org/Locale#Standard recommends choosing "None" as the default locale to
# accommodate users who access the system through ssh.
sudo update-locale --reset

# Change the timezone to UTC
# If systemd is not running (e.g. when setup scripts are run in an unbooted chroot or container),
# we can't use `timedatectl`:
if ! sudo timedatectl set-timezone UTC 2>/dev/null; then
  sudo rm /etc/localtime
  sudo ln -s /usr/share/zoneinfo/UTC /etc/localtime
fi
