## List of tested ISO images (in the process of updating)
| Distro | ISO | Boot from exFAT | GRUB loopback support | Secure Boot support | SB from |
|---|---|:---:|:---:|:---:|---|
| [Arch Linux](https://archlinux.org) | [archlinux-2024.03.01-x86_64.iso](https://archlinux.mirrors.ovh.net/archlinux/iso/latest/archlinux-2024.03.01-x86_64.iso) | yes | yes | no | - |
| [ArcoLinux](https://www.arcolinux.info) | [arcolinuxl-v24.03.01-x86_64.iso](https://downloads.sourceforge.net/arcolinux/arcolinuxl-v24.03.01-x86_64.iso) | yes | yes | no | - |
| [CachyOS](https://cachyos.org) | [cachyos-kde-linux-240313.iso](https://cdn.cachyos.org/ISO/kde/240313/cachyos-kde-linux-240313.iso) | yes | yes | no | - |
| [Debian](https://www.debian.org) | [debian-live-12.5.0-amd64-standard.iso](https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/debian-live-12.5.0-amd64-standard.iso) | no | yes | yes | Debian |
| [GParted Live](https://gparted.org/livecd.php) | [gparted-live-1.6.0-1-amd64.iso](https://downloads.sourceforge.net/gparted/gparted-live-1.6.0-1-amd64.iso) | no | [no](../config/gparted) | yes | Debian |
| [Grml](https://www.grml.org) | [grml64-full_2024.02.iso](https://download.grml.org/grml64-full_2024.02.iso) | no | yes | yes | Debian |
|  | [grml64-small_2024.02.iso](https://download.grml.org/grml64-small_2024.02.iso) | no | yes | yes | Debian |
| [KDE neon](https://neon.kde.org) | [neon-user-20240229-0716.iso](https://files.kde.org/neon/images/user/20240229-0716/neon-user-20240229-0716.iso) | no | [no](../config/KDE_neon) | yes | Canonical |
| [Manjaro](https://manjaro.org) | [manjaro-xfce-23.1.3-240113-linux66.iso](https://download.manjaro.org/xfce/23.1.3/manjaro-xfce-23.1.3-240113-linux66.iso) | yes | yes | no | - |
| [Tails](https://tails.net) | [tails-amd64-6.0.iso](https://download.tails.net/tails/stable/tails-amd64-6.0/tails-amd64-6.0.iso) | no | [no](../config/tails) | yes | Debian |
| [TUXEDO OS](https://os.tuxedocomputers.com) | [TUXEDO-OS-2-202402220947.iso](https://os.tuxedocomputers.com/TUXEDO-OS-2-202402220947.iso) | yes | yes | yes | TUXEDO |
| [Windows](https://www.microsoft.com/software-download) | Win10_22H2_English_x64v1.iso | yes | [no](../config/windows) | no | Microsoft |
|  | Win11_23H2_English_x64v2.iso | yes | [no](../config/windows) | no | Microsoft |
| [Zentyal](https://zentyal.com) | [zentyal-8.0-development-amd64.iso](http://download.zentyal.com/zentyal-8.0-development-amd64.iso) | no | yes | yes | Canonical |

Where:  
**Boot from exFAT** - Tells whether the OS supports booting from exFAT  
**GRUB loopback support** - Tells whether the ISO supports [GRUB Loopback](https://www.gnu.org/software/grub/manual/grub/html_node/Loopback-booting.html)  
