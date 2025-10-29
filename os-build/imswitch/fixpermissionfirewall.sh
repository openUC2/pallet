#!/bin/bash
# filepath: /Users/bene/Downloads/rpi-os-demo/imswitch/fixpermissionfirewall.sh
# This script adds a sudoers rule allowing the 'pi' user to run firewall-cmd without a password

set -euo pipefail

SUDOERS_FILE="/etc/sudoers.d/imswitch-firewall"

# Create the sudoers entry using sudo tee
cat << 'EOF' | sudo tee "$SUDOERS_FILE" > /dev/null
# Allow pi user to run firewall-cmd without password for ImSwitch
pi ALL=(ALL) NOPASSWD: /usr/bin/firewall-cmd
EOF

# Set correct permissions
sudo chmod 440 "$SUDOERS_FILE"

echo "Sudoers rule added for 'pi' to run /usr/bin/firewall-cmd without password."