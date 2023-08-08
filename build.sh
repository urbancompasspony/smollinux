#!/bin/bash

# Dependencies for Ubuntu 22.04 LTS! Any flavour.
# sudo apt install debootstrap mtools squashfs-tools xorriso casper lib32gcc-s1

# lupin-casper = deprecated since ubuntu 22.04
# If using ubuntu 21.10 or below, use lupin-casper instead of casper and use lib32gcc instead of lib32gcc-s1!

# the name of the distro
name="smolubuntu"

# Ubuntu Version
version="jammy"

# Remove old compilations
sudo rm -rf $HOME/$name;mkdir -pv $HOME/$name
sudo fstrim -va

# Base System
sudo debootstrap \
    --arch=amd64 \
    --variant=minbase \
    --components=main,multiverse,universe \
    $version \
    $HOME/$name/chroot

# Chroot
sudo mount --bind /dev $HOME/$name/chroot/dev
sudo mount --bind /run $HOME/$name/chroot/run
sudo chroot $HOME/$name/chroot mount none -t proc /proc
sudo chroot $HOME/$name/chroot mount none -t devpts /dev/pts
sudo chroot $HOME/$name/chroot sh -c "export HOME=/root"
echo "$name" | sudo tee $HOME/$name/chroot/etc/hostname

# Edit it to change for any repository. I recommend to use the same one of the distro that is compiling
cat <<EOF | sudo tee $HOME/$name/chroot/etc/apt/sources.list
deb http://us.archive.ubuntu.com/ubuntu/ $version main restricted universe multiverse
deb http://us.archive.ubuntu.com/ubuntu/ $version-security main restricted universe multiverse
deb http://us.archive.ubuntu.com/ubuntu/ $version-updates main restricted universe multiverse
EOF

# Official Repositories Support
sudo chroot $HOME/$name/chroot apt update
sudo chroot $HOME/$name/chroot apt install -y software-properties-common

# Add PPAs Here
#sudo chroot $HOME/$name/chroot add-apt-repository -y ppa:usuário/aplicacao

# Chroot 2
sudo chroot $HOME/$name/chroot apt update
sudo chroot $HOME/$name/chroot apt install -y systemd-sysv
sudo chroot $HOME/$name/chroot sh -c "dbus-uuidgen > /etc/machine-id"
sudo chroot $HOME/$name/chroot ln -fs /etc/machine-id /var/lib/dbus/machine-id
sudo chroot $HOME/$name/chroot dpkg-divert --local --rename --add /sbin/initctl
sudo chroot $HOME/$name/chroot ln -s /bin/true /sbin/initctl

# Ambiance Strings
sudo chroot $HOME/$name/chroot sh -c "echo 'grub-pc grub-pc/install_devices_empty   boolean true' | debconf-set-selections"
sudo chroot $HOME/$name/chroot sh -c "echo 'locales locales/locales_to_be_generated multiselect pt_BR.UTF-8 UTF-8' | debconf-set-selections"
sudo chroot $HOME/$name/chroot sh -c "echo 'locales locales/default_environment_locale select pt_BR.UTF-8' | debconf-set-selections"
sudo chroot $HOME/$name/chroot sh -c "echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections"
sudo chroot $HOME/$name/chroot sh -c "echo 'resolvconf resolvconf/linkify-resolvconf boolean false' | debconf-set-selections"

# Desktop Environment
# FOr example, Ubuntu MATE.
#sudo chroot $HOME/$name/chroot apt-mark hold gnome-shell
#sudo chroot $HOME/$name/chroot apt install -y ubuntu-mate-desktop

# Essential Packages - Do not remove them to not create problems.
sudo chroot $HOME/$name/chroot apt install -y --fix-missing \
   casper \
   dkms \
   discover \
   lib32gcc-s1 \
   laptop-detect \
   linux-generic \
   locales \
   os-prober \
   resolvconf \
   grub-efi-amd64-signed \
   ubuntu-standard \
   b43-fwcutter \
   bcmwl-kernel-source \
   net-tools \
   network-manager \
   wireless-tools

