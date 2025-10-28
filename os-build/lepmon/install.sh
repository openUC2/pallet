#!/bin/bash -eu

config_files_root=$(dirname "$(realpath "$BASH_SOURCE")")

echo "Install Vimba Driver"
./install_vimba.sh

# Clean up any unnecessary pip/etc. files
pip3 cache purge || true
rm -rf "$HOME/.cache/pip"
