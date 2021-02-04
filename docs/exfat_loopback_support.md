## Linux exFAT and loopback support

| Operating system | ISO File | Boot from exFAT | Full loopback support |
| :-: | --- | :-: | :-: |
| | | | |
| Arch Linux | archlinux-2020.12.01-x86_64.iso | :heavy_check_mark: | :x: |
| | | | |
| Archman Linux | Archman-Xfce-2020.12.09-x86_64.iso | :heavy_check_mark: | :x: |
| | | | |
| EndeavourOS | endeavouros-2021.02.03-x86_64.iso | :heavy_check_mark: | :x: |
| | | | |
| KaOS | KaOS-2021.01-x86_64.iso | :heavy_check_mark: | :x: |
| | | | |
| KDE neon | neon-user-20210204-0944.iso | :x: | :x: |
| | | | |
| Manjaro Linux | manjaro-gnome-20.2-201203-linux59.iso | :heavy_check_mark: | :heavy_check_mark: |
| | manjaro-kde-20.2-201203-linux59.iso | :heavy_check_mark: | :heavy_check_mark: |
| | manjaro-xfce-20.2-201203-linux59.iso | :heavy_check_mark: | :heavy_check_mark: |
| | | | |
| Solus | Solus-4.2-Budgie.iso | :heavy_check_mark: | :x: |
| | | | |
| Ubuntu | ubuntu-20.10-desktop-amd64.iso | :x: | :heavy_check_mark: |

Where:  
**Boot from exFAT** - Linux kernel can read ISO on exFAT filesystem  
**Full loopback support** - posibility to find and mount ISO file + grub configuration with ISO kernel parameter (loopback.cfg or grub.cfg). No additional configuration nedded. Just mount the image, load grub configuration from ISO and boot PC. The most requested feature.

