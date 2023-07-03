#!/bin/bash
# Made by DarDarDar, 2022
# wineORC 2.8+ by PlaceholderLabs, 2023

if [ $EUID == "0" ]; then
	echo "Please run this script as a non-root. "
	exit
fi

if [ "$1" == "--version" ]
then
	echo "Wineorc v2.8 "
	echo "License: MIT (see https://github.com/PlaceholderLabs/wineORC/blob/main/LICENSE) "
	exit
fi

if [ "$1" == "--help" ]
then
	echo "wineORC: The only script that matters (real) "
	echo "Usage: ./wineorc.sh [OPTION]... "
	echo ""
	echo "Options: "
	echo "	uninstall: uninstalls a selected private server from a list of options "
	echo "	dxvk: installs dxvk, the directx to vulkan translation layer, to a wineprefix from a list of options. this can drastically improve performance in some private servers "
	echo "	--version: prints the version of wineorc that is being ran "
	echo "	--help: what you're reading right now, you idiot "
	echo ""
	echo "Example: "
	echo "	./wineorc.sh dxvk "
	exit
fi

uninstall ()
{
	echo "Uninstalling $CURRENT now.. "
	sleep 3
	if [ $CURRENT == "Placeholder" ]
	then
		rm $HOME/.placeholder -rf
		sudo rm /usr/share/applications/placeholder.desktop
	fi
	if [ $CURRENT == "ItteBlox" ]
	then
		rm $HOME/.itteblox -rf
		sudo rm /usr/share/applications/itteblox.desktop
	fi
	if [ $CURRENT == "SyntaxEco" ]
	then
		rm $HOME/.tadah -rf
		sudo rm /usr/share/applications/syntaxeco.desktop
	fi
	sudo update-desktop-database
	echo "Uninstall done. Run the script again if you'd like to reinstall. "
        exit
}

if [ "$1" == "uninstall" ] || [ "$2" == "uninstall" ]
then
	echo "Please select the revival you'd like to uninstall: "
	echo "1. Placeholder "
	echo "2. ItteBlox "
	echo "3. SyntaxEco "
	read UNINSTALLOPT 
	if [ $UNINSTALLOPT == "1" ]
	then
		CURRENT="Placeholder"
		uninstall
	fi
	if [ $UNINSTALLOPT == "2" ]
	then
		CURRENT="ItteBlox"
	 	uninstall	
	fi
	if [ $UNINSTALLOPT == "3" ]
	then
		CURRENT="SyntaxEco"
		uninstall
	fi
fi
if [ "$1" == "dxvk" ] || [ "$2" == "dxvk" ]
then
	echo "Please select the wineprefix you'd like DXVK to install to: "
	echo "1. Placeholder wineprefix "
	echo "2. ItteBlox wineprefix "
	echo "3. SyntaxEco wineprefix "
	read DXVKOPT
	mkdir $HOME/tmp
	cd $HOME/tmp
	wget https://github.com/doitsujin/dxvk/releases/download/v2.0/dxvk-2.0.tar.gz
	tar -xf dxvk-2.0.tar.gz
	cd dxvk-2.0
	if [ $DXVKOPT == "1" ]
	then
		WINEPREFIX=$HOME/.placeholder ./setup_dxvk.sh install
	fi
        if [ $DXVKOPT == "2" ]
        then
                WINEPREFIX=$HOME/.itteblox ./setup_dxvk.sh install
        fi
	if [ $DXVKOPT == "3" ]
	then
		WINEPREFIX=$HOME/.syntaxeco ./setup_dxvk.sh install
	fi
	cd $HOME
	rm tmp -rf
	echo "DXVK has been installed to selected wineprefix. "
	exit
fi

