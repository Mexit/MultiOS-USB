#!/bin/bash
#
#  MultiOS-USB © 2020-2024 MexIT
#  https://gitlab.com/MultiOS-USB
#  https://github.com/Mexit/MultiOS-USB
#  Read LICENSE file for details
#

set -eo pipefail

log_file="install.log"
echo -e "Arguments: $@\n" > $log_file

# Defaults
scriptname=$(basename "$0")
fs_type="fat32"
data_size=""
data_label="MultiOS-USB"

showUsage() {
	cat <<- EOF

	MultiOS-USB installer

	Usage: sudo $scriptname [options] device [data_size]

	    -f, --fs_type       Filesystem type for the data partition [ext2|ext3|ext4|fat32|exfat|ntfs] (default: "$fs_type")
	    -l, --devices       List available USB devices
	    -h, --help          Display this message
	    --allrwdevices      List all writable devices (For advanced users only!!!)
	    device              Device to install (e.g. /dev/sdb)
	    data_size           Data partition size (e.g. 5G, 2048M)

	EOF
}

listDevices() {
	echo "Detected USB devices:"
	echo -------------------------------------------------------------
	lsblk -p -d -o NAME,MODEL,SIZE,TRAN | grep 'usb'  | sed 's/usb$//'
	echo -------------------------------------------------------------
}

listAllRwDevices() {
	echo "Detected writable devices:"
	echo -------------------------------------------------------------
	lsblk -p -d -o NAME,MODEL,SIZE,TRAN,RO | grep '0$' | sed 's/0$//'
	echo -------------------------------------------------------------
}

