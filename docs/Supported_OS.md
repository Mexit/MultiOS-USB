## List of tested ISO images (in the process of updating)
| Distro | ISO | Boot from exFAT | GRUB loopback support | Secure Boot support | SB from |
|---|---|:---:|:---:|:---:|---|
| [Arch Linux](https://archlinux.org) | [archlinux-2024.03.01-x86_64.iso](https://archlinux.mirrors.ovh.net/archlinux/iso/latest/archlinux-2024.03.01-x86_64.iso) | yes | yes | no | - |
| [ArcoLinux](https://www.arcolinux.info) | [arcolinuxl-v24.03.01-x86_64.iso](https://downloads.sourceforge.net/arcolinux/arcolinuxl-v24.03.01-x86_64.iso) | yes | yes | no | - |
| [Athena OS](https://athenaos.org) | [athena-rolling-x86_64.iso](https://sourceforge.net/projects/athena-iso/files/v23.11/athena-rolling-x86_64.iso) | yes | [no](../config/athenaos) | no | - |
| [CachyOS](https://cachyos.org) | [cachyos-kde-linux-240313.iso](https://cdn.cachyos.org/ISO/kde/240313/cachyos-kde-linux-240313.iso) | yes | yes | no | - |
| [Damn Small Linux](https://damnsmalllinux.org) | [dsl-2024.rc1.iso](https://damnsmalllinux.org/download/dsl-2024.rc1.iso) | yes | [no](../config/damnsmalllinux) | no | - |
| [Debian](https://www.debian.org) | [debian-live-12.5.0-amd64-standard.iso](https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/debian-live-12.5.0-amd64-standard.iso) | no | yes | yes | Debian |
| [Dr.Parted Live](https://dr-parted-live.sourceforge.io) | [Dr.Parted-Live24.03.1-amd64.iso](https://sourceforge.net/projects/dr-parted-live/files/Download/Dr.Parted-Live24.03.1-amd64.iso) | no | no | yes | Debian |
| [Finnix](https://www.finnix.org) | [finnix-125.iso](https://www.finnix.org/releases/125/finnix-125.iso) | no | yes | yes | Debian |
| [GParted Live](https://gparted.org/livecd.php) | [gparted-live-1.6.0-1-amd64.iso](https://downloads.sourceforge.net/gparted/gparted-live-1.6.0-1-amd64.iso) | no | [no](../config/gparted) | yes | Debian |
| [Grml](https://www.grml.org) | [grml64-full_2024.02.iso](https://download.grml.org/grml64-full_2024.02.iso) | no | yes | yes | Debian |
|  | [grml64-small_2024.02.iso](https://download.grml.org/grml64-small_2024.02.iso) | no | yes | yes | Debian |
| [KDE neon](https://neon.kde.org) | [neon-user-20240229-0716.iso](https://files.kde.org/neon/images/user/20240229-0716/neon-user-20240229-0716.iso) | no | [no](../config/KDE_neon) | yes | Canonical |
| [Linux Lite](https://www.linuxliteos.com) | [linux-lite-6.6-64bit.iso](https://mirror.alpix.eu/linuxliteos/isos/6.6/linux-lite-6.6-64bit.iso) | no | yes | yes | Canonical |
| [Mabox Linux](https://maboxlinux.org) | [mabox-linux-24.03-Istredd-240313-linux66.iso](https://sourceforge.net/projects/mabox-linux/files/24.03/mabox-linux-24.03-Istredd-240313-linux66.iso) | yes | yes | no | - |
| [Manjaro](https://manjaro.org) | [manjaro-xfce-23.1.3-240113-linux66.iso](https://download.manjaro.org/xfce/23.1.3/manjaro-xfce-23.1.3-240113-linux66.iso) | yes | yes | no | - |
| [peppermintOS](https://peppermintos.com) | [PeppermintOS-Debian-64.iso](https://sourceforge.net/projects/peppermintos/files/isos/XFCE/PeppermintOS-Debian-64.iso) | no | yes | yes | Debian |
| [SparkyLinux](https://sparkylinux.org) | [sparkylinux-7.3-x86_64-lxqt.iso](https://downloads.sourceforge.net/sparkylinux/sparkylinux-7.3-x86_64-lxqt.iso) | no | yes | yes | Debian |
| [Tails](https://tails.net) | [tails-amd64-6.0.iso](https://download.tails.net/tails/stable/tails-amd64-6.0/tails-amd64-6.0.iso) | no | [no](../config/tails) | yes | Debian |
| [TUXEDO OS](https://os.tuxedocomputers.com) | [TUXEDO-OS-2-202402220947.iso](https://os.tuxedocomputers.com/TUXEDO-OS-2-202402220947.iso) | yes | yes | yes | TUXEDO |
| [Void Linux](https://voidlinux.org) | [void-live-x86_64-20240314-xfce.iso](https://repo-default.voidlinux.org/live/current/void-live-x86_64-20240314-xfce.iso) | yes | [no](../config/void-linux) | no | - |
|  | [void-live-x86_64-20240314-base.iso](https://repo-default.voidlinux.org/live/current/void-live-x86_64-20240314-base.iso) | yes | [no](../config/void-linux) | no | - |
| [VOYAGER](https://voyagerlive.org) | [Voyager-12.5-debian-amd64.iso](https://downloads.sourceforge.net/voyagerlive/Voyager-12.5-debian-amd64.iso) | no | yes | yes | Debian |
| [Windows](https://www.microsoft.com/software-download) | Win10_22H2_English_x64v1.iso | yes | [no](../config/windows) | no | Microsoft |
|  | Win11_23H2_English_x64v2.iso | yes | [no](../config/windows) | no | Microsoft |
| [Zentyal](https://zentyal.com) | [zentyal-8.0-development-amd64.iso](http://download.zentyal.com/zentyal-8.0-development-amd64.iso) | no | yes | yes | Canonical |

Where:  
**Boot from exFAT** - Tells whether the OS supports booting from exFAT  
**GRUB loopback support** - Tells whether the ISO supports [GRUB Loopback](https://www.gnu.org/software/grub/manual/grub/html_node/Loopback-booting.html)  
