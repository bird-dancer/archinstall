read -p "install desktop applications[yY]: " desktop
read -p "install yay[yY]: " yay
read -p "install zsh[yY]: " zsh
read -p "install my personally used programms[yY]: " personal
read -p "install xorg[yY]: " xorg
install="pacman -Syyu wget python vim nano htop net-tools"
case $xorg in [yY])
	install+=" xorg xorg-xinit"
	read -p "install plasma[yY]: " plasma
	case $plasma in [yY])
		while [ -z $username ]; do
			read -p "username for the new user: " username
		done
		while [ -z $passwd ]; do
			read -p "password for $username: " passwd
		done
		install+=" pipewire pipewire-pulse plasma sddm dolphin ark alacritty ntfs-3g qt5-imageformats sudo"
		rest="systemctl enable sddm && localectl set-x11-keymap de"
		;;
	esac
	;;
esac
case $desktop in
	[yY])
		install+=" mpv nomacs firefox thunderbird"
	;;
esac
case $zsh in [yY])
	install+=" zsh zsh-syntax-highlighting zsh-autosuggestions exa awesome-terminal-fonts"
	;;
esac
case $personal in [yY])
	install+=" code docker docker-compose go torbrowser-launcher dnsutils openssh ranger tree nmap zip unzip vim mlocate dnsutils curl"
	;;
esac
$install
if [ $username != "" ]; then
	useradd -m -G wheel $username
	chpasswd <<<"$username:$passwd"
	echo '%wheel ALL=(ALL) ALL' | EDITOR='tee -a' visudo
fi
$rest
case $yay in
	[yY])
		pacman -S go base-devel
		git clone https://aur.archlinux.org/yay.git /opt/yay
		chown -R $USER /opt/yay
		cd /opt/yay
		
		makepkg -si
		;;
esac
updatedb
