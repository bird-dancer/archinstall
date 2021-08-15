## finishing the install instructions from the wiki
locale=""
while [ -z $locale ]; do
	read -p "locale: " locale
done
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc
echo "$locale.UTF-8 UTF-8" >> /etc/locale.gen
echo "LANG=en_US.$locale" > /etc/locale.conf
echo 'KEYMAP=de-latin1' > /etc/vconsole.conf
locale-gen
read -p "device name: " name
echo "$name" > /etc/hostname
echo "127.0.0.1	localhost
::1		localhost
127.0.1.1	$name.localdomain	$name" >> /etc/hosts
mkinitcpio -P
bootctl --path=/boot install
read -p "intel or amd cpu: " cpu
echo 'default arch-*' > /boot/loader/loader.conf
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


## after the finished installation
## adding wanted packages to $install and executing it after

read -p "install terminal packages [yY]: " terminal
read -p "install xorg[yY]: " xorg
read -p "install yay[yY]: " yay
read -p "install zsh[yY]: " zsh
install="pacman -Syyu wget curl python"
case terminal in [yY])
	install+=" dnsutils mlocate vim nano openssh ranger htop tree which nmap zip unzip go"
	;;
esac
case $xorg in [yY])
	install+=" xorg xorg-xinit"
	read -p "install plasma[yY]: " plasma
	# getting username and password
	case $plasma in [yY])
		while [ -z $username ]; do
			read -p "username for new user: " username
		done
		while [ -z $passwd ]; do
			read -p "password for $username: " passwd
		done
		install+=" pipewire pipewire-pulse plasma sddm dolphin ark ntfs-3g alacritty sudo"
		rest="systemctl enable sddm \n localectl set-x11-keymap de"
		read -p "install desktop applications[yY]: " desktop
		case $desktop in [yY])
			install+=" code docker docker-compose mpv nomacs firefox thunderbird discord flatpak torbrowser-launcher neofetch"
			;;
		esac
		;;
	esac
	;;
esac
case $zsh in [yY])
	install+=" zsh zsh-syntax-highlighting zsh-autosuggestions exa awesome-terminal-fonts"
	;;
esac
$install
# adding user
if [ $username != "" ]; then
	useradd -m -G wheel $username
	echo -e "$passwd\n$passwd" | passwd
	echo '%wheel ALL=(ALL) ALL' | EDITOR='tee -a' visudofi
fi
$rest
# installing yay
case $yay in
	[yY])
		git clone https://aur.archlinux.org/yay.git /opt/yay
		chown -R $username /opt/yay
		makepkg -si /opt/yay
		;;
esac
updatedb
echo 'dont forget to add the UID in the /boot/loader/entries/arch.conf file!!!'
