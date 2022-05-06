# smolubuntu

# What is it?

With build.sh you will have everything you need to create your own Ubuntu Live USB .ISO!
The default values creates a .ISO that contains auto-login and auto-executes my "urbancompasspony/live" code.

For now it has 1.1 Gb and just OpenBox as option to startup some GUI. Everything is runned under TTY.

# Dependencies

Using Ubuntu 22.04 LTS as base system, install these packages:
build-essential debootstrap mtools squashfs-tools xorriso casper lib32gcc-s1

## Since Ubuntu 22.04 the packages lupin-casper and lib32gcc are deprecated. We will use casper and lib32gcc-s1 instead.

# Running

WIP

Some important path:
sudo cp -rfv settings/* $HOME/$name/chroot/
Will customize the file system and add everything under settings folder to /!
A new wallpaper? A script under .config/caja? Or maybe some mountpoints inside /mnt, even config inside /etc, there is no limit!
