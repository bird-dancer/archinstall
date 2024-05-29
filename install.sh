echo "##############################################################################################################
# This is my personal install script for archlinux which can be used after changing root into the new system #
##############################################################################################################"
#
# prints a promt and repeats it if the user gives an invalid input
# $1: text of promt
# $2: allowed answers	leave empty if the input content does not matter
# returns the answer
# example usage answer=$(ask "Some Question" "[yYnN]")
ask() {
    read -r -p "$1 $2 " answer
    if [ -z "$answer" ];then
	answer=$(ask "$1" "$2")
    fi
    if [[ "" != "$2" ]];then
	if ! [[ $answer =~ $2 ]];then
	    answer=$(ask "$1" "$2")
	fi
    fi
    echo "$answer"
}

# reading, setting and generating the locale
locale=$(ask 'locale (e.g. en_US:')
echo "$locale.UTF-8 UTF-8" >> /etc/locale.gen
echo "LANG=$locale.UTF-8" >> /etc/locale.conf
read -p "prefered keymap (eg. de-latin1) (leave empty for us)" keymap
echo "KEYMAP=$keymap" >> /etc/vconsole.conf
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
# install and set up systemd-boot bootloader
# getting UUID of the root partition
lsblk
root=$(ask 'what is your root partition? (e.g. /dev/sdc3):')
uuid=$(echo $(blkid "$root") | grep -oP 'UUID="\K[^"]+' | head -n 1)
bootctl --path=/boot install
cpu=$(ask 'are you using an intel or amd cpu?' "[intel,amd]")
pacman -S $cpu-ucode
echo 'default arch-*
console-mode max' > /boot/loader/loader.conf
# encryption
encrypt=$(ask 'would you like to use encryption? (you must have a luks cryptvolume)' "[yYnN]")
if [[ $encrypt =~  [yY] ]];then
    cp mkinitcpio.conf /etc/mkinitcpio.conf
    lsblk
    cryptvolume=$(ask 'what is the name of your crypt volume? (eg. type "root" for /dev/mapper/root)')
    mkinitcpio -P linux
    echo "title Arch Linux
linux /vmlinuz-linux
initrd  /$cpu-ucode.img
initrd  /initramfs-linux.img
options cryptdevice=UUID=$uuid:$cryptvolume root=/dev/mapper/$cryptvolume quiet rw "> /boot/loader/entries/arch.conf
else
    echo "title Arch Linux
linux /vmlinuz-linux
initrd  /$cpu-ucode.img
initrd  /initramfs-linux.img
options root=UUID=$uuid  quiet rw "> /boot/loader/entries/arch.conf
fi

# try enableing networking tools
systemctl enable NetworkManager
systemctl enable dhcpcd
# set root password
passwd
