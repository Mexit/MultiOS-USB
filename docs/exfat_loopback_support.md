## Linux exFAT and loopback support (the list is not complete)

| Operating system | ISO File | Boot from exFAT | Full loopback support |
| :-: | --- | :-: | :-: |
| | | | |
| Arch Linux | archlinux-2020.12.01-x86_64.iso | :heavy_check_mark: | :x: |
| | | | |
| ArchLabs Linux | archlabs-2021.05.02-x86_64.iso | :heavy_check_mark: | :x: |
| | | | |
| Archman Linux | Archman-Xfce-2020.12.09-x86_64.iso | :heavy_check_mark: | :x: |
| | | | |
| Bluestar Linux | bluestar-linux-5.12.1-2021.05.07-x86_64.iso | :heavy_check_mark: | :x: |
| | | | |
| EndeavourOS | endeavouros-2021.02.03-x86_64.iso | :heavy_check_mark: | :x: |
| | | | |
| Fedora | Fedora-Server-dvd-x86_64-34-1.2.iso | :heavy_check_mark: | :x: |
| | Fedora-Workstation-Live-x86_64-34-1.2.iso | :heavy_check_mark: | :x: |
| | | | |
| KaOS | KaOS-2021.01-x86_64.iso | :heavy_check_mark: | :x: |
| | | | |
| KDE neon | neon-user-20210204-0944.iso | :x: | :x: |
| | | | |
| Linux Lite | linux-lite-5.4-64bit.iso | :x: | :heavy_check_mark: |
| | | | |
| Linux Mint | linuxmint-20.1-cinnamon-64bit.iso | :x: | :heavy_check_mark: |
| | | | |
| Mabox Linux | mabox-linux-21.02-Foltest-210215-linux510.iso | :heavy_check_mark: | :heavy_check_mark: |
| | | | |
| Manjaro Linux | manjaro-gnome-20.2-201203-linux59.iso | :heavy_check_mark: | :heavy_check_mark: |
| | manjaro-kde-20.2-201203-linux59.iso | :heavy_check_mark: | :heavy_check_mark: |
| | manjaro-xfce-20.2-201203-linux59.iso | :heavy_check_mark: | :heavy_check_mark: |
| | | | |
| MX Linux | MX-19.3_x64.iso | :x: | :x: |
| | | | |
| Netrunner | netrunner-desktop-2101-64bit.iso | :x: | :heavy_check_mark: |
| | | | |
| NixOS | nixos-minimal-20.09.3492.36e15cd6e7d-x86_64-linux.iso | :x: | :heavy_check_mark: |
| | | | |
| PCLinuxOS | pclinuxos64-kde5-2021.02.iso | :x: | :x: |
| | pclinuxos64-MATE-2021.02.iso | :x: | :x: |
| | pclinuxos64-xfce-2021.02.iso | :x: | :x: |
| | | | |
| Rocky Linux | Rocky-8.3-x86_64-boot.iso | :x: | :x: |
| | Rocky-8.3-x86_64-minimal.iso | :x: | :x: |
| | | | |
| Salient OS | salientos-kde-v21.05-x86_64.iso | :heavy_check_mark: | :x: |
| | salientos-xfce-v2021.05-x86_64.iso | :heavy_check_mark: | :x: |
| | | | |
| Solus | Solus-4.2-Budgie.iso | :heavy_check_mark: | :x: |
| | | | |
| SparkyLinux | sparkylinux-5.14-x86_64-lxqt.iso | :x: | :x: |
| | | | |
| SystemRescue | systemrescue-8.01-amd64.iso | :heavy_check_mark: | :x: |
| | | | |
| Ubuntu | ubuntu-20.10-desktop-amd64.iso | :x: | :heavy_check_mark: |
| | | | |
| Zorin OS | Zorin-OS-15.3-Lite-64-bit.iso | :x: | :heavy_check_mark: |

Where:  
**Boot from exFAT** - Linux kernel can read ISO on exFAT filesystem  
**Full loopback support** - posibility to find and mount ISO file + grub configuration file (/boot/grub/loopback.cfg) with ISO kernel parameter. No additional configuration nedded. Just mount the image, load grub configuration from ISO and boot PC. The most requested feature.

