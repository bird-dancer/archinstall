read -p "install desktop applications[yY] " desktop
read -p "install plasma[yY] " plasma
read -p "install xorg[yY] " xorg
read -p "install yay[yY] " yay
read -p "install zsh[yY] " zsh

install="sudo pacman -Syyu wget curl python go dnsutils mlocate vim nano openssh ranger htop tree which nmap zip unzip"
case $xorg in [yY])
	install+=" xorg xorg-xinit"
	case $plasma in [yY])
		install+=" pipewire pipewire-pulse plasma sddm dolphin ark ntfs-3g"
		rest="sudo systemctl enable sddm"
		;;
	esac
	;;
esac
case $desktop in
	[yY])
		install+=" code docker docker-compose mpv nomacs firefox thunderbird discord flatpak torbrowser-launcher alacritty neofetch"
	;;
esac
case $zsh in [yY])
	install+=" zsh zsh-syntax-highlighting zsh-autosuggestions exa awesome-terminal-fonts"
	;;
esac
$install
$rest
case $yay in
	[yY])
		sudo git clone https://aur.archlinux.org/yay.git /opt/yay
		sudo chown -R $USER /opt/yay
		makepkg -si /opt/yay
		;;
esac
sudo updatedb
