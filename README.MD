# WINE full installation on Focal Fossa kernels (Ubuntu 20.04/Linux Mint 20.x)

## Overview

This program is used to automatize the installation of needed packages to run Windows applications on Linux using WINE.

## Installation

The script must be configured as *executable*:

`$ chmod a+x ./winesetup.sh`

To start the installation you need to start the script **winesetup.sh** with root privileges:

`$ sudo ./winesetup.sh`

## Configuration

The second script is used to configure your WINE prefix with necessary packages, such as *MS Corefonts* and *DXVK*.
It is also should be marked as executable. You **SHOULD NOT** start the script with root privileges.

```
$ chmod a+x ./wineconfig.sh
$ ./wineconfig.sh
```