[ $# -eq 0 ] && showUsage && exit 0

while [ "$#" -gt 0 ]; do
	case "$1" in
		# Show help
		-h|--help)
			showUsage
			exit 0
			;;
		-l|--devices)
			listDevices
			exit 0
			;;
		--allrwdevices)
			listAllRwDevices
			exit 0
			;;
		/dev/*)
			if [[ -b "$1" ]]; then
				dev="$1"
			else
				echo "Error! $1 is not a valid device."
				exit 1
			fi
			;;
		-f|--fs_type)
			shift && fs_type="$1"
			[[ -n $fs_type ]] || { echo "Error! Please specify file system"; exit 1; }
			;;
		[0-9]*)
			if [[ $1 =~ ^[0-9]+[MG]$ ]]; then
				data_size="+$1"
			else
				echo "Error! Incorrect partition size. Example: 500M, 5G"
			fi
			;;
		*)
			echo "Error! $1 is not a valid argument."
			exit 1
			;;
	esac
	shift
done

# Check for required argument
if [[ ! -b "$dev" ]]; then
	echo "Error! No device was provided."
	exit 1
fi

if [[ $dev == /dev/loop* || $dev == /dev/nbd* || $dev == /dev/mmcblk* || $dev == /dev/nvme* ]]; then
	devp="${dev}p"
elif [[ $dev == /dev/sd* || $dev == /dev/vd* ]]; then
	devp="${dev}"
else
	echo "Unsupported device!"
	exit 1
fi

# Set data partition information
case "$fs_type" in
	ext2|ext3|ext4)
		part_code="8300"
		part_name="Linux filesystem"
		;;
	fat32|exfat|ntfs)
		part_code="0700"
		part_name="Microsoft basic data"
		;;
	*)
		echo "$scriptname: $fs_type is an invalid filesystem type."
		exit 1
		;;
esac

# Check for required software
missing_soft="0"
command -v dd &> /dev/null || { echo "dd is required but not installed."; missing_soft="1"; }
command -v tar &> /dev/null || { echo "tar is required but not installed."; missing_soft="1"; }
command -v xz &> /dev/null || { echo "xz is required but not installed."; missing_soft="1"; }
command -v sgdisk &> /dev/null || { echo "sgdisk (gdisk) is required but not installed."; missing_soft="1"; }
command -v wipefs &> /dev/null || { echo "wipefs is required but not installed."; missing_soft="1"; }
if [ "$fs_type" = "fat32" ]; then fs_prog="mkfs.fat"; else fs_prog="mkfs.$fs_type"; fi
command -v $fs_prog &> /dev/null || { echo "$fs_prog is required but not installed."; missing_soft="1"; }

if [ "$missing_soft" -ne 0 ]; then
	echo -e "\n\e[0;41mNot all required programs are installed. Exiting...\e[0m\n"
	exit 1
fi

# Check for root
if [ "$(id -u)" -ne 0 ]; then
	echo "Please run the script with administrator privileges."
	exit 1
fi

echo -e "\n\e[1;41m++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\e[0m"
echo -e "\e[1;41m++   Are you absolutely sure you want to use the selected device?   ++\e[0m"
echo -e "\e[1;41m++             THIS WILL DELETE ALL DATA ON THE DEVICE              ++\e[0m"
echo -e "\e[1;41m++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\e[0m"
echo -en "\nAre you sure? Type 'YeS' to install MultiOS-USB on \e[0;41m${dev}\e[0m: "
read -r yN
echo

case $yN in
	[Y][e][S])
		true
		;;
	*)
		echo 'Bad answer. Exiting...'
		exit 1
		;;
esac

umount -f "${devp}"* &> /dev/null || true

echo "Creating partitions..."
sgdisk --zap-all "$dev" >> $log_file
sgdisk --new 1::+50M --typecode 1:ef00 --change-name 1:"EFI System" "$dev" >> $log_file
sgdisk --new 2::"${data_size}" --typecode 2:"$part_code" --change-name 2:"$part_name" "$dev" >> $log_file

wipefs -afq "${devp}1"
wipefs -afq "${devp}2"

echo "Formating partitions..."
mkfs.fat -F 32 -n "MultiOS-EFI" "${devp}1" &>> $log_file

case "$fs_type" in
	ext2|ext3|ext4)
		mkfs.${fs_type} -L "$data_label" "${devp}2" &>> $log_file
		;;
	fat32)
		mkfs.fat -F 32 -n "$data_label" "${devp}2" &>> $log_file
		;;
	exfat)
		mkfs.exfat -n "$data_label" "${devp}2" &>> $log_file
		;;
	ntfs)
		mkfs.ntfs --fast -L "$data_label" "${devp}2" &>> $log_file
		;;
	*)
		echo "Error! $fs_type is an invalid filesystem type."
		exit 1
		;;
esac

rm -rf part_efi part_data
mkdir part_efi part_data
mount ${devp}1 part_efi
mount ${devp}2 part_data

echo "Copying files..."
mkdir -p part_data/{MultiOS-USB/tools,ISOs,os_files} part_efi/{EFI/BOOT,grub/fonts}
cp -r config config_priv themes LICENSE README.md MultiOS-USB.version part_data/MultiOS-USB
cp -r binaries/syslinux-* binaries/MemTest86-* binaries/efitools-* binaries/wimboot-* part_data/MultiOS-USB/tools

echo "Installing bootloader..."
tar -xf binaries/grub_*/i386-pc.tar.xz -C part_efi/grub

cat > part_efi/grub/grub.cfg << EOF
search -f /MultiOS-USB/config/grub.config --no-floppy --set=root
source /MultiOS-USB/config/grub.config
EOF

cp -r binaries/grub_*/unicode.pf2 part_efi/grub/fonts
cp -r binaries/shim-signed_*/*.efi part_efi/EFI/BOOT
cp binaries/grub_*/grubx64_signed.efi part_efi/EFI/BOOT/grubx64.efi
cp -r cert/ part_efi/EFI/

dd conv=fsync status=none if="part_efi/grub/i386-pc/boot.img" of="${dev}" bs=1 count=446
dd conv=fsync status=none if="part_efi/grub/i386-pc/core.img" of="${dev}" bs=512 count=2014 seek=34

sync
umount -f part_efi
umount -f part_data
rmdir part_efi part_data
echo -e "\n\e[0;42mMultiOS-USB has been successfully installed.\e[0m\n"
