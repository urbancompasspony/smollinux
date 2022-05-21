# smolubuntu

# What is it?

With build.sh you will have everything you need to create your own Ubuntu Live USB .ISO!
The default values creates a .ISO that contains auto-login and auto-executes my "urbancompasspony/live" code.

For now it will create somenthing that has 1.1 Gb and just OpenBox as option to startup some GUI. 
Everything is running under TTY.

# Dependencies

Using Ubuntu 22.04 LTS as base system, install these packages:
sudo apt install build-essential debootstrap mtools squashfs-tools xorriso casper lib32gcc-s1

### Since Ubuntu 22.04 the packages lupin-casper and lib32gcc are deprecated. We will use casper and lib32gcc-s1 instead.

# Running

Since do you have everything up-to-date on your system, download the code (and the settings folder, is important);
Put it inside a folder that does not have spaces! Like your /home/$USER/smolubuntu.
Now run build.sh and wait... take a coffee. Or a nap.

For me in a Ryzen 3 and M.2 NVME, the build finishes after 25 minutes.
It can be more or less, depends of your hardware and how much packages do you want inside it.
Remember, if you want to have a full desktop like Gnome Shell or KDE, the ISO will grow up to 4 Gb or more; and this will take
more to finish, around from 2-4 Hours for every build made!
Choose wisely to run less unnecessary builds.

When first boot this live-only ISO, you will be prompted to MENU.
There is a lot of tools and configurations! Bellow I describe more of them.

# Settings

Everything under "settings" folder is going to "/" inside the final .ISO!
Everything that is going to show up inside /home/$USER/ need to be placed under "settings/etc/skel".
And everything for Root user need to be inside /root folder.

With this structure you can change backgrounds or even themes! You can change every folder in the system.
Be creative here!

There are some folders with some codes. They are:

-└── settings (1)
-    ├── etc
-    │   ├── apache2 (2)
-    │   │   ├── apache2.conf
-    │   │   ├── conf-available
-    │   │   │   └── other-vhosts-access-log.conf
-    │   │   └── sites-available
-    │   │       ├── 000-default.conf
-    │   │       └── default-ssl.conf
-    │   ├── cups (3)
-    │   │   └── cupsd.conf
-    │   ├── motion (4)
-    │   │   └── motion.conf
-    │   ├── samba (5)
-    │   │   └── smb.conf
-    │   ├── skel (5.1)
-    │   │   ├── .bashrc (6)
-    │   │   ├── .custom (7)
-    │   │   ├── .live (8)
-    │   │   ├── VIRUS (9)
-    │   │   ├── VIRUS-ALTERADO (10)
-    │   │   └── VPN (11)
-    │   └── systemd
-    │       └── system
-    │           ├── getty@tty1.service.d (12)
-    │           │   └── override.conf
-    │           └── getty@tty5.service.d (13)
-    │               └── override.conf
-    ├── mnt (14)
-    │   ├── backup
-    │   ├── disk01
-    │   ├── disk02
-    │   ├── disk03
-    │   ├── server
-    └── root (15)

-(1) The folder Settings to start.

-(2) Apache2 will run a default test page when boot.

-(3) Cups will run a default config. page that allow access to http://localhost:631

-(4) Motion will start a Live Streaming Cam on http://localhost:8081 if running on notebook.

Use "X Motion" on Menu to turn Off.

-(5) SAMBA default configuration for sharing a folder after using config. Samba on Menu

-(6) Modified Bashrc to run MENU script at startup. Edit this to remove the MENU boot.

-(7) Just a lock file.

-(8) The main MENU script that substitute the GUI adapted por user Ubuntu

-(9) A demo file that will thrigger any antivirus tool.

-(10) A demo file that will thrigger any antivirus tool.

-(11) Put .ovpn files here if there is any, to run as ubuntu user.

-(12) Will AUTO LOGIN for the "ubuntu" default user.

-Create more folders for more TTY. Default is just TTY1.

-(13) Will AUTO LOGIN for the "root" default user.

-Create more folders for more TTY. Default is just TTY5.

-(14) Some default /mnt folders.

-(15) Same as under (5.1)

Use "menu" command to open MENU if it is closed.
Use "menug" command to update MENU.

# .live

There are 2 .live files, the first one is under /skel, so it is for all /home users.
The second one is under /root, for root.

This will let you to access MENU under NORMAL or ROOT users without problems and for debug purposes!
You are free to edit these files to something under your necessities.
Lots of texts are in Brazillian Portuguese, sorry.
