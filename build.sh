#!/bin/bash

# DEPS for Ubuntu 22.04 LTS
# sudo apt install debootstrap mtools squashfs-tools xorriso casper lib32gcc-s1

# Troque pelo nome que desejar! Eu chamei de smolubuntu
name="smolubuntu"

# Ubuntu Version
version="jammy"

# A ISO gerada será em arquitetura amd64, somente.
# Um MD5SUM também será gerado no final!

# Remoção de arquivos de compilaçoes anteriores caso existam
sudo rm -rfv $HOME/$name;mkdir -pv $HOME/$name
sudo fstrim -va

# Criação do sistema base
sudo debootstrap \
    --arch=amd64 \
    --variant=minbase \
    --components=main,multiverse,universe \
    $version \
    $HOME/$name/chroot
#    --include=fish \

# Primeira etapa da montagem do enjaulamento do sistema base
sudo mount --bind /dev $HOME/$name/chroot/dev
sudo mount --bind /run $HOME/$name/chroot/run
sudo chroot $HOME/$name/chroot mount none -t proc /proc
sudo chroot $HOME/$name/chroot mount none -t devpts /dev/pts
sudo chroot $HOME/$name/chroot sh -c "export HOME=/root"
echo "$name" | sudo tee $HOME/$name/chroot/etc/hostname

# Adição dos repositórios principais do Ubuntu
# Edite para trocar o repositório base. Recomendo que use a mesma da distro que vai compilar a ISO.
cat <<EOF | sudo tee $HOME/$name/chroot/etc/apt/sources.list
deb http://us.archive.ubuntu.com/ubuntu/ $version main restricted universe multiverse
deb http://us.archive.ubuntu.com/ubuntu/ $version-security main restricted universe multiverse
deb http://us.archive.ubuntu.com/ubuntu/ $version-updates main restricted universe multiverse
EOF

# Repositórios adicionais
sudo chroot $HOME/$name/chroot apt update
sudo chroot $HOME/$name/chroot apt install -y software-properties-common
# PPA 1
#sudo chroot $HOME/$name/chroot add-apt-repository -y ppa:usuário/programa
# PPA 2
#sudo chroot $HOME/$name/chroot add-apt-repository -y ppa:usuário/programa

# Segunda etapa da montagem do enjaulamento
sudo chroot $HOME/$name/chroot apt update
sudo chroot $HOME/$name/chroot apt install -y systemd-sysv
sudo chroot $HOME/$name/chroot sh -c "dbus-uuidgen > /etc/machine-id"
sudo chroot $HOME/$name/chroot ln -fs /etc/machine-id /var/lib/dbus/machine-id
sudo chroot $HOME/$name/chroot dpkg-divert --local --rename --add /sbin/initctl
sudo chroot $HOME/$name/chroot ln -s /bin/true /sbin/initctl

# Variáveis de ambiente para execução automatizada do script
sudo chroot $HOME/$name/chroot sh -c "echo 'grub-pc grub-pc/install_devices_empty   boolean true' | debconf-set-selections"
sudo chroot $HOME/$name/chroot sh -c "echo 'locales locales/locales_to_be_generated multiselect pt_BR.UTF-8 UTF-8' | debconf-set-selections"
sudo chroot $HOME/$name/chroot sh -c "echo 'locales locales/default_environment_locale select pt_BR.UTF-8' | debconf-set-selections"
sudo chroot $HOME/$name/chroot sh -c "echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections"
sudo chroot $HOME/$name/chroot sh -c "echo 'resolvconf resolvconf/linkify-resolvconf boolean false' | debconf-set-selections"

# Programas comuns
sudo chroot $HOME/$name/chroot apt install -y --fix-missing \
   casper \
   discover \
   laptop-detect \
   linux-generic \
   locales \
   net-tools \
   network-manager \
   os-prober \
   resolvconf \
   ubuntu-standard \
   ubuntu-restricted-extras \
   wireless-tools \
   lib32gcc-s1 \
   inetutils-ping \
   net-tools \
   ethtool \
   eom \
   grub-efi-amd64-signed \
   libelf-dev \
   haveged \
   iotop \
   testdisk \
   netdiscover \
   samba \
   samba-common \
   cifs-utils \
   speedtest-cli \
   stress \
   dkms \
   b43-fwcutter \
   bcmwl-kernel-source \
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
   openbox \
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
   apache2

#   xserver-xorg-input-libinput \
#   xserver-xorg-input-evdev \
#   xserver-xorg-input-mouse \
#   xserver-xorg-input-synaptics
   
# lupin-casper = deprecated since ubuntu 22.04
# If using ubuntu 21.10 or below, use lupin-casper instead of casper and use lib32gcc instead of lib32gcc-s1!

# Ambiente de desktop
# Adicione aqui o ambiente desktop desejado! No exemplo, Ubuntu MATE.
#sudo chroot $HOME/$name/chroot apt-mark hold gnome-shell
#sudo chroot $HOME/$name/chroot apt install -y ubuntu-mate-desktop

