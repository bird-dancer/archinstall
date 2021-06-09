pacman -S wget curl python go dnsutils mlocate vim nano openssh ranger htop tree which nmap zip unzip

read -p "install desktop applications[yY]" desktop
read -p "install plasma[yY]" plasma
read -p "install xorg[yY]" xorg
read -p "install yay[yY]" yay
case $xorg in
	[yY])
		pacman -S xorg xorg-xinit
	;;
esac
case $plasma in
	[yY])
		pacman -S plasma sddm dolphin ark ntfs-3g
	;;
esac
case $desktop in
	[yY])
		pacman -S pipewire pipewire-pulse code docker docker-compose mpv nomacs firefox thunderbird discord flatpak torbrowser-launcher alacritty neofetch
	;;
esac
case $yay in
	[yY])
		git clone https://aur.archlinux.org/yay.git /opt
		chown -R $USER /opt/yay
		makepkg -si /opt/yay
		;;
esac
updatedb
