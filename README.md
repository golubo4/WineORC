<div align="center" class="tip" markdown="1" style>

![wineorc logo](https://raw.githubusercontent.com/DarDarDoor/Wineorc/main/photos/Wineorclogo.png)
![wine ver](https://img.shields.io/badge/wine-7.12-red) ![repo ver](https://img.shields.io/badge/Current%20version-2.0-success) ![lol](https://img.shields.io/badge/Pretty-cool-informational)
</div>

# 🍷 Some simple Shell scripts to setup ORC revivals automatically on Linux.

These scripts are not supported in any way, shape or form by the official devs of these revivals.

## ⚡ What this does
This script will download dependencies, register URI and install the revival of choice. It can also install DXVK, use/make a custom Wineprefix (tadah and placeholder only) and uninstall the revival of choice.

## ⚠️ Requirements
The needed packages are:
- sudo
- The latest wine (obv, preferably wine-staging)
- wget
- unzip (for Itteblox only)
The script can install WINE for you. However, only some distros are supported, so if it fails then you should install WINE and the other dependencies manually.

## 💻 How to use it

1. Download the latest release from the Releases page (or just clone this repo via git)
2. Open a terminal and cd into where the script is downloaded.
3. Run `chmod +x *.sh` (which will make all Shell files in that directory executable)
4. Run `./wineorc.sh`
5. Once installed, play a game and it should work!

See `./wineorc.sh --help` for all available options.

## ❗ Troubleshooting
If the game crashes/doesn't launch, try to:

1. Run the latest version of the installer again (make sure you're running it as non-root)
2. Make sure all necessary optional wine dependencies are installed https://wiki.winehq.org/Building_Wine#Satisfying_Build_Dependencies

If those don't work, DM me on Discord: DarDarDar#3429.

## 🗡️ Known issues

Polygon 2012 seems to not work

## Credits
calones for helping me, and putting up with me being dumb

thexkey for helping me alot making the Placeholder helper

itteh, pizzaboxer, kinery and thexkey for making great revivals
