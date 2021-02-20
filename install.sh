echo $(ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime)
echo $(hwclock --systohc)
echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen
echo 'LANG=en_US.UTF-8' > /etc/locale.conf
echo 'KEYMAP=de-latin1' > /etc/vconsole.conf
echo 'lemur' > /etc/hostname
echo '127.0.0.1	localhost
::1		localhost
127.0.1.1	lemur.localdomain	lemur' >> /etc/hosts
echo $(mkinitcpio -P)
echo $(bootctl --path=/boot install)
echo 'default arch-*' >> /boot/loader/loader.conf
echo '
title Arch Linux
linux /vmlinuz-linux
initrd  /amd-ucode.img
initrd  /initramfs-linux.img
options root=UUID=
