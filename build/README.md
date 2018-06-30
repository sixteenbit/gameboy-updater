# Get pre-compiled kernel
https://github.com/kiteretro/rpi-precompiled-kernels

# Build
```
cd Circuit-Sword/build

chmod +x upgrade-kernel.sh build-image.sh

wget https://github.com/RetroPie/RetroPie-Setup/releases/download/4.4/retropie-4.4-rpi1_zero.img.gz
gunzip retropie-4.4-rpi1_zero.img.gz

sudo ./upgrade-kernel.sh YES retropie-4.4-rpi1_zero.img pi_4.14.14-v7+.zip

sudo ./build-image.sh YES retropie-4.4-rpi1_zero_pi_4.14.14-v7+.img
```

Burn resulting .img to SD and boot!
