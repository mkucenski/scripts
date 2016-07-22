vnconfig vn0 "$1"
mount -t msdos /dev/vn0c /mnt
ls -l /mnt
umount /mnt
vnconfig -u vn0
