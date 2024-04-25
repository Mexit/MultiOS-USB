## List of tested ISO images (in the process of updating)
Note: MultiOS-USB automatically reads the configuration and allows you to run your distribution from all compatible ISO images (GRUB loopback support = yes). This configuration is located in the ISO image in the /boot/grub/loopback.cfg file.  

Below is just a list of tested and working systems. The actual number of supported systems is much larger. I can't test them all.

| Distro | ISO | Boot from exFAT | GRUB loopback support | Secure Boot support | SB from |
|---|---|:---:|:---:|:---:|---|
| [Arch Linux](https://archlinux.org) | [archlinux-2024.03.01-x86_64.iso](https://archlinux.mirrors.ovh.net/archlinux/iso/latest/archlinux-2024.03.01-x86_64.iso) | yes | yes | no | - |
| [ArcoLinux](https://www.arcolinux.info) | [arcolinuxl-v24.03.01-x86_64.iso](https://downloads.sourceforge.net/arcolinux/arcolinuxl-v24.03.01-x86_64.iso) | yes | yes | no | - |
| [Athena OS](https://athenaos.org) | [athena-rolling-x86_64.iso](https://sourceforge.net/projects/athena-iso/files/v23.11/athena-rolling-x86_64.iso) | yes | [no](../config/athenaos) | no | - |
| [CachyOS](https://cachyos.org) | [cachyos-kde-linux-240313.iso](https://cdn.cachyos.org/ISO/kde/240313/cachyos-kde-linux-240313.iso) | yes | yes | no | - |
| [Damn Small Linux](https://damnsmalllinux.org) | [dsl-2024.rc1.iso](https://damnsmalllinux.org/download/dsl-2024.rc1.iso) | yes | [no](../config/damnsmalllinux) | no | - |
| [Debian](https://www.debian.org) | [debian-live-12.5.0-amd64-standard.iso](https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/debian-live-12.5.0-amd64-standard.iso) | no | yes | yes | Debian |
|  | [mini.iso](https://cdimage.debian.org/debian/dists/stable/main/installer-amd64/current/images/netboot/mini.iso) | no | [no](../config/debian) | yes | Debian |
| [Devuan](https://www.devuan.org) | devuan_daedalus_5.0.0_amd64_desktop-live.iso | no | [no](../config/devuan) | yes | Debian |
|  | devuan_daedalus_5.0.0_amd64_minimal-live.iso | no | [no](../config/devuan) | yes | Debian |
| [Dr.Parted Live](https://dr-parted-live.sourceforge.io) | [Dr.Parted-Live24.03.1-amd64.iso](https://sourceforge.net/projects/dr-parted-live/files/Download/Dr.Parted-Live24.03.1-amd64.iso) | no | no | yes | Debian |
| [EndeavourOS](https://endeavouros.com) | [EndeavourOS_Gemini-2024.04.20.iso](https://mirror.alpix.eu/endeavouros/iso/EndeavourOS_Gemini-2024.04.20.iso) | yes | [no](../config/endeavourOS) | no | - |
| [EuroLinux](https://euro-linux.com) | [ELD-9.3-x86_64-20240223-eld-live.iso](https://dn.euro-linux.com/ELD-9.3-x86_64-20240223-eld-live.iso) | yes | [no](../config/euroLinux) | yes | RedHat |
|  | [EL-9.3-x86_64-20231113-minimal.iso](https://dn.euro-linux.com/EL-9.3-x86_64-20231113-minimal.iso) | yes | [no](../config/euroLinux) | no | - |
|  | [EL-9.3-x86_64-20231113-appstream.iso](https://dn.euro-linux.com/EL-9.3-x86_64-20231113-appstream.iso) | yes | [no](../config/euroLinux) | no | - |
|  | [EL-8.9-x86_64-20231116-minimal.iso](https://dn.euro-linux.com/EL-8.9-x86_64-20231116-minimal.iso) | yes | [no](../config/euroLinux) | no | - |
| [Fedora](https://fedoraproject.org) | [Fedora-Design_suite-Live-x86_64-39-1.5.iso](https://download.fedoraproject.org/pub/alt/releases/39/Labs/x86_64/iso/Fedora-Design_suite-Live-x86_64-39-1.5.iso) | yes | [no](../config/fedora) | yes | Fedora |
|  | [Fedora-Workstation-Live-x86_64-39-1.5.iso](https://download.fedoraproject.org/pub/fedora/linux/releases/39/Workstation/x86_64/iso/Fedora-Workstation-Live-x86_64-39-1.5.iso) | yes | [no](../config/fedora) | yes | Fedora |
|  | [Fedora-Xfce-Live-x86_64-39-1.5.iso](https://download.fedoraproject.org/pub/fedora/linux/releases/39/Spins/x86_64/iso/Fedora-Xfce-Live-x86_64-39-1.5.iso) | yes | [no](../config/fedora) | yes | Fedora |
|  | [Fedora-Server-netinst-x86_64-39-1.5.iso](https://download.fedoraproject.org/pub/fedora/linux/releases/39/Server/x86_64/iso/Fedora-Server-netinst-x86_64-39-1.5.iso) | yes | [no](../config/fedora) | yes | Fedora |
|  | [Fedora-Server-dvd-x86_64-39-1.5.iso](https://download.fedoraproject.org/pub/fedora/linux/releases/39/Server/x86_64/iso/Fedora-Server-dvd-x86_64-39-1.5.iso) | yes | [no](../config/fedora) | yes | Fedora |
|  | [Fedora-Everything-netinst-x86_64-39-1.5.iso](https://download.fedoraproject.org/pub/fedora/linux/releases/39/Everything/x86_64/iso/Fedora-Everything-netinst-x86_64-39-1.5.iso) | yes | [no](../config/fedora) | yes | Fedora |
|  | [Fedora-IoT-ostree-x86_64-39-20231103.1.iso](https://download.fedoraproject.org/pub/alt/iot/39/IoT/x86_64/iso/Fedora-IoT-ostree-x86_64-39-20231103.1.iso) | yes | [no](../config/fedora) | yes | Fedora |
|  | [Fedora-Silverblue-ostree-x86_64-39-1.5.iso](https://download.fedoraproject.org/pub/fedora/linux/releases/39/Silverblue/x86_64/iso/Fedora-Silverblue-ostree-x86_64-39-1.5.iso) | yes | [no](../config/fedora) | yes | Fedora |
|  | [Fedora-Kinoite-ostree-x86_64-39-1.5.iso](https://download.fedoraproject.org/pub/fedora/linux/releases/39/Kinoite/x86_64/iso/Fedora-Kinoite-ostree-x86_64-39-1.5.iso) | yes | [no](../config/fedora) | yes | Fedora |
|  | [Fedora-Sericea-ostree-x86_64-39-1.5-respin2.iso](https://download.fedoraproject.org/pub/alt/releases/39/respins/Sericea/x86_64/Fedora-Sericea-ostree-x86_64-39-1.5-respin2.iso) | yes | [no](../config/fedora) | yes | Fedora |
|  | [Fedora-Onyx-ostree-x86_64-39-1.5-respin.iso](https://download.fedoraproject.org/pub/alt/releases/39/respins/Onyx/x86_64/Fedora-Onyx-ostree-x86_64-39-1.5-respin.iso) | yes | [no](../config/fedora) | yes | Fedora |
|  | [Fedora-Workstation-Live-x86_64-40-1.14.iso](https://download.fedoraproject.org/pub/fedora/linux/releases/40/Workstation/x86_64/iso/Fedora-Workstation-Live-x86_64-40-1.14.iso) | yes | [no](../config/fedora) | yes | Fedora |
| [Finnix](https://www.finnix.org) | [finnix-125.iso](https://www.finnix.org/releases/125/finnix-125.iso) | no | yes | yes | Debian |
| [GParted Live](https://gparted.org/livecd.php) | [gparted-live-1.6.0-1-amd64.iso](https://downloads.sourceforge.net/gparted/gparted-live-1.6.0-1-amd64.iso) | no | [no](../config/gparted) | yes | Debian |
| [Grml](https://www.grml.org) | [grml64-full_2024.02.iso](https://download.grml.org/grml64-full_2024.02.iso) | no | yes | yes | Debian |
|  | [grml64-small_2024.02.iso](https://download.grml.org/grml64-small_2024.02.iso) | no | yes | yes | Debian |
| [Kaspersky Rescue Disk](https://support.kaspersky.com/krd18) | [krd.iso](https://rescuedisk.s.kaspersky-labs.com/updatable/2018/krd.iso) | no | [no](../config/kaspersky) | no | - |
| [KDE neon](https://neon.kde.org) | [neon-user-20240229-0716.iso](https://files.kde.org/neon/images/user/20240229-0716/neon-user-20240229-0716.iso) | no | [no](../config/KDE_neon) | yes | Canonical |
| [Kubuntu](https://kubuntu.org) | [kubuntu-24.04-desktop-amd64.iso](https://cdimage.ubuntu.com/kubuntu/releases/24.04/release/kubuntu-24.04-desktop-amd64.iso) | no | yes | yes | Canonical |
| [Linux Lite](https://www.linuxliteos.com) | [linux-lite-6.6-64bit.iso](https://mirror.alpix.eu/linuxliteos/isos/6.6/linux-lite-6.6-64bit.iso) | no | yes | yes | Canonical |
| [Linux Mint](https://linuxmint.com) | [linuxmint-21.3-cinnamon-64bit-edge.iso](https://mirror.rackspace.com/linuxmint/iso/stable/21.3/linuxmint-21.3-cinnamon-64bit-edge.iso) | no | yes | yes | Canonical |
| [Mabox Linux](https://maboxlinux.org) | [mabox-linux-24.03-Istredd-240313-linux66.iso](https://sourceforge.net/projects/mabox-linux/files/24.03/mabox-linux-24.03-Istredd-240313-linux66.iso) | yes | yes | no | - |
| [Manjaro](https://manjaro.org) | [manjaro-xfce-23.1.3-240113-linux66.iso](https://download.manjaro.org/xfce/23.1.3/manjaro-xfce-23.1.3-240113-linux66.iso) | yes | yes | no | - |
| [NixOS](https://nixos.org) | [nixos-gnome-23.11.5353.878ef7d9721b-x86_64-linux.iso](https://releases.nixos.org/nixos/23.11/nixos-23.11.5353.878ef7d9721b/nixos-gnome-23.11.5353.878ef7d9721b-x86_64-linux.iso) | no | yes | no | - |
| [openSUSE](https://www.opensuse.org) | [openSUSE-Leap-15.5-GNOME-Live-x86_64-Build13.15-Media.iso](https://download.opensuse.org/distribution/leap/15.5/appliances/iso/openSUSE-Leap-15.5-GNOME-Live-x86_64-Build13.15-Media.iso) | yes | yes | yes | SLES |
| [Oracle Linux](https://www.oracle.com/linux) | [OracleLinux-R9-U3-x86_64-boot.iso](https://yum.oracle.com/ISOS/OracleLinux/OL9/u3/x86_64/OracleLinux-R9-U3-x86_64-boot.iso) | yes | [no](../config/oracleLinux) | yes | Oracle |
| [peppermintOS](https://peppermintos.com) | [PeppermintOS-Debian-64.iso](https://sourceforge.net/projects/peppermintos/files/isos/XFCE/PeppermintOS-Debian-64.iso) | no | yes | yes | Debian |
| [Plop Linux](https://www.plop.at/en/ploplinux/index.html) | [ploplinux-24.2-x86_64.iso](https://download.plop.at/ploplinux/24.2/live/ploplinux-24.2-x86_64.iso) | yes | [no](../config/ploplinux) | no | - |
| [Qubes OS](https://www.qubes-os.org) | [Qubes-R4.2.1-rc1-x86_64.iso](https://ftp.qubes-os.org/iso/Qubes-R4.2.1-rc1-x86_64.iso) | yes | [no](../config/qubes-os) | no | - |
| [Rocky Linux](https://rockylinux.org) | [Rocky-9.3-x86_64-boot.iso](https://download.rockylinux.org/pub/rocky/9/isos/x86_64/Rocky-9.3-x86_64-boot.iso) | yes | [no](../config/rocky) | yes | Rocky |
|  | [Rocky-9.3-x86_64-minimal.iso](https://download.rockylinux.org/pub/rocky/9/isos/x86_64/Rocky-9.3-x86_64-minimal.iso) | yes | [no](../config/rocky) | yes | Rocky |
| [Slax](https://www.slax.org) | [slax-64bit-debian-12.2.0.iso](https://ftp.sh.cvut.cz/slax/Slax-12.x/slax-64bit-debian-12.2.0.iso) | no | [no](../config/slax) | no | - |
|  | [slax-64bit-slackware-15.0.4.iso](https://ftp.sh.cvut.cz/slax/Slax-15.x/slax-64bit-slackware-15.0.4.iso) | no | [no](../config/slax) | no | - |
| [Solus](https://getsol.us) | [Solus-4.5-Budgie.iso](https://downloads.getsol.us/isos/4.5/Solus-4.5-Budgie.iso) | yes | [no](../config/solus) | yes | Solus |
|  | [Solus-4.5-GNOME.iso](https://downloads.getsol.us/isos/4.5/Solus-4.5-GNOME.iso) | yes | [no](../config/solus) | yes | Solus |
|  | [Solus-4.5-Plasma.iso](https://downloads.getsol.us/isos/4.5/Solus-4.5-Plasma.iso) | yes | [no](../config/solus) | yes | Solus |
|  | [Solus-4.5-XFCE-Beta.iso](https://downloads.getsol.us/isos/4.5/Solus-4.5-XFCE-Beta.iso) | yes | [no](../config/solus) | yes | Solus |
| [SparkyLinux](https://sparkylinux.org) | [sparkylinux-7.3-x86_64-lxqt.iso](https://downloads.sourceforge.net/sparkylinux/sparkylinux-7.3-x86_64-lxqt.iso) | no | yes | yes | Debian |
| [SystemRescue](https://www.system-rescue.org) | [systemrescue-11.00-amd64.iso](https://downloads.sourceforge.net/systemrescuecd/systemrescue-11.00-amd64.iso) | yes | yes | no | - |
| [Tails](https://tails.net) | [tails-amd64-6.0.iso](https://download.tails.net/tails/stable/tails-amd64-6.0/tails-amd64-6.0.iso) | no | [no](../config/tails) | yes | Debian |
| [TUXEDO OS](https://os.tuxedocomputers.com) | [TUXEDO-OS-2-202402220947.iso](https://os.tuxedocomputers.com/TUXEDO-OS-2-202402220947.iso) | yes | yes | yes | TUXEDO |
| [Ubuntu](https://ubuntu.com) | [ubuntu-23.10.1-desktop-amd64.iso](https://releases.ubuntu.com/23.10.1/ubuntu-23.10.1-desktop-amd64.iso) | no | yes | yes | Canonical |
|  | [ubuntu-24.04-desktop-amd64.iso](https://releases.ubuntu.com/24.04/ubuntu-24.04-desktop-amd64.iso) | no | yes | yes | Canonical |
| [Void Linux](https://voidlinux.org) | [void-live-x86_64-20240314-xfce.iso](https://repo-default.voidlinux.org/live/current/void-live-x86_64-20240314-xfce.iso) | yes | [no](../config/void-linux) | no | - |
|  | [void-live-x86_64-20240314-base.iso](https://repo-default.voidlinux.org/live/current/void-live-x86_64-20240314-base.iso) | yes | [no](../config/void-linux) | no | - |
| [VOYAGER](https://voyagerlive.org) | [Voyager-12.5-debian-amd64.iso](https://downloads.sourceforge.net/voyagerlive/Voyager-12.5-debian-amd64.iso) | no | yes | yes | Debian |
| [Windows](https://www.microsoft.com/software-download) | Win10_22H2_English_x64v1.iso | yes | [no](../config/windows) | no | Microsoft |
|  | Win11_23H2_English_x64v2.iso | yes | [no](../config/windows) | no | Microsoft |
| [Xubuntu](https://xubuntu.org) | [xubuntu-24.04-desktop-amd64.iso](https://cdimage.ubuntu.com/xubuntu/releases/24.04/release/xubuntu-24.04-desktop-amd64.iso) | no | yes | yes | Canonical |
| [Zentyal](https://zentyal.com) | [zentyal-8.0-development-amd64.iso](http://download.zentyal.com/zentyal-8.0-development-amd64.iso) | no | yes | yes | Canonical |
| [Zorin OS](https://zorinos.com) | [Zorin-OS-17.1-Core-64-bit.iso](https://mirrors.edge.kernel.org/zorinos-isos/17/Zorin-OS-17.1-Core-64-bit.iso) | no | yes | yes | Canonical |

Where:  
**Boot from exFAT** - Tells whether the OS supports booting from exFAT  
**GRUB loopback support** - Tells whether the ISO supports [GRUB Loopback](https://www.gnu.org/software/grub/manual/grub/html_node/Loopback-booting.html)  
