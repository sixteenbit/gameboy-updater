# Sixteenbit Installer

Provisioning scripts for RetroPie 4.4 to be used with Gameboy Zero.

## Running the installer

1. Download RetroPie from the [official site](https://retropie.org.uk/download/)
1. Flash the .img to an SD card (e.g. using [Etcher](https://etcher.io/) or [Apple Pi Baker](https://www.tweaking4all.com/software/macosx-software/macosx-apple-pi-baker/))
1. Enable WIFI and SSH
1. `git clone https://github.com/sixteenbit/sixteenbit-installer.git`
1. `cd sixteenbit-installer`
1. `sudo ./install.sh YES`
1. `sudo ./MintyInstall.sh` (optional)
1. `reboot`

## Credits

Installer script originally built by [Kite](https://github.com/kiteretro/Circuit-Sword) for the Circuit Sword but has been re-purposed for Gameboy Zero.

MintyBatteryMonitor is a modified version of [HoolyHoo's](https://github.com/HoolyHoo/Mintybatterymonitor).