# User interface dependent applications that require a --no-install-recommends flag to not install a full desktop environment!
sudo chroot $HOME/$name/chroot apt install -y --fix-missing \
   caja \
   xorg \
   xinit \
   pluma \
   gnome-disk-utility \
   epiphany-browser \
   terminator --no-install-recommends

# User apps - Optional packages
sudo chroot $HOME/$name/chroot apt install -y --fix-missing \
   openbox \
   ubuntu-restricted-extras \
   inetutils-ping \
   net-tools \
   ethtool \
   eom \
   docker.io \
   libelf-dev \
   tcpdump \
   haveged \
   iotop \
   testdisk \
   netdiscover \
   samba \
   samba-common \
   cifs-utils \
   speedtest-cli \
   stress \
   fsarchiver \
   testdisk \
   libatasmart-bin \
   openssh-server \
   dialog \
   curl \
   lm-sensors \
   whois \
   arp-scan \
   traceroute \
   mutt \
   udpcast \
   htop \
   btop \
   sshpass \
   macchanger \
   alsa-base \
   pulseaudio \
   w3m \
   w3m-img \
   rdesktop \
   libgtk2.0-bin \
   xterm \
   inxi \
   rsync \
   x11-xserver-utils \
   obconf \
   xserver-xorg-video-all \
   xserver-xorg-input-all \
   apt-utils \
   btrfs-progs \
   brightnessctl \
   cups \
   printer-driver-all \
   motion \
   openvpn \
   apache2 \
   gparted \
   gnome-maps \
   gnome-weather \
   hardinfo \
   drawing \
   docker.io \
   qemu-system \
   qemu-utils \
   qemu-user \
   qemu-kvm \
   qemu-guest-agent \
   libvirt-clients \
   libvirt-daemon-system \
   bridge-utils \
   virt-manager \
   ovmf \
   dnsmasq

# WINE { If you do not want it, comment bellow }
sudo chroot $HOME/$name/chroot dpkg --add-architecture i386
sudo chroot $HOME/$name/chroot apt update
sudo chroot $HOME/$name/chroot apt install -y \
   wine

# bcmwl-kernel-source = ERROR
# Use it when booting on macbooks to have wifi.

# Ubiquity (Uncomment to allow installation mode! Default, this ISO will run only LIVE)
#sudo chroot $HOME/$name/chroot apt install -y \
#    gparted \
#    ubiquity \
#    ubiquity-casper \
#    ubiquity-frontend-gtk \
#    ubiquity-slideshow-ubuntu-mate

# Removing packages here
sudo chroot $HOME/ubuntu-custom/chroot apt autoremove --purge -y \
   gnome-terminal \
   unattended-upgrades \
   snapd

# A little last update of the system
sudo chroot $HOME/$name/chroot apt dist-upgrade -y

# Config. of Plymouth if one. Put quit splash bellow on GRUB config.
#sudo chroot $HOME/$name/chroot sh -c "update-alternatives --set default.plymouth /usr/share/plymouth/themes/bgrt/bgrt.plymouth"
#sudo chroot $HOME/$name/chroot update-initramfs -u -k all

# Reconfiguration of LAN
sudo chroot $HOME/$name/chroot apt install --reinstall resolvconf
cat <<EOF | sudo tee $HOME/$name/chroot/etc/NetworkManager/NetworkManager.conf
[main]
rc-manager=resolvconf
plugins=ifupdown,keyfile
dns=dnsmasq
[ifupdown]
managed=false
EOF
sudo chroot $HOME/$name/chroot dpkg-reconfigure network-manager

