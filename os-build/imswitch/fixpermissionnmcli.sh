#!/usr/bin/env bash
# filepath: /Users/bene/Downloads/rpi-os-demo/imswitch/fixpermissionnmcli.sh
# setup_nmcli_sudo.sh
# Make user "pi" able to run `nmcli` via sudo without password (inside Docker or host).
# Idempotent. Works on Debian/Raspberry Pi OS–based images.

set -euo pipefail
sudo apt-get update
# `nmcli` comes from `network-manager`
sudo apt-get install -y network-manager
nmcli_path="$(command -v nmcli || echo /usr/bin/nmcli)"

# specify USER_NAME
USER_NAME="pi"
echo "Writing sudoers rule for ${USER_NAME} → ${nmcli_path}"
file="/etc/sudoers.d/nmcli-${USER_NAME}"
printf '%s ALL=(root) NOPASSWD: %s\n' "${USER_NAME}" "${nmcli_path}" | sudo tee "${file}" > /dev/null
sudo chmod 0440 "${file}"
echo "Sudoers rule written to ${file}"