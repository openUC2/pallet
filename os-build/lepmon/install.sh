#!/bin/bash -eu

config_files_root=$(dirname "$(realpath "$BASH_SOURCE")")

echo "Install Vimba Driver"
./install_vimba.sh
