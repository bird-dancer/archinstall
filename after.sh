pacman -S wget curl python go dnsutils mlocate vim nano openssh ranger htop tree which nmap zip unzip
read -p "install desktop[yY]" desktop
case $desktop in
	[yY]) pacman -S pipewire pipewire-pulse code docker docker-compose mpv nomacs firefox thunderbird discord flatpak torbrowser-launcher alacritty neofetch
	;;
esac
read -p "install kde plasma[yY]" plasma
case $plasma in
	[yY]) pacman -S plasma sddm dolphin ark
	;;
esac	
