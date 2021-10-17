#!/bin/bash

# Compatibility tests
systemid=$(cat /etc/os-release | grep ^ID= | cut -c4-)
if [[ "$systemid" != "linuxmint" ]] | [[ "$systemid" != "ubuntu" ]]; then
	echo "Your system is imcompatible \(param ID=$systemid\). Param value \'ubuntu\' or \'linuxmint\' is needed!"
	exit
fi

if [[ "$(dpkg --print-architecture)" != "amd64" ]]; then
	echo "Your system is imcompatible \(param ARCH=$(dpkg --print-architecture)\). Param value \'amd64\' is needed!"
	exit
fi

if [[ "$(whoami)" != "root" ]]; then
	echo "Consider using root privileges to start this script with:"
	echo "$ sudo ./winesetup.sh"
	exit
fi

# The beginning

echo
echo "This Setup Wizard is going to fully install WINE on your Focal Fossa machine."
if [[ "$(dpkg --print-foreign-architectures)" == "" ]]; then
	echo "For correct WINE implementetion it is recommended to enable 32-bit architecture..."
	dpkg -add-architecture i386
	echo "Succeed!"
fi

echo
echo "Firstly, the necessary package \'libfaudio0\' of both architectures should be installed. It is highly recommended to make a back-up of your system before installing outdated packages."

read -r -p "Do you let the wizard download it right now? (Y/N): " answer
case $answer in
    [Yy]* ) echo "Downloading started.";break;;
    [Nn]* ) echo "Operation suspended.";exit;;
    * ) echo "Operation suspended.";exit;;
esac

wget -nc https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_18.04/amd64/libfaudio0_19.07-0~bionic_amd64.deb
wget -nc https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_18.04/i386/libfaudio0_19.07-0~bionic_i386.deb

echo
echo "Please Install downloaded packages by yourself, as some managers don't install additional packages."
read -r -p "If you wish the wizart to try to install those packages write [Y]. Write anything else to dismiss or if you already installed them: " answer
case $answer in
	[Yy]* ) echo "Installing in process..."; dpkg -i ./libfaudio0_19.07-0~bionic_amd64.deb ./libfaudio0_19.07-0~bionic_i386.deb; break;;
	* ) if [[ "$(sudo apt list --installed | grep libfaudio0 | grep i386)" != "" ]]; then
			echo "\'libfaudio0\' packages found. Installation goes on..."
			break
		else
			echo "\'libfaudio0\' packages not found. You have to install them."
			exit
		fi;
esac

# Installing additional packages.

echo
echo "Continuing on installation of additional 32-bit packages."
apt-get install -y libdrm2=2.4.101-2 libdrm:i386=2.4.101-2
apt-get install -y ia32libs
apt-get install -y mesa-utils vulkan-icd vulkan-icd:i386 vulkan-tools vulkan-utils mesa-vulkan-drivers mesa-vulkan-drivers:i386
echo Completed.

# Installing WINE packages.

echo
echo "WINE installation began."
read -r -p "Install WINEHQ packages (current stable version - 6.0.1)? (Y/N): " answer
case $answer in
    [Yy]* ) echo "Downloading started.";break;;
    [Nn]* ) echo "Installing original WINE 5.0.3.";break;;
    * ) echo "Treated as \'N\'. Installing original WINE 5.0.3.";break;;
esac

if [[ "$answer" == [Yy]* ]]; then
	echo "Getting WINEHQ key..."
	wget -nc "https://dl.winehq.org/wine-builds/winehq.key"
	echo "Installing key..."
	apt-key add winehq.key
	echo "Cleaning up..."
	rm winehq.key
	echo "Adding WINEHQ repository and updating..."
	add-apt-repository -y 'deb https://dl.winehq.org/wine-builds/ubuntu/ focal main'
	apt update
	echo "Installing WINE 6.0.1..."
	apt-get install -y winehq-stable winetricks
else
	echo "Installing WINE 5.0.3..."
	apt-get install -y wine-stable
fi

# Updating downgraded packages

echo
echo "Executing post-installation updates."
apt-get install -y libfaudio0=20.04-2 libfaudio0:i386=20.04-2 libdrm2=2.4.105-3~20.04.1 libdrm2:i386=2.4.105-3~20.04.1
read -r -p "Enter any key to exit installation. " answer
