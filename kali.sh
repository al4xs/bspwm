#!/bin/bash

# COLOR USE THE SCRIPT
Black='\033[1;30m'
Red='\033[1;31m'
Green='\033[1;32m'
Yellow='\033[1;33m'
Blue='\033[1;34m'
Purple='\033[1;35m'
Cyan='\033[1;36m'
White='\033[1;37m'
NC='\033[0m'
blue='\033[0;34m'
white='\033[0;37m'
lred='\033[0;31m'
IWhite="\[\033[0;97m\]"

# VARIABLE DATABASE AND OTHER THINGS
USERNAME=$(whoami)
LOCALPATH="/home/${USERNAME}"
KERNEL=$(uname -r)
DISTRIBUTION=$(uname -o)
HOST=$(uname -n)
BIT=$(uname -m)
RUTE=$(pwd)
FDIR=$(${LOCALPATH}/.local/share/fonts/)

# SCRIPT PRESENTATION
banner () {
echo -e "${White} ╔───────────────────────────────────────────────╗                 	"
echo -e "${White} |${Cyan} ██████╗ ███████╗██████╗ ██╗    ██╗███╗   ███╗${White} |      "
echo -e "${White} |${Cyan} ██╔══██╗██╔════╝██╔══██╗██║    ██║████╗ ████║${White} |      "
echo -e "${White} |${Cyan} ██████╔╝███████╗██████╔╝██║ █╗ ██║██╔████╔██║${White} |      "
echo -e "${White} |${Cyan} ██╔══██╗╚════██║██╔═══╝ ██║███╗██║██║╚██╔╝██║${White} |	"
echo -e "${White} |${Cyan} ██████╔╝███████║██║     ╚███╔███╔╝██║ ╚═╝ ██║${White} |	"
echo -e "${White} |${Cyan} ╚═════╝ ╚══════╝╚═╝      ╚══╝╚══╝ ╚═╝     ╚═╝${White} |	"
echo -e "${White} ┖───────────────────────────────────────────────┙			"
echo ""
echo -e "${White} [${Blue}i${White}] BSPWM | Hacker environment automation script."
echo -e "${White} [${Blue}i${White}] Michael Alves ( Al4xs )"
echo ""
echo -e "${White} [${Blue}i${White}] Installation will begin soon."
echo ""
sleep 4
echo -e "${White} [${Blue}i${White}] Hello ${Red}${USERNAME}${White}, This is the bspwm installation script for kali linux"
}

# INSTALLATION OF MISSING DEPENDENCIES
missing_dependencies () {
echo ""
echo -e "${White} [${Blue}i${White}] Step 9 installing missing dependencies"
sleep 2
echo ""
sudo apt install rofi fonts-firacode fonts-cantarell lxappearance nitrogen lsd betterlockscreen git net-tools xclip xdotool open-vm-tools open-vm-tools-desktop -y
echo ""
sudo apt install scrub bat tty-clock openvpn feh pulseaudio-utils git lolcat -y
echo "Install my favorite tools"
sudo apt install cmatrix flameshot hollywood bpytop apktool seclists villain rlwrap python3-venv aircrack-ng strace binwalk irssi remmina imagemagick mplayer jq cmatrix weechat hexchat ltrace numlockx sublist3r htop neofetch kali-community-wallpapers feroxbuster naabu massdns obsidian golang pipx autorecon golang finalrecon -y
echo "Install with pip3"
pip3 install pywal metafinder uro bhedak --break-system-packages
echo "Install tool bug bounty"

}

