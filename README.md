# smolubuntu

# What is it?

With build.sh you will have everything you need to create your own Ubuntu Live USB .ISO!
The default values creates a .ISO that contains auto-login and auto-executes my "urbancompasspony/live" code.

For now it will create somenthing that has 1.1 Gb and just OpenBox as option to startup some GUI. 
Everything is running under TTY.

# Dependencies

Using Ubuntu 22.04 LTS as base system, install these packages:
build-essential debootstrap mtools squashfs-tools xorriso casper lib32gcc-s1

## Since Ubuntu 22.04 the packages lupin-casper and lib32gcc are deprecated. We will use casper and lib32gcc-s1 instead.

# Running

Since do you have everything up-to-date on your system, download the code (and the settings folder, is important);
Put it inside a folder that does not have spaces! Like your /home/$USER/smolubuntu.
Now run build.sh and wait... take a coffee. Or a sleep.

For me in a Ryzen 3 and M.2 NVME, the build finishes after 25 minutes.
It can be more or less, depends of your hardware and how much packages do you want inside it.
Remember, if you want to have a full desktop like Gnome Shell or KDE, the ISO will grow up to 4 Gb or more; and this will take
more to finish, around from 2-4 Hours for every build made!
Choose wisely to run less unnecessary builds.

# Customization

Everything under "settings" folder is going to root / inside the final .ISO!
For example, I put a custom .bashrc code with some options and a custom script to launch my "urbancompasspony/live" code after login.
This .bashrc will be the default for the default LiveUSB user "ubuntu".
Everything that is going to show up inside /home/$USER/ need to be placed under "settings/etc/skel".

With this structure you can change backgrounds or even themes! You can change every folder in the system.
Be creative here!