wineinstaller ()
{
    echo "Please accept any prompts it gives you, and enter your password if necessary. "
    sleep 3
    DISTRO=`cat /etc/*release | grep DISTRIB_ID | cut -d '=' -f 2` # gets distro name
    if [ $DISTRO == "Ubuntu" ] || [ $DISTRO == "LinuxMint" ] || [ $DISTRO == "Pop" ]
    then 
        sudo dpkg --add-architecture i386 # wine installation prep
	sudo mkdir -pm755 /etc/apt/keyrings
	sudo wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
        VERSION=`lsb_release --release | cut -f2`
        if [ $VERSION == "22.04" ] || [ $VERSION == "21" ]
			        then 
				        wget -nc https://dl.winehq.org/wine-builds/ubuntu/dists/jammy/winehq-jammy.sources
				        sudo mv winehq-jammy.sources /etc/apt/sources.list.d/
        fi
        if [ $VERSION == "21.10" ]
			        then 
         				wget -nc https://dl.winehq.org/wine-builds/ubuntu/dists/impish/winehq-impish.sources
				        sudo mv winehq-impish.sources /etc/apt/sources.list.d/
        fi
        if [ $VERSION == "20.04" ] || [ $VERSION == "20.3" ]
			        then 
				        wget -nc https://dl.winehq.org/wine-builds/ubuntu/dists/focal/winehq-focal.sources
				        sudo mv winehq-focal.sources /etc/apt/sources.list.d/
        fi			
        if [ $VERSION == "18.04" ] || [ $VERSION == "19.3" ] 
			        then 
				        wget -nc https://dl.winehq.org/wine-builds/ubuntu/dists/bionic/winehq-bionic.sources
				        sudo mv winehq-bionic.sources /etc/apt/sources.list.d/
        fi
        sudo apt update
        sudo apt install --install-recommends winehq-staging
    fi
    if [ $DISTRO == "Debian" ]
    then
        echo "If this fails, then a 32-bit multiarch does not exist. You should make one by following this guide: https://wiki.debian.org/Multiarch/HOWTO "
        sleep 3
        sudo apt-get install wine-development 
    fi
    if [ $DISTRO == "ManjaroLinux" ]
    then
        echo "If this fails, then the multilib repo is disabled in /etc/pacman.conf. The dependencies cannot be installed if this is disabled, so please enable it. "
        sleep 3
        sudo pacman -S wine-staging wine-mono expac # Arch Linux wine comes with a incredibly minimal package, so let's use expac to download everything it needs
	sudo pacman -S $(expac '%n %o' | grep ^wine)
    fi
    if [ $DISTRO == "Fedora" ]
    then
        sudo dnf install wine
    fi

    if [ $DISTRO == "Gentoo" ]
    then
        sudo emerge --ask virtual/wine-staging
    fi
    if [ ! -x /usr/bin/wine ]
    then
        echo "It seems the script couldn't install wine for you. Please install it manually. "
	exit
    fi
}

winecheck ()
{
    if [ ! -x /usr/bin/wine ]
    then
        read -p "Wine doesn't seem to be installed. This is required for the script to run. Would you like the script to install it for you? [y/n] " WINEINSTALLOPT
        if [ $WINEINSTALLOPT = "y" ]
        then
            wineinstaller
        else
            echo "OK, the script *won't* install wine for you. Please kill the script and install it manually. If you're sure it's installed, then don't kill the script. "
            sleep 3
        fi
    else
        echo "wine is installed, skipping check.. "
    fi
}

othercheck ()
{
	if [ ! -x /usr/bin/wget ]
	then
		echo "wget seems to not be installed. Please kill the script then install wget via your package manager. "
		echo "If you're sure it's installed, then don't kill the script. "
		sleep 3
	else
		echo "wget is installed, skipping check.. "
	fi
	if [ $CURRENT == "ItteBlox" ] || [ $CURRENT == "Placeholder" ] || [ $CURRENT == "SyntaxEco" ]
	then	
		if [ ! -x /usr/bin/curl ]
		then
			echo "curl seems to not be installed. Please kill the script then install curl via your package manager. "
			echo "If you're sure it's installed, then don't kill the script. "
			sleep 3
		else
			echo "curl is installed, skipping check.. "
		fi
	fi
}

