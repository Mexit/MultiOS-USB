### MultiOS-USB allows you to run the Windows 10 installer and Windows PE.

Currently, you have to extract the files from the ISO image. In the future, we plan to run Windows directly from the ISO image.

#### Installation instructions for Linux users

[Download](https://www.microsoft.com/en-us/software-download/windows10ISO) and mount the ISO image:
```bash
mkdir mnt_windows
sudo mount -o loop,ro Win10*.iso mnt_windows
```

Provide the paths to the mounted ISO image and the mounted MultiOS-USB. Copy the following commands and replace `MultiOS_USB` path.

```bash
mounted_ISO=mnt_windows
MultiOS_USB=/media/user/MultiOS-USB
```

If your MultiOS-USB file system is fat32 (default) go to [fat32](https://github.com/Mexit/test_MultiOS-USB/blob/master/config/win10_winPE/windows_support.md#fat32), if exFAT or NTFS go to [exFAT, NTFS](https://github.com/Mexit/test_MultiOS-USB/blob/master/config/win10_winPE/windows_support.md#exfat-ntfs) below.

##### fat32
If MultiOS-USB is installed on a standard file system (FAT32) you need to split the `install.wim` file in the `sources` directory if its size exceeds 4 GiB.
Under Linux you can use [wimlib](https://wimlib.net) to split `install.wim` file:
```bash
rsync -r --exclude 'sources/install.wim' ${mounted_ISO}/ ${MultiOS_USB}
wimsplit ${mounted_ISO}/sources/install.wim ${MultiOS_USB}/sources/install.swm 4000
mv ${MultiOS_USB}/efi/boot/bootx64.efi ${MultiOS_USB}/efi/microsoft/boot
mv ${MultiOS_USB}/bootmgr ${MultiOS_USB}/boot
```


##### exFAT, NTFS
```bash
rsync -r ${mounted_ISO}/ ${MultiOS_USB}
mv ${MultiOS_USB}/efi/boot/bootx64.efi ${MultiOS_USB}/efi/microsoft/boot
mv ${MultiOS_USB}/bootmgr ${MultiOS_USB}/boot
```

More informations:
- [Install Windows from a USB Flash Drive](https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/install-windows-from-a-usb-flash-drive)

