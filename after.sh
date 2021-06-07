pacman -S wget curl python go dnsutils mlocate vim nano openssh ranger htop tree which nmap zip unzip

read -p "install desktop[yY]" desktop
read -p "install plasma[yY]" plasma
read -p "install xorg[yY] or wayland[nN]" compositor
case $compositor in
	[yY])
		pacman -S xorg xorg-xinit
	;;
	[nN])
		pacman -S wayland
	;;
esac
case $plasma in
	[yY])
		pacman -S pacman -S plasma sddm dolphin ark
	;;
esac
case $desktop in
	[yY])
		pacman -S pipewire pipewire-pulse code docker docker-compose mpv nomacs firefox thunderbird discord flatpak torbrowser-launcher alacritty neofetch
	;;
esac