uri ()
{
	if [ $CURRENT == "ItteBlox" ]
	then
	        touch itteblox.desktop
		echo "[Desktop Entry]" >> itteblox.desktop
		echo "Name=Itteblox Player" >> itteblox.desktop
		echo "Comment=https://ittblox.gay/" >> itteblox.desktop
		echo "Type=Application" >> itteblox.desktop
		echo "Exec=env WINEPREFIX=$HOME/.itteblox wine $HOME/.itteblox/drive_c/users/$USER/AppData/Local/ItteBlox/Versions/$ITTEBLOXVER/ItteBloxPlayerLauncher.exe %U" >> itteblox.desktop
		echo "MimeType=x-scheme-handler/ittblx-player" >> itteblox.desktop
	fi
	if [ $CURRENT == "Placeholder" ]
	then
		touch placeholder.desktop
		echo "[Desktop Entry]" >> placeholder.desktop
		echo "Name=Placeholder Player" >> placeholder.desktop
		echo "Comment=https://placeholder16.tk/" >> placeholder.desktop
		echo "Type=Application" >> placeholder.desktop
		echo "Exec=env WINEPREFIX=$HOME/.placeholder wine $HOME/.placeholder/drive_c/users/$USER/AppData/Local/Placeholder/Versions/$PLACEHOLDERVER/PlaceholderPlayerLauncher.exe %u" >> placeholder.desktop
		echo "MimeType=x-scheme-handler/placeholder-player-placeholder16" >> placeholder.desktop
	fi
	if [ $CURRENT == "SyntaxEco" ]
	then
		touch syntaxeco.desktop
		echo "[Desktop Entry]" >> syntaxeco.desktop
		echo "Name=Syntax" >> syntaxeco.desktop
		echo "Comment=https://syntax.eco" >> syntaxeco.desktop
		echo "Type=Application" >> syntaxeco.desktop
		echo "Exec=env WINEPREFIX=$HOME/.syntaxeco wine $HOME/.syntaxeco/drive_c/users/$USER/AppData/Local/Syntax/Versions/$SYNTAXVER/SyntaxPlayerLauncher.exe %u" >> syntaxeco.desktop
		echo "MimeType=x-scheme-handler/roblox-player-syntax" >> syntaxeco.desktop
	fi
	sudo mv *.desktop /usr/share/applications
	sudo update-desktop-database
}

itteblox ()
{
	winecheck
	othercheck
	echo "$CURRENT is now being installed, please wait as this may take some time. "
        sleep 3
	ITTEBLOXVER=`curl https://setup.ittblox.gay/version/` # we'll need this for uri
	mkdir $HOME/.itteblox
	WINEPREFIX=$HOME/.itteblox winecfg -v win10
	mkdir $HOME/tmp
	cd $HOME/tmp
	wget https://setup.ittblox.gay/ItteBloxPlayerLauncher.exe
	WINEPREFIX=$HOME/.itteblox wine ItteBloxPlayerLauncher.exe
	wineserver -k
	uri
}

placeholder ()
{
	winecheck
	othercheck
	echo "$CURRENT is now being installed, please wait as this may take some time. "
        sleep 3
	PLACEHOLDERVER=`curl https://setup.placeholder16.tk/version` # uri
	mkdir $HOME/.placeholder
	WINEPREFIX=$HOME/.placeholder winecfg -v win10
	mkdir $HOME/tmp
	cd $HOME/tmp
	wget https://setup.placeholder16.tk/PlaceholderPlayerLauncher.exe
	echo "Your browser may open to the Placeholder website when this is ran. Just close it. "
	WINEPREFIX=$HOME/.placeholder wine PlaceholderPlayerLauncher.exe
	uri
}

syntaxeco ()
{
	winecheck
	othercheck
	echo "$CURRENT is now being installed, please wait as this may take some time. "
 	echo "$CURRENT is untested and new, please practice some caution with this private-server."
        sleep 3
	PLACEHOLDERVER=`curl https://setup.syntax.eco/version` # uri
	mkdir $HOME/.syntaxeco
	WINEPREFIX=$HOME/.syntaxeco winecfg -v win10
	mkdir $HOME/tmp
	cd $HOME/tmp
	wget https://www.syntax.eco/static/SyntaxPlayerLauncher.exe # BRO, WHY DID HE NOT JUST FOLLOW THE CDN SCHEMA FULLY?
	echo "Your browser may open to the SyntaxEco website when this is ran. Just close it. "
	WINEPREFIX=$HOME/.syntaxeco wine SyntaxPlayerLauncher.exe
	uri
}


echo "Welcome to Wineorc, please select an revival to install. (see --help for other options) "
echo "1. Placeholder "
echo "2. ItteBlox "
echo "3. SyntaxEco "
read OPT
if [ $OPT == "1" ]
then
	CURRENT="Placeholder"
	placeholder
fi
if [ $OPT == "2" ]
then
	CURRENT="ItteBlox"
	itteblox	
fi
if [ $OPT == "3" ]
then
	CURRENT="SyntaxEco"
	syntaxeco
fi


wineserver -k
cd $HOME
rm tmp -rf
echo "$CURRENT should now be installed! Try playing a game and it should work! "
exit

