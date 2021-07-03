ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc
echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen
echo 'LANG=en_US.UTF-8' > /etc/locale.conf
echo 'KEYMAP=de-latin1' > /etc/vconsole.conf
locale-gen
read -p "device name" name
echo "$name" > /etc/hostname
echo "127.0.0.1	localhost
::1		localhost
127.0.1.1	$name.localdomain	$name" >> /etc/hosts
mkinitcpio -P
bootctl --path=/boot install
read -p "intel or amd cpu: " cpu
echo 'default arch-*' >> /boot/loader/loader.conf
echo "title Arch Linux
linux /vmlinuz-linux
initrd  /$cpu-ucode.img
initrd  /initramfs-linux.img
options root=UUID=" > /boot/loader/entries/arch.conf

passwd=""
while [ -z $passwd ]; do
  read -p "password for root: " passwd
done
echo -e "$passwd\n$passwd" | passwd
