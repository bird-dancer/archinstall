#
# This is my personal install script for archlinux which can be used after changing root into the new system
#
# prints a promt and repeats it if the user gives an empty input
# $1: text of promt
# returns the answer
ask() {
	read -p "$1 " answer
	if [ -z $answer ]; then
		answer=$(ask "$1")
	fi
	echo $answer
}
# reading, setting and generating the locale
locale=$(ask 'locale (e.g. en_US:')
echo "$locale.UTF-8 UTF-8" >> /etc/locale.gen
echo "LANG=$locale.UTF-8" > /etc/locale.conf
echo 'KEYMAP=de-latin1' > /etc/vconsole.conf
locale-gen
# setting time zone and synching hardware clock
timezone=$(ask 'timezone (e.g. Europe/Berlin):')
ln -sf /usr/share/zoneinfo/$timezone /etc/localtime
hwclock --systohc
# reading and setting hostname
name=$(ask 'device name:')
echo "$name" > /etc/hostname
echo "127.0.0.1	localhost
::1		localhost
127.0.1.1	$name.localdomain	$name" >> /etc/hosts
#
mkinitcpio -P
#
# install bootloader
# if uefi then systemd-boot will be used
# if bios then grub bootloader
#
if [ -d /sys/firmware/efi/efivars ]; then
# getting UUID of the root partition
	lsblk
	root=$(ask 'what is your root partition? (e.g. sdc3):')
	UUID=$(blkid /dev/$root)
	UUID="${UUID#*UUID=}"
	UUID="${UUID%%B*}"
# installing and setting up systemd-boot
	bootctl --path=/boot install
	cpu=$(ask 'are you using an intel or amd cpu (answer intel or amd)')
	pacman -S $cpu-ucode
	echo 'default arch-*' > /boot/loader/loader.conf
	echo "title Arch Linux
	linux /vmlinuz-linux
	initrd  /$cpu-ucode.img
	initrd  /initramfs-linux.img
	options root=UUID=$UUID rw "> /boot/loader/entries/arch.conf
else
# setting up grub
	pacman -S grub
	lsblk
	root=$(ask 'Disk to install (e.g. sdc):')
	grub-install /dev/$root
	grub-mkconfig -o /boot/grub/grub.cfg
	update-grub && update-initramfs -u
fi
# try enableing networking tools
systemctl enable NetworkManager
systemctl enable dhcpcd
# get and set root password
passwd=$(ask 'root password:')
chpasswd <<<"root:$passwd"
