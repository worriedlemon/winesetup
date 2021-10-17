#!/bin/bash

if [[ "$(whoami)" == "root" ]]
	echo "It is deprecated to use root privileges with WINE configuration."
	echo -r -p "Do you wish to close the program? [Y/N]: " answer
	case $answer in
		[Yy]* ) exit;;
		* ) break;;
	esac
fi

if [[ "$(sudo apt list --installed | grep wine32)" == "" ]]
	echo "32-bit version of WINE isn't installed! Please install full WINE with command:"
	echo "$ sudo ./winesutup.sh"
	exit
fi

echo "WINE full installation is completed. WINE condiguration in process..."
echo "You will need to ask some questions, after that close the window."
WINEARCH="win64" WINEPREFIX="$home/.wine" winecfg
echo "Winetricks update needed..."
winetricks --self-update
echo "Installing additional Winodows dynamic libraries..."
winetricks corefonts dxvk vcrun2008 vcrun2010 vcrun2012
echo "Done. WINE should be working fine."
