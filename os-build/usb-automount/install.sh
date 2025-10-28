#!/bin/bash -eux
# Optional: Install filesystem packages for NTFS/exFAT
sudo apt install -y ntfs-3g exfat-fuse exfatprogs

# Remove older custom rules if they exist
sudo rm -f /etc/udev/rules.d/99-usb-mount.rules 2>/dev/null || true
sudo rm -f /etc/udev/rules.d/99-auto-udisks2.rules 2>/dev/null || true

# Create the mount script
sudo tee /usr/local/bin/automount.sh >/dev/null <<'EOF'
#!/bin/bash
DEVNAME="$1"
logger -t "AUTOMOUNT" "Handling add for /dev/$DEVNAME..."

# Give the kernel a moment to register the partition fully
sleep 2

FSTYPE="$(blkid -o value -s TYPE "/dev/$DEVNAME")"
if [ -z "$FSTYPE" ]; then
  logger -t "AUTOMOUNT" "No FS type detected for /dev/$DEVNAME, skipping."
  exit 1
fi

MOUNTPOINT="/media/$DEVNAME"
mkdir -p "$MOUNTPOINT"

case "$FSTYPE" in
    vfat|exfat)
        mount -t "$FSTYPE" -o uid=1000,gid=1000,dmask=027,fmask=137 "/dev/$DEVNAME" "$MOUNTPOINT"
        ;;
    ntfs)
        mount -t ntfs -o uid=1000,gid=1000,umask=022 "/dev/$DEVNAME" "$MOUNTPOINT"
        ;;
    ext4|ext3|ext2)
        mount -t "$FSTYPE" "/dev/$DEVNAME" "$MOUNTPOINT"
        ;;
    *)
        logger -t "AUTOMOUNT" "Unsupported filesystem $FSTYPE on /dev/$DEVNAME."
        exit 1
        ;;
esac

logger -t "AUTOMOUNT" "Mounted /dev/$DEVNAME at $MOUNTPOINT (FS=$FSTYPE)."
EOF
sudo chmod +x /usr/local/bin/automount.sh

# Create the unmount script
sudo tee /usr/local/bin/autounmount.sh >/dev/null <<'EOF'
#!/bin/bash
DEVNAME="$1"
logger -t "AUTOMOUNT" "Handling remove for /dev/$DEVNAME..."

MOUNTPOINT="/media/$DEVNAME"
umount -l "$MOUNTPOINT" 2>/dev/null || true
rmdir "$MOUNTPOINT" 2>/dev/null || true

logger -t "AUTOMOUNT" "Unmounted /dev/$DEVNAME from $MOUNTPOINT."
EOF
sudo chmod +x /usr/local/bin/autounmount.sh

# Create the udev rules
sudo tee /etc/udev/rules.d/99-automount.rules >/dev/null <<'EOF'
# When a new sdX partition is added (i.e., sda1, sdb1, etc.), run automount.sh
SUBSYSTEM=="block", KERNEL=="sd[a-z][0-9]*", ACTION=="add", ENV{ID_FS_TYPE}=="?*", RUN+="/usr/bin/systemd-run --no-block /usr/local/bin/automount.sh %k"

# When removed, unmount it
SUBSYSTEM=="block", KERNEL=="sd[a-z][0-9]*", ACTION=="remove", RUN+="/usr/bin/systemd-run --no-block /usr/local/bin/autounmount.sh %k"
EOF

echo "===================================="
echo "Automount installed."
echo "We should be able to Insert a USB stick. It should mount under /media/sdXY (e.g. /media/sda1)."
echo "Check logs via:  journalctl -t AUTOMOUNT -f"