# Chroot 3
sudo chroot $HOME/$name/chroot truncate -s 0 /etc/machine-id
sudo chroot $HOME/$name/chroot rm /sbin/initctl
sudo chroot $HOME/$name/chroot dpkg-divert --rename --remove /sbin/initctl
sudo chroot $HOME/$name/chroot apt clean
sudo chroot $HOME/$name/chroot rm -rfv /tmp/* ~/.bash_history
sudo chroot $HOME/$name/chroot umount /proc
sudo chroot $HOME/$name/chroot umount /dev/pts
sudo chroot $HOME/$name/chroot sh -c "export HISTSIZE=0"
sudo umount $HOME/$name/chroot/dev
sudo umount $HOME/$name/chroot/run

# Configuration of GRUB
echo "RESUME=none" | sudo tee $HOME/$name/chroot/etc/initramfs-tools/conf.d/resume
echo "FRAMEBUFFER=y" | sudo tee $HOME/$name/chroot/etc/initramfs-tools/conf.d/splash

# Layout brazillian portuguese for keyboard
sudo sed -i 's/us/br/g' $HOME/$name/chroot/etc/default/keyboard

# Putting SETTINGS inside ISO.
sudo cp -rfv settings/* $HOME/$name/chroot/

# Initialization image files
cd $HOME/$name
mkdir -pv image/{boot/grub,casper,isolinux,preseed}

# Kernel Here
sudo cp chroot/boot/vmlinuz image/casper/vmlinuz
sudo cp chroot/boot/`ls -t1 chroot/boot/ | head -n 1` image/casper/initrd
touch image/$name

# GRUB MENU HERE
cat <<EOF > image/isolinux/grub.cfg
search --set=root --file /$name
insmod all_video
set default="0"
set timeout=15

if loadfont /boot/grub/unicode.pf2 ; then
    insmod gfxmenu
	insmod jpeg
	insmod png
	set gfxmode=auto
	insmod efi_gop
	insmod efi_uga
	insmod gfxterm
	terminal_output gfxterm
fi

menuentry "Normal" {
   linux /casper/vmlinuz file=/cdrom/preseed/$name.seed boot=casper locale=pt_BR ---
   initrd /casper/initrd
}
menuentry "Recovery Mode" {
   linux /casper/vmlinuz file=/cdrom/preseed/$name.seed boot=casper locale=pt_BR recovery ---
   initrd /casper/initrd
}
menuentry "Recovery Mode - Safe Graphics" {
   linux /casper/vmlinuz file=/cdrom/preseed/$name.seed boot=casper locale=pt_BR nomodeset recovery ---
   initrd /casper/initrd
}
menuentry " " {set gfxpayload=keep}
menuentry "Copy to RAM" {
   linux /casper/vmlinuz file=/cdrom/preseed/$name.seed boot=casper locale=pt_BR toram ---
   initrd /casper/initrd
}
menuentry " " {set gfxpayload=keep}
menuentry "NVIDIA Legacy" {
   linux /casper/vmlinuz file=/cdrom/preseed/$name.seed boot=casper locale=pt_BR modprobe.blacklist=nvidia,nvidia_uvm,nvidia_drm,nvidia_modeset ---
   initrd /casper/initrd
}
menuentry " " {set gfxpayload=keep}
menuentry "Reboot" {reboot}
menuentry "Shutdown" {halt}
EOF

# Loopback
# GRUB MENU HERE TOO
cat <<EOF > image/boot/grub/loopback.cfg
menuentry "Normal" {
   linux /casper/vmlinuz file=/cdrom/preseed/$name.seed boot=casper locale=pt_BR ---
   initrd /casper/initrd
}
menuentry "Recovery Mode" {
   linux /casper/vmlinuz file=/cdrom/preseed/$name.seed boot=casper locale=pt_BR recovery ---
   initrd /casper/initrd
}
menuentry "Recovery Mode - Safe Graphics" {
   linux /casper/vmlinuz file=/cdrom/preseed/$name.seed boot=casper locale=pt_BR nomodeset recovery ---
   initrd /casper/initrd
}
menuentry " " {set gfxpayload=keep}
menuentry "Copy to RAM" {
   linux /casper/vmlinuz file=/cdrom/preseed/$name.seed boot=casper locale=pt_BR toram ---
   initrd /casper/initrd
}
menuentry " " {set gfxpayload=keep}
menuentry "NVIDIA Legacy" {
   linux /casper/vmlinuz file=/cdrom/preseed/$name.seed boot=casper locale=pt_BR modprobe.blacklist=nvidia,nvidia_uvm,nvidia_drm,nvidia_modeset ---
   initrd /casper/initrd
}
menuentry " " {set gfxpayload=keep}
menuentry "Reboot" {reboot}
menuentry "Shutdown" {halt}
EOF

# If you want splash, put here after "loglevel=0" on sed line
# Preesed
cat <<EOF > image/preseed/$name.seed
# Success command
#d-i ubiquity/success_command string \
sed -i 's/quiet splash/loglevel=0 logo.nologo vt.global_cursor_default=0 mitigations=off/g' /target/etc/default/grub ; \
chroot /target update-grub
EOF

# Manifest file
sudo chroot chroot dpkg-query -W --showformat='${Package} ${Version}\n' | sudo tee image/casper/filesystem.manifest
sudo cp -v image/casper/filesystem.manifest image/casper/filesystem.manifest-desktop
sudo sed -i '/ubiquity/d' image/casper/filesystem.manifest-desktop
sudo sed -i '/casper/d' image/casper/filesystem.manifest-desktop
sudo sed -i '/discover/d' image/casper/filesystem.manifest-desktop
sudo sed -i '/laptop-detect/d' image/casper/filesystem.manifest-desktop
sudo sed -i '/os-prober/d' image/casper/filesystem.manifest-desktop

##################################################################
# BELOW DO NOT EDIT NOTHING, ONLY IF YOU KNOW WHAT ARE YOU DOING #
##################################################################

sudo mksquashfs chroot image/casper/filesystem.squashfs -comp xz
printf $(sudo du -sx --block-size=1 chroot | cut -f1) > image/casper/filesystem.size

cat <<EOF > image/README.diskdefines
#define DISKNAME  $name
#define TYPE  binary
#define TYPEbinary  1
#define ARCH  amd64
#define ARCHamd64  1
#define DISKNUM  1
#define DISKNUM1  1
#define TOTALNUM  0
#define TOTALNUM0  1
EOF

cd $HOME/$name/image
grub-mkstandalone \
   --format=x86_64-efi \
   --output=isolinux/bootx64.efi \
   --locales="" \
   --fonts="" \
   "boot/grub/grub.cfg=isolinux/grub.cfg"
(
   cd isolinux && \
   dd if=/dev/zero of=efiboot.img bs=1M count=10 && \
   sudo mkfs.vfat efiboot.img && \
   mmd -i efiboot.img efi efi/boot && \
   mcopy -i efiboot.img ./bootx64.efi ::efi/boot/
)
grub-mkstandalone \
   --format=i386-pc \
   --output=isolinux/core.img \
   --install-modules="linux16 linux normal iso9660 biosdisk memdisk search tar ls" \
   --modules="linux16 linux normal iso9660 biosdisk search" \
   --locales="" \
   --fonts="" \
   "boot/grub/grub.cfg=isolinux/grub.cfg"

cat /usr/lib/grub/i386-pc/cdboot.img isolinux/core.img > isolinux/bios.img

sudo /bin/bash -c '(find . -type f -print0 | xargs -0 md5sum | grep -v "\./md5sum.txt" > md5sum.txt)'

sudo rm -rfv ../chroot

mkdir -pv ../iso

sudo xorriso \
   -as mkisofs \
   -iso-level 3 \
   -full-iso9660-filenames \
   -volid "$name" \
   -eltorito-boot boot/grub/bios.img \
   -no-emul-boot \
   -boot-load-size 4 \
   -boot-info-table \
   --eltorito-catalog boot/grub/boot.cat \
   --grub2-boot-info \
   --grub2-mbr /usr/lib/grub/i386-pc/boot_hybrid.img \
   -eltorito-alt-boot \
   -e EFI/efiboot.img \
   -no-emul-boot \
   -append_partition 2 0xef isolinux/efiboot.img \
   -output "../iso/$name-22.04-amd64.iso" \
   -graft-points \
      "." \
      /boot/grub/bios.img=isolinux/bios.img \
      /EFI/efiboot.img=isolinux/efiboot.img

md5sum ../iso/$name-22.04-amd64.iso > ../iso/$name-22.04-amd64.md5
