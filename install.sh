#!/bin/bash

#
# Author: Justin Peacock
#
# THIS HEADER MUST REMAIN WITH THIS FILE AT ALL TIMES
#
# This firmware is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This firmware is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this repo. If not, see <http://www.gnu.org/licenses/>.
#

if [ "$EUID" -ne 0 ]
  then echo "Please run as root (sudo)"
  exit 1
fi

if [ $# == 0 ] || [ $# == 3 ] ; then
  echo "Usage: ./<cmd> YES [branch] [fat32 root] [ext4 root]"
  exit 1
fi

#####################################################################
# Vars

if [[ $3 != "" ]] ; then
  DESTBOOT=$3
else
  DESTBOOT="/boot"
fi

if [[ $4 != "" ]] ; then
  DEST=$4
else
  DEST=""
fi

GITHUBPROJECT="gameboy-zero-setup"
GITHUBURL="https://github.com/sixteenbit/$GITHUBPROJECT"
PIHOMEDIR="$DEST/home/pi"
BINDIR="$PIHOMEDIR/$GITHUBPROJECT"
USER="pi"

if [[ $2 != "" ]] ; then
  BRANCH=$2
else
  BRANCH="master"
fi

#####################################################################
# Functions
execute() { #STRING
  if [ $# != 1 ] ; then
    echo "ERROR: No args passed"
    exit 1
  fi
  cmd=$1

  echo "[*] EXECUTE: [$cmd]"
  eval "$cmd"
  ret=$?

  if [ $ret != 0 ] ; then
    echo "ERROR: Command exited with [$ret]"
    exit 1
  fi

  return 0
}

exists() { #FILE
  if [ $# != 1 ] ; then
    echo "ERROR: No args passed"
    exit 1
  fi

  file=$1

  if [ -f $file ]; then
    echo "[i] FILE: [$file] exists."
    return 0
  else
    echo "[i] FILE: [$file] does not exist."
    return 1
  fi
}

#####################################################################
# LOGIC!
echo "INSTALLING.."

# Checkout code if not already done so
if ! exists "$BINDIR/LICENSE" ; then
    execute "git clone --recursive --depth 1 --branch $BRANCH $GITHUBURL $BINDIR"
fi
execute "chown -R $USER:$USER $BINDIR"

#####################################################################
# Copy required to /boot

if ! exists "$DESTBOOT/config_ORIGINAL.txt" ; then
  execute "cp $DESTBOOT/config.txt $DESTBOOT/config_ORIGINAL.txt"
  execute "cp $BINDIR/settings/config.txt $DESTBOOT/config.txt"
fi

#####################################################################
# Copy required to /

# Copy splashscreens
execute "cp $BINDIR/splashscreens/GBZ-Splash-Screen.mp4 $PIHOMEDIR/RetroPie/splashscreens/GBZ-Splash-Screen.mp4"

# Copy USB sound
execute "cp $BINDIR/settings/asound.conf $DEST/etc/asound.conf"

# Fix splashsreen sound
if exists "$DEST/etc/init.d/asplashscreen" ; then
    execute "sed -i \"s/ *both/ alsa/\" $DEST/etc/init.d/asplashscreen"
fi
if exists "$DEST/opt/retropie/supplementary/splashscreen/asplashscreen.sh" ; then
    execute "sed -i \"s/ *both/ alsa/\" $DEST/opt/retropie/supplementary/splashscreen/asplashscreen.sh"
fi

# Fix N64 audio
if exists "$DEST/opt/retropie/emulators/mupen64plus/bin/mupen64plus.sh" ; then
    execute "sed -i \"s/mupen64plus-audio-omx/mupen64plus-audio-sdl/\" $DEST/opt/retropie/emulators/mupen64plus/bin/mupen64plus.sh"
fi

# Fix C64 audio
if ! exists "$PIHOMEDIR/.vice/sdl-vicerc" ; then
      execute "mkdir -p $PIHOMEDIR/.vice/"
      execute "echo 'SoundOutput=2' > $PIHOMEDIR/.vice/sdl-vicerc"
fi

# Install the gbz35 theme and set it as default
if ! exists "$DEST/etc/emulationstation/themes/gbz35/gbz35.xml" ; then
    execute "mkdir -p $DEST/etc/emulationstation/themes"
    execute "rm -rf $DEST/etc/emulationstation/themes/gbz35"
    execute "git clone --recursive --depth 1 --branch master https://github.com/rxbrad/es-theme-gbz35.git $DEST/etc/emulationstation/themes/gbz35"
    execute "cp $BINDIR/settings/es_settings.cfg $DEST/opt/retropie/configs/all/emulationstation/es_settings.cfg"
    execute "sed -i \"s/carbon/gbz35/\" $DEST/opt/retropie/configs/all/emulationstation/es_settings.cfg"
    execute "chown $USER:$USER $DEST/opt/retropie/configs/all/emulationstation/es_settings.cfg"
fi

# Install the gbz35-dark theme
if ! exists "$DEST/etc/emulationstation/themes/gbz35-dark/gbz35.xml" ; then
    execute "mkdir -p $DEST/etc/emulationstation/themes"
    execute "rm -rf $DEST/etc/emulationstation/themes/gbz35-dark"
    execute "git clone --recursive --depth 1 --branch master https://github.com/rxbrad/es-theme-gbz35-dark.git $DEST/etc/emulationstation/themes/gbz35-dark"
fi

# Install the pixel theme and set it as default
if ! exists "$DEST/etc/emulationstation/themes/pixel/system/theme.xml" ; then
    execute "mkdir -p $DEST/etc/emulationstation/themes"
    execute "rm -rf $DEST/etc/emulationstation/themes/pixel"
    execute "git clone --recursive --depth 1 --branch master https://github.com/kiteretro/es-theme-pixel.git $DEST/etc/emulationstation/themes/pixel"
fi

# Enable 30sec autosave on roms
execute "sed -i \"s/# autosave_interval =/autosave_interval = \"30\"/\" $DEST/opt/retropie/configs/all/retroarch.cfg"

# Disable 'wait for network' on boot
execute "rm -f $DEST/etc/systemd/system/dhcpcd.service.d/wait.conf"

# Enable /tmp as a tmpfs (ramdisk)
if [[ $(grep '/ramdisk' $DEST/etc/fstab) == "" ]] ; then
    execute "echo 'tmpfs    /ramdisk    tmpfs    defaults,noatime,nosuid,size=1m    0 0' >> $DEST/etc/fstab"
fi

#####################################################################
# DONE
echo "DONE!"
