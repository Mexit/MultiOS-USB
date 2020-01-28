
# MultiOS-USB

USB disk with multiple ISO files. Easy to use: install and copy ISO files.
Supported update configuration files.

## Requirements:

 - curl OR wget
 - tar
 - sgdisk
 - wipefs
 - mkfs
 - grub(2)

## Installation:

```sh
$ sudo installer.sh [options] device [data_size]

 	device				Device to install (e.g. /dev/sdb)
 	data_size			Data partition size (e.g. 5G)
 	-fs, --fs_type			Filesystem type for the data partition [ext3|ext4|FAT32|ntfs] (default: "FAT32")
 	-h,  --help			Display this message
 	-g,  --grub_inst_dir <NAME>	Specify a data subdirectory (default: "boot_MultiOS")
```
For example:
```sh
$ sudo installer.sh /dev/sdX
```
Replace X with your drive.

If you want to display list your all USB devices run installer without arguments:
```sh
$ ./installer.sh
```
Copy ISO files to "ISOs" directory and boot your computer from USB.

## Usage

First boot with enabled Secure Boot on each new computer requires to install a certificate.
![Press OK](https://gitlab.com/MexxIT/multios-usb/raw/master/docs/Security_Volation.png)
Press OK

![Select: Enroll key from disk](https://gitlab.com/MexxIT/multios-usb/raw/master/docs/Enroll_key.png)
Select: Enroll key from disk

Search for `MultiOS-USB.cer` in EFI directory and confirm key enrolling.

## Features:

- BIOS and UEFI support
- 64-bit (x86_64) UEFI (+ Secure Boot [from Fedora](https://apps.fedoraproject.org/packages/shim-x64)) support
- Load UEFI drivers
- Launch .efi executable files and other bootloaders
- Boot from .iso files

## Update:

Add support for new operating systems. There is no need to reinstall!
All you need to do is download new configuration files by typing:
```sh
$ ./config_updater.sh
```