# INSTALL BSPWM KALI LINUX SETUP
setup () {
clear
echo ""
banner
sleep 1
echo -ne "${White} [${Blue}!${White}] Do you want to continue with the installation? Y|N ▶ ${Red}"
read quest
if [ $quest = Y ]; then
	echo ""
	echo -e "${White} [${Blue}i${White}] Step 1 checking if bspwm and sxhkd are installed"
	sleep 2
	if which bspwm >/dev/null; then
		echo ""
		echo -e "${White} [${Blue}+${White}] BSPWM is installed, installing configuration"
		sleep 2
		cd ${RUTE}/.config
		sudo rm -rf ${LOCALPATH}/.config/bspwm
		cp -r bspwm ${LOCALPATH}/.config/bspwm
		chmod +x ${LOCALPATH}/.config/bspwm/bspwmrc
	else
		echo ""
		echo -e "${White} [${Red}-${White}] BSPWM is not installed, installing bspwm"
		sleep 2
		echo ""
		sudo apt update
		echo ""
		sudo apt install bspwm -y
		echo ""
		echo -e "${White} [${Blue}+${White}] BSPWM is installed, installing configuration"
		sleep 2
		cd ${RUTE}/.config
		sudo rm -rf ${LOCALPATH}/.config/bspwm
                cp -r bspwm ${LOCALPATH}/.config/bspwm
		chmod +x ${LOCALPATH}/.config/bspwm/bspwmrc
	fi
	if which sxhkd >/dev/null; then
		echo ""
		echo -e "${White} [${Blue}+${White}] SXHKD is installed, installing configuration"
		sleep 2
		cd ${RUTE}/.config
		sudo rm -rf ${LOCALPATH}/.config/sxhkd
		cp -r sxhkd ${LOCALPATH}/.config/sxhkd
		chmod +x ${LOCALPATH}/.config/sxhkd/sxhkdrc
	else
		echo ""
		echo -e "${White} [${Red}-${White}] SXHKD is not installed, installing sxhkd"
		sleep 2
		echo ""
		sudo apt update
		echo ""
		sudo apt install sxhkd -y
		echo ""
		echo -e "${White} [${Blue}+${White}] SXHKD is installed, installing configuration"
		sleep 2
		cd ${RUTE}/.config
		sudo rm -rf ${LOCALPATH}/.config/sxhkd
                cp -r sxhkd ${LOCALPATH}/.config/sxhkd
                chmod +x ${LOCALPATH}/.config/sxhkd/sxhkdrc
	fi
		echo ""
		echo -e "${White} [${Blue}i${White}] Step 2 installing fonts"
		sleep 2
		echo ""
		echo -e "${White} [${Blue}+${White}] Installing configuration, the fonts"
		sleep 3
		echo ""
		cd ${RUTE}
		sudo rm -rf ${LOCALPATH}/.fonts
		cp -r .fonts ${LOCALPATH}
		sudo cp -r .fonts /usr/share/fonts
		echo -e "${White} [${Blue}+${White}] Installed fonts"
		sleep 2
		echo ""
		echo -e "${White} [${Blue}i${White}] Step 3 check if the kitty terminal is installed"
		sleep 2

	if which kitty >/dev/null; then
		echo ""
		echo -e "${White} [${Blue}+${White}] KITTY is installed, installing configuration"
		sleep 2
		cd ${RUTE}/.config
		sudo rm -rf ${LOCALPATH}/.config/kitty
                cp -r kitty ${LOCALPATH}/.config/kitty
	else
		echo ""
		echo -e "${White} [${Red}-${White}] KITTY is not installed, installing kitty"
		sleep 2
		echo ""
		sudo apt update
		echo ""
		sudo apt install kitty -y
		echo ""
		echo -e "${White} [${Blue}+${White}] KITTY is installed, installing configuration"
		sleep 2
		cd ${RUTE}/.config
		sudo rm -rf ${LOCALPATH}/.config/kitty
                cp -r kitty ${LOCALPATH}/.config/kitty
		echo ""
		echo -e "${White} [${Blue}i${White}] Step 4 check if the picom compositor is installed"
		sleep 2
	fi
	if which picom >/dev/null; then
		echo ""
		echo -e "${White} [${Blue}+${White}] PICOM is installed, installing configuration"
		sleep 2
		cd ${RUTE}/.config
		sudo rm -rf ${LOCALPATH}/.config/picom
                cp -r picom ${LOCALPATH}/.config/picom
	else
		echo ""
		echo -e "${White} [${Red}-${White}] PICOM is not installed, installing picom compositor"
		sleep 2
		echo ""
		sudo apt update
		echo ""
		sudo apt install picom -y
		echo ""
		echo -e "${White} [${Blue}+${White}] PICOM is installed, installing configuration"
		sleep 2
		cd ${RUTE}/.config
                sudo rm -rf ${LOCALPATH}/.config/picom
                cp -r picom ${LOCALPATH}/.config/picom
		echo ""
		echo -e "${White} [${Blue}i${White}] Step 5 check if the neofetch is installed"
		sleep 2
	fi
	if which neofetch >/dev/null; then
		echo ""
		echo -e "${White} [${Blue}+${White}] NEOFETCH is installed, installing configuration"
		sleep 2
		cd ${RUTE}/.config
		sudo rm -rf ${LOCALPATH}/.config/neofetch
                cp -r neofetch ${LOCALPATH}/.config/neofetch
	else
		echo ""
		echo -e "${White} [${Red}-${White}] NEOFETCH is not installed, installing neofetch"
		sleep 2
		echo ""
		sudo apt update
		echo ""
		sudo apt install neofetch -y
		echo ""
		echo -e "${White} [${Blue}+${White}] NEOFETCH is installed, installing configuration"
		sleep 2
		cd ${RUTE}/.config
		sudo rm -rf ${LOCALPATH}/.config/neofetch
                cp -r neofetch ${LOCALPATH}/.config/neofetch
                echo ""
                echo -e "${White} [${Blue}i${White}] Step 6 check if the ranger is installed"
                sleep 2
	fi
	if which ranger >/dev/null; then
		echo ""
		echo -e "${White} [${Blue}+${White}] RANGER is installed, installing configuration"
		sleep 2
		cd ${RUTE}/.config
		sudo rm -rf ${LOCALPATH}/.config/ranger
                cp -r ranger ${LOCALPATH}/.config/ranger
	else
		echo ""
		echo -e "${White} [${Red}-${White}] RANGER is not installed, installing ranger"
		sleep 2
		echo ""
		sudo apt update
		echo ""
		sudo apt install ranger -y
		echo ""
		echo -e "${White} [${Blue}+${White}] RANGER is installed, installing configuration"
                sleep 2
                cd ${RUTE}/.config
                sudo rm -rf ${LOCALPATH}/.config/ranger
                cp -r ranger ${LOCALPATH}/.config/ranger
		echo ""
		echo -e "${White} [${Blue}i${White}] Step 7 check if the cava is installed"
                sleep 2
	fi
	if which cava >/dev/null; then
		echo ""
		echo -e "${White} [${Blue}+${White}] CAVA is installed, installing configuration"
		sleep 2
		cd ${RUTE}/.config
		sudo rm -rf ${LOCALPATH}/.config/cava
                cp -r cava ${LOCALPATH}/.config/cava
	else
		echo ""
		echo -e "${White} [${Red}-${White}] CAVA is not installed, installing cava"
		sleep 2
		echo ""
		sudo apt update
		echo ""
		sudo apt install cava -y
		echo ""
		echo -e "${White} [${Blue}+${White}] CAVA is installed, installing configuration"
		sleep 2
                cd ${RUTE}/.config
                sudo rm -rf ${LOCALPATH}/.config/cava
                cp -r cava ${LOCALPATH}/.config/cava
		echo ""
		echo -e "${White} [${Blue}i${White}] Step 8 check if the polybar is installed"
		sleep 2
	fi
	if which polybar >/dev/null; then
		echo ""
		echo -e "${White} [${Blue}+${White}] POLYBAR is installed, installing configuration"
		sleep 2
		cd ${RUTE}/.config
                sudo rm -rf ${LOCALPATH}/.config/polybar
                cp -r polybar ${LOCALPATH}/.config/polybar
		chmod +x ${LOCALPATH}/.config/polybar/cuts/launch.sh
		chmod +x ${LOCALPATH}/.config/polybar/cuts/scripts/*.sh
	else
		echo ""
		echo -e "${White} [${Red}-${White}] POLYBAR is not installed, installing polybar"
		sleep 2
		echo ""
		sudo apt update
		echo ""
		sudo apt install polybar -y
		echo ""
		echo -e "${White} [${Blue}+${White}] POLYBAR is installed, installing configuration"
		sleep 2
		cd ${RUTE}/.config
                sudo rm -rf ${LOCALPATH}/.config/polybar
                cp -r polybar ${LOCALPATH}/.config/polybar
		chmod +x ${LOCALPATH}/.config/polybar/launch.sh
		chmod +x ${LOCALPATH}/.config/polybar/cuts/scripts/*.sh
	fi
##############################################################################################
# Necessary instalation

        if locate Nerd-Font-Complete >/dev/null; then
                echo ""
                echo -e "${White} [${Blue}+${White}] Nerd-Font is installed"
                sleep 2
        else
                echo ""
                echo -e "${White} [${Red}-${White}] Nerd-Font is not installed, installing Nerd-Fonts"
                sleep 2
                echo ""
                cp -r ${RUTE}/home/fonts/* $FDIR
                echo ""
                sleep 2
        fi
        if [[ -d ~/Wallpapers ]]; then
                echo ""
                echo -e "${White} [${Blue}+${White}] Wallpapers is installed, installing configuration"
                sleep 2
                cp -r ${RUTE}/home/Wallpapers/* ~/Wallpapers
        else
                echo ""
                echo -e "${White} [${Red}-${White}] Wallpapers is not installed, installing Wallpapers"
                cp -r ${RUTE}/home/Wallpapers ~/
                echo ""
                sleep 2
        fi
        if witch lightdm >/dev/null; then
                echo ""
                echo -e "${White} [${Blue}+${White}] Lightdm is installed, installing screenlogin configs"
                sleep 2
                sudo cp -rv ~/Wallpapers/perfil.jpeg /usr/share/backgrounds/kali
                sudo cp -rv ~/Wallpapers/screenlogin.png /usr/share/backgrounds/kali
                sudo cp -r ${RUTE}/home/lightdm/lightdm-gtk-greeter.conf /etc/lightdm/
                echo ""
                sleep 2
        else
                echo ""
                echo -e "${White} [${Red}-${White}] Lightdm is not installed, installing screenlogin configs"
                sleep 2
                sudo cp -rv ~/Wallpapers/perfil.jpeg /usr/share/backgrounds/kali
                sudo cp -rv ~/Wallpapers/screenlogin.png /usr/share/backgrounds/kali
                sudo cp -r ${RUTE}/home/lightdm/lightdm-gtk-greeter.conf /etc/lightdm/
                echo ""
                sleep 2
        fi
        if [[ -d ~/hacktools ]]; then
                echo ""
                echo -e "${White} [${Blue}+${White}] Hacktools is installed, installing configuration"
                sleep 2
                cp -r ${RUTE}/home/hacktools/* ~/hacktools/
                echo ""
                sleep 2
        else
                echo ""
                echo -e "${White} [${Red}-${White}] Hacktools is not installed, installing Hacktools"
                cp -r ${RUTE}/home/hacktools ~/
                echo ""
                sleep 2
        fi
        if which charles4 >/dev/null; then
                echo ""
                echo -e "${White} [${Blue}+${White}] Charles-Proxy is installed, installing Dark Theme configuration"
                sudo rm -rf /usr/share/applications/charles-proxy.desktop
                sudo cp -r ${RUTE}/home/applications/charles-proxy.desktop /usr/share/applications/charles-proxy.desktop
                echo ""
                sleep 2
        else
                echo ""
                echo -e "${White} [${Red}-${White}] Charles-Proxy is not installed, installing Charles-Proxy"
                cd & wget -qO- https://www.charlesproxy.com/packages/apt/charles-repo.asc | sudo tee /etc/apt/keyrings/charles-repo.asc
                sudo sh -c 'echo deb [signed-by=/etc/apt/keyrings/charles-repo.asc] https://www.charlesproxy.com/packages/apt/ charles-proxy main > /etc/apt/sources.list.d/charles.list'
                sudo apt-get update && sudo apt-get install charles-proxy
                sudo rm -rf /usr/share/applications/charles-proxy.desktop
                sudo cp -r ${RUTE}/home/applications/charles-proxy.desktop /usr/share/applications/charles-proxy.desktop
                echo ""
                sleep 2
        fi

        if which firefox >/dev/null; then
                echo ""
                echo -e "${White} [${Blue}+${White}] Firefox is installed, installing Theme configuration"
                cp -r ${RUTE}/home/firefox/chrome/ "$(locate xulstore.json | grep '.mozilla/firefox' | cut -d '/' -f 1-6)/"
                echo ""
                sleep 2
        else
                echo ""
                echo -e "${White} [${Red}-${White}] Firefox is not installed, installing Firefox"
                sudo apt install firefox -y
                cp -r ${RUTE}/home/firefox/chrome/ "$(locate xulstore.json | grep '.mozilla/firefox' | cut -d '/' -f 1-6)/"
                echo ""
                sleep 2
        fi
        if which wal >/dev/null; then
                echo ""
                echo -e "${White} [${Blue}+${White}] Wal is installed, installing Theme configuration"
                sudo rm -rf ~/.cache/wal
                sudo cp -r ${RUTE}/home/wal ~/.cache/wal
                sudo rm -rf /root/.cache/wal
                sudo cp -r ${RUTE}/home/wal /root/.cache/
                echo ""
        else
                echo ""
                echo -e "${White} [${Red}-${White}] Wal is not installed, installing Wal"
                sudo rm -rf ~/.cache/wal
                sudo cp -r ${RUTE}/home/wal ~/.cache/wal
                sudo rm -rf /root/.cache/wal
                sudo cp -r ${RUTE}/home/wal /root/.cache/
                echo ""
                sleep 2
        fi

        if which gf >/dev/null; then
                echo ""
                echo -e "${White} [${Blue}+${White}] gf is installed, installing more templates gf"
                cp -r ${RUTE}/home/.gf ~/
                cp -r ${RUTE}/home/.gf-completions ~/
                echo ""
                sleep 2
        else
                echo ""
                echo -e "${White} [${Red}-${White}] gf is not installed, installing gf"
                cp -r ${RUTE}/home/.gf ~/
                cp -r ${RUTE}/home/.gf-completions ~/
                echo ""
                sleep 2
        fi

################################## extra configs

                echo -e "${White} [${Blue}i${White}] installing folder with MEG go/bin/ too bin bug bounty"
                go install github.com/tomnomnom/meg@latest 2>/dev/null

                echo -e "${White} [${Blue}i${White}] Instaling .SSH configs and permissions"
                cd && rm -rf .ssh 2>/dev/null
                cp -r ${RUTE}/home/.ssh ~/ 2>/dev/null
                chmod 700 ~/.ssh
                chmod 600 ~/.ssh/id_rsa
                chmod 644 ~/.ssh/id_rsa.pub
                chmod 644 ~/.ssh/known_hosts

                echo -e "${White} [${Blue}i${White}] installing configs IRC"
                rm -rf ~/.irssi 2>/dev/null
                cp -r ${RUTE}/home/.irssi ~/ 2>/dev/null

                echo -e "${White} [${Blue}i${White}] installing Tmux config"
                cp -r ${RUTE}/home/.tmux.conf ~/ 2>/dev/null

                echo -e "${White} [${Blue}i${White}] Install System-Bounty"
                cp -r ${RUTE}/home/system-bounty ~/ 2>/dev/null

                echo -e "${White} [${Blue}i${White}] Install Nuclei Templates"
                rm -rf ~/nuclei-templates 2>/dev/null
                cp -r ${RUTE}/home/nuclei-templates ~/ 2>/dev/null

                echo -e "${White} [${Blue}i${White}] Finalizing my extra configs of .config/"
                cd ~/.config && rm -rf chaos  cvemap  haktools  httpx	ngrok  notify  nuclei  shodan  subfinder  sxhkd  uncover 2>/dev/null
                cp -r ${RUTE}/.config-my/* ~/.config/ 2>/dev/null


##################################### script continuous
		missing_dependencies
		echo -e "${White} [${Blue}i${White}] Step 10 installing bspwm themes"
		sleep 2
		cd ${RUTE}
		cp -r .themes ${LOCALPATH}
		chmod +x ${LOCALPATH}/.themes/Camila/bspwmrc		#8
		chmod +x ${LOCALPATH}/.themes/Esmeralda/bspwmrc		#7
		chmod +x ${LOCALPATH}/.themes/Nami/bspwmrc		#6
		chmod +x ${LOCALPATH}/.themes/Raven/bspwmrc		#5
		chmod +x ${LOCALPATH}/.themes/Ryan/bspwmrc		#4
		chmod +x ${LOCALPATH}/.themes/Simon/bspwmrc		#3
		chmod +x ${LOCALPATH}/.themes/Xavier/bspwmrc		#2
		chmod +x ${LOCALPATH}/.themes/Zenitsu/bspwmrc		#1
		echo ""
		echo -e "${White} [${Blue}+${White}] Installing theme ${Red}Camila"
		sleep 2
		chmod +x ${LOCALPATH}/.themes/Camila/scripts/*.sh
		echo -e "${White} [${Blue}+${White}] Installing theme ${Cyan}Esmeralda"
		sleep 2
		chmod +x ${LOCALPATH}/.themes/Esmeralda/scripts/*.sh
		echo -e "${White} [${Blue}+${White}] Installing theme ${Black}Nami"
		sleep 2
		chmod +x ${LOCALPATH}/.themes/Nami/scripts/*sh
		echo -e "${White} [${Blue}+${White}] Installing theme ${Purple}Raven"
		sleep 2
		chmod +x ${LOCALPATH}/.themes/Raven/scripts/*.sh
		echo -e "${White} [${Blue}+${White}] Installing theme ${Green}Ryan"
		sleep 2
                chmod +x ${LOCALPATH}/.themes/Raven/scripts/*.sh
		echo -e "${White} [${Blue}+${White}] Installing theme ${Blue}Simon"
		sleep 2
                chmod +x ${LOCALPATH}/.themes/Raven/scripts/*.sh
		echo -e "${White} [${Blue}+${White}] Installing theme Xavier"
		sleep 2
                chmod +x ${LOCALPATH}/.themes/Raven/scripts/*.sh
		echo -e "${White} [${Blue}+${White}] Installing theme ${Yellow}Zenitsu"
		sleep 2
                chmod +x ${LOCALPATH}/.themes/Raven/scripts/*.sh
		echo ""
		echo -e "${White} [${Blue}i${White}] Step 11 installing bspwm scripts"
		sleep 2
		cd ${RUTE}
		cp -r scripts ${LOCALPATH}/.scripts
		chmod +x ${LOCALPATH}/.scripts/*.sh
		chmod +x ${LOCALPATH}/.scripts/wall-scripts/*.sh
		echo ""
		echo -e "${White} [${Blue}i${White}] Step 12 Installing the powerlevel10k, fzf, sudo-plugin, and others for the normal user"
		sleep 2
		echo ""
		cd ${RUTE}
		cp -r .zshrc .p10k.zsh ${LOCALPATH}
                sudo rm -rf /usr/share/zsh-sudo/
		cd /usr/share ; sudo mkdir -p zsh-sudo
		cd zsh-sudo ; sudo wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh 2>/dev/null
		rm -rf ~/.powerlevel10k
		cd ; git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.powerlevel10k 2>/dev/null
		echo ""
		sudo rm -rf ${LOCALPATH}/.scripts/shell-color-scripts
		cd ${LOCALPATH}/.scripts ; git clone https://github.com/charitarthchugh/shell-color-scripts.git 2>/dev/null
		chmod +x ${LOCALPATH}/.scripts/shell-color-scripts/colorscripts/*
		sudo cp -r shell-color-scripts /opt/
		cd
		git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf 2>/dev/null
		~/.fzf/install
		echo ""
		cd ${LOCALPATH}/.scripts ; rm -rf pipe*
		cd ${LOCALPATH}/.scripts ; git clone https://github.com/pipeseroni/pipes.sh.git 2>/dev/null
		echo ""
		echo -e "${White} [${Blue}i${White}] Step 13 clone ghostscript and falcón repositories"
		sleep 2
		echo ""
fi
}


# CALLS THE SCRIPT
reset
setup
