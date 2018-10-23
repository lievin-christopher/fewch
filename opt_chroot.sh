#!/bin/bash
cd /tmp && wget https://archlinux.vi-di.fr/iso/2018.10.01/archlinux-2018.10.01-x86_64.iso
7z e archlinux-2018.10.01-x86_64.iso arch/x86_64/airootfs.sfs
sudo unsquashfs -d /opt/fewch airootfs.sfs
sudo chroot /opt/fewch useradd -G wheel,users -m $USER -s /bin/$SHELL
sudo cp /etc/resolv.conf /opt/fewch/etc
sudo cp /etc/locale.gen /opt/fewch/etc
sudo cp /etc/locale.conf /opt/fewch/etc
sudo screen -d -m arch-chroot /opt/fewch
sudo chroot /opt/fewch locale-gen
sudo chroot /opt/fewch pacman-key --init
sudo chroot /opt/fewch pacman-key --populate archlinux
sudo chroot /opt/fewch pacman -Syu
sudo chroot /opt/fewch pacman -S git rxvt-unicode-terminfo base-devel
sudo chroot /opt/fewch sed --in-place=.old 's/# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
sudo chroot /opt/fewch sed --in-place=.old 's/#\[multilib\]/[multilib]\nInclude = \/etc\/pacman.d\/mirrorlist/g' /etc/pacman.conf sudo chroot /opt/fewch sed --in-place=.bak 's/#\[multilib\]/[multilib]\nInclude = \/etc\/pacman.d\/mirrorlist/g' /etc/pacman.conf
sudo chroot /opt/fewch sed --in-place=.old 's/#Color/Color/g' /etc/pacman.conf
sudo chroot /opt/fewch su $USER -c "cd $HOME && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si"
echo -e '#!/bin/bash\nxhost +local:\narch-chroot /opt/fewch' > /tmp/launch.sh && cp /tmp/launch.sh /opt/fewch/launch.sh && chmod +x /opt/fewch/launch.sh
echo -e '[Unit]\nDescription=fewch graphical chroot to install dummy programs\n[Service]\nExecStart=/usr/bin/screen -d -m /opt/fewch/launch.sh\n[Install]\nWantedBy=multi-user.target' > /tmp/fewch.sh && cp /tmp/fewch.sh /usr/lib/systemd/system/fewch.service
#chroot /opt/fewch su $USER -c "yay -S steam steam-native-runtime krita wps-office ttf-wps-fonts wps-office-extension-french-dictionary namebench"
