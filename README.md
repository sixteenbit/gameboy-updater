# Gameboy Zero Setup

Scripts for setting up RetroPie on a Gameboy Zero.

## What's in the box

1. Optimized [config.txt](settings/config.txt) which includes overclocking
1. Download Gameboy Zero splashscreen by [AJRedfern](https://www.sudomod.com/forum/viewtopic.php?f=8&t=1440)
1. USB audio setup
1. Fix for splashscreen audio when using USB audio
1. Fix N64 audio
1. Fix C64 audio
1. Install the gbz35 theme and set it as default
1. Install the gbz35-dark, freeplay, and pixel themes
1. Enable 30sec autosave on roms
1. Disable 'wait for network' on boot
1. Enable /tmp as a tmpfs (ramdisk)

## Running the installer

1. Download RetroPie from the [official site](https://retropie.org.uk/download/)
1. Flash the .img to an SD card (e.g. using [Etcher](https://etcher.io/) or [Apple Pi Baker](https://www.tweaking4all.com/software/macosx-software/macosx-apple-pi-baker/))
1. Enable WIFI and SSH
1. `git clone https://github.com/sixteenbit/gameboy-zero-setup.git`
1. `cd sixteenbit-installer`
1. `sudo ./install.sh YES`
1. `sudo reboot now`

## Post installation

### Install Battery Monitor

This is a [modified version](https://github.com/sixteenbit/Mintybatterymonitor) of HoolyHoo's [Mintybatterymonitor](https://github.com/HoolyHoo/Mintybatterymonitor).

1. `wget https://raw.githubusercontent.com/sixteenbit/Mintybatterymonitor/master/MintyInstall.sh`
1. `sudo git clone https://github.com/sixteenbit/Mintybatterymonitor.git`
1. `sudo ./MintyInstall.sh`
1. `sudo reboot now`

### Install Retrogame

```bash
cd; curl https://raw.githubusercontent.com/adafruit/Raspberry-Pi-Installer-Scripts/master/retrogame.sh >retrogame.sh
sudo bash retrogame.sh
```


## Credits

- Installer script originally built by [Kite](https://github.com/kiteretro/Circuit-Sword) for the Circuit Sword but has been re-purposed for Gameboy Zero.
- MintyBatteryMonitor is a modified version of [HoolyHoo's](https://github.com/HoolyHoo/Mintybatterymonitor).
- Splashscreen was created by [AJRedfern](https://www.sudomod.com/forum/viewtopic.php?f=8&t=1440)
