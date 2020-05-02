#### MultiOS-USB allows you to run the Windows 10 installer and Windows PE.  

If MultiOS-USB is installed on a standard file system (FAT32),  
it will be necessary to split the `install.wim` file in the `sources` directory if its size exceeds 4 GiB.

Under Linux you can use [wimlib](https://wimlib.net) to split `install.wim` file.
```sh
$ wimsplit /path/to/install.wim /path/to/install.swm 4000
```

##### Installation instructions:
Copy at least the following files and folders to MultiOS-USB:
- `boot`
- `efi`
- `sources`
- `support`
- `bootmgr` to the USB `boot` directory

Finally, move `/efi/boot/bootx64.efi` to `/efi/microsoft/boot/`.

More informations:
- [Install Windows from a USB Flash Drive](https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/install-windows-from-a-usb-flash-drive)