# Programas --no-install-recommends
sudo chroot $HOME/$name/chroot apt install -y --fix-missing \
   caja \
   xorg \
   xinit \
   pluma \
   gnome-disk-utility \
   terminator --no-install-recommends

# WINE
sudo chroot $HOME/$name/chroot dpkg --add-architecture i386
sudo chroot $HOME/$name/chroot apt update
sudo chroot $HOME/$name/chroot apt install -y \
   wine

#   gvfs-backends

# Sem cuidado o inxi puxa pacotes do xorg e xinit desnecessariamente.
#sudo chroot $HOME/$name/chroot apt install -y --no-install-recommends

# bcmwl-kernel-source = ERROR
# Use it when booting macbooks.

# Ubiquity(instalador do sistema, caso queira que essa ISO seja instalável!)
#sudo chroot $HOME/$name/chroot apt install -y \
#    gparted \
#    ubiquity \
#    ubiquity-casper \
#    ubiquity-frontend-gtk \
#    ubiquity-slideshow-ubuntu-mate

# Remoção de pacotes desnecessários
sudo chroot $HOME/ubuntu-custom/chroot apt autoremove --purge -y \
   gnome-terminal \
   unattended-upgrades \
   snapd
#    programa2 \
#    programa3

# Atualização do sistema
sudo chroot $HOME/$name/chroot apt dist-upgrade -y

# Configuração do Plymouth - Caso queira um. Não esqueça de editar lá embaixo para adicionar quiet splash ao sistema.
#sudo chroot $HOME/$name/chroot sh -c "update-alternatives --set default.plymouth /usr/share/plymouth/themes/bgrt/bgrt.plymouth"
#sudo chroot $HOME/$name/chroot update-initramfs -u -k all

# Reconfiguração da rede
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

# Desmontagem do enjaulamento
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

# Configuração do GRUB
echo "RESUME=none" | sudo tee $HOME/$name/chroot/etc/initramfs-tools/conf.d/resume
echo "FRAMEBUFFER=y" | sudo tee $HOME/$name/chroot/etc/initramfs-tools/conf.d/splash

# Layout português brasileiro para o teclado!
sudo sed -i 's/us/br/g' $HOME/$name/chroot/etc/default/keyboard

# Arquivos de configuração do sistema
sudo cp -rfv settings/* $HOME/$name/chroot/

# Criação dos arquivos de inicialização da imagem de instalação
cd $HOME/$name
mkdir -pv image/{boot/grub,casper,isolinux,preseed}

# Kernel
sudo cp chroot/boot/vmlinuz image/casper/vmlinuz
sudo cp chroot/boot/`ls -t1 chroot/boot/ |  head -n 1` image/casper/initrd
touch image/$name

# GRUB - É aqui que você tambem pode adicionar novas entradas, como nomodeset=0 para NVIDIA e afins.
# Por padrão é gerado apenas 2 entradas: Normal e Recovery mode.
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

# É aqui o quiet splash caso deseje ter um!
# Coloque antes de "loglevel=0" na linha sed, para mante-lo. Default: removido.
# Preesed
cat <<EOF > image/preseed/$name.seed
# Success command
#d-i ubiquity/success_command string \
sed -i 's/quiet splash/loglevel=0 logo.nologo vt.global_cursor_default=0 mitigations=off/g' /target/etc/default/grub ; \
chroot /target update-grub
EOF

# Arquivos de manifesto
sudo chroot chroot dpkg-query -W --showformat='${Package} ${Version}\n' | sudo tee image/casper/filesystem.manifest
sudo cp -v image/casper/filesystem.manifest image/casper/filesystem.manifest-desktop
sudo sed -i '/ubiquity/d' image/casper/filesystem.manifest-desktop
sudo sed -i '/casper/d' image/casper/filesystem.manifest-desktop
sudo sed -i '/discover/d' image/casper/filesystem.manifest-desktop
sudo sed -i '/laptop-detect/d' image/casper/filesystem.manifest-desktop
sudo sed -i '/os-prober/d' image/casper/filesystem.manifest-desktop
#echo "\
#programa1 \
#programa2 \
#programa3" | sudo tee image/casper/filesystem.manifest-remove

####################################################################################
# DAQUI PRA BAIXO NÃO MEXA EM NADA A MENOS QUE SAIBA EXATAMENTE O QUE ESTÁ FAZENDO!#
####################################################################################

# SquashFS
sudo mksquashfs chroot image/casper/filesystem.squashfs -comp xz
printf $(sudo du -sx --block-size=1 chroot | cut -f1) > image/casper/filesystem.size

# Definições de disco
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

# Geração do GRUB para imagem de instalação
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

# Geração do MD5 interno da imagem de instalação
sudo /bin/bash -c '(find . -type f -print0 | xargs -0 md5sum | grep -v "\./md5sum.txt" > md5sum.txt)'

# Limpeza da build
sudo rm -rfv ../chroot

# Compilação da imagem de instalação
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

# Geração do MD5 externo da imagem de instalação.
md5sum ../iso/$name-22.04-amd64.iso > ../iso/$name-22.04-amd64.md5
