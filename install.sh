ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc
echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen
echo 'LANG=en_US.UTF-8' > /etc/locale.conf
echo 'KEYMAP=de-latin1' > /etc/vconsole.conf
locale-gen
echo 'lemur' > /etc/hostname
echo '127.0.0.1	localhost
::1		localhost
127.0.1.1	lemur.localdomain	lemur' >> /etc/hosts
mkinitcpio -P
bootctl --path=/boot install
echo 'default arch-*' >> /boot/loader/loader.conf
echo 'title Arch Linux
linux /vmlinuz-linux
initrd  /amd-ucode.img
initrd  /initramfs-linux.img
options root=UUID=' > /boot/loader/entries/arch.conf

#read -p "user name of new user (leave empty for no new user): " username
#if [ "$username" != "" ]; then
#    read -p "password for new user" passwd
#    useradd -m -G wheel $username | passwd --stdin $passwd
#fi
