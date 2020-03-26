#!/bin/bash

# Defaults
scriptname=$(basename "$0")
MultiOS_dir="boot_MultiOS"
fs_type="fat32"
data_size=""
data_label="MultiOS-USB"

# Show usage
showUsage() {
	cat <<- EOF

	Multiboot USB installer

	Usage: sudo $scriptname [options] device [data_size]

 	device				Device to install (e.g. /dev/sdb)
 	data_size			Data partition size (e.g. 5G)
 	-fs, --fs_type			Filesystem type for the data partition [ext3|ext4|fat32|ntfs] (default: "$fs_type")
 	-h,  --help			Display this message
 	-d,  --MultiOS_dir <NAME>	Specify a data subdirectory (default: "$MultiOS_dir")
	EOF
echo
echo Detected devices:
echo ---------------------------------------------
lsblk -p -S -o NAME,TRAN,SIZE,MODEL | grep usb
echo ---------------------------------------------
}

[ $# -eq 0 ] && showUsage && exit 0

# Check for root
if [ "$(id -u)" -ne 0 ]; then
	printf 'This script must be run as root. Using sudo...\n' "$scriptname" >&2
	exec sudo -k -- /bin/sh "$0" "$@"
fi

not_installed="0"
command -v sgdisk >/dev/null 2>&1 || { echo >&2 "sgdisk (gdisk) is required but not installed." ; not_installed="1" ; }
command -v wipefs >/dev/null 2>&1 || { echo >&2 "wipefs is required but not installed." ; not_installed="1" ; }
command -v mkfs.fat >/dev/null 2>&1 || { echo >&2 "mkfs.fat is required but not installed." ; not_installed="1" ; }

if command -v grub2-install >/dev/null 2>&1; then grub=grub2
elif command -v grub-install >/dev/null 2>&1; then grub=grub
else
	echo "grub or grub2 is required but not installed." ; not_installed="1"
fi

if [ "$not_installed" -ne 0 ]; then
	echo -e "\nNot all required programs are installed. Exiting...\n"
	exit 1
fi

while [ "$#" -gt 0 ]; do
	case "$1" in
		# Show help
		-h|--help)
			showUsage
			exit 0
			;;
		-d|--MultiOS_dir)
			shift && MultiOS_dir="$1"
			;;
		/dev/*)
			if [ -b "$1" ]; then
				usb_dev="$1"
			else
				printf '%s: %s is not a valid device.\n' "$scriptname" "$1" >&2
				exit 0
			fi
			;;
		-fs|--fs_type)
			shift && fs_type="$1"
			;;
		[0-9]*)
			data_size="$1"
			[ -z "$data_size" ] || data_size="+$data_size"
			;;
		*)
			printf '%s: %s is not a valid argument.\n' "$scriptname" "$1" >&2
			exit 0
			;;
	esac
	shift
done

# Check for required arguments
if [ ! "$usb_dev" ]; then
	printf '%s: No device was provided.\n' "$scriptname" >&2
	showUsage
	exit 0
fi

# Set data partition information
case "$fs_type" in
	ext2|ext3|ext4)
		part_code="8300"
		part_name="Linux filesystem"
		;;
	fat32|exFAT|ntfs)
		part_code="0700"
		part_name="Microsoft basic data"
		;;
	*)
		printf '%s: %s is an invalid filesystem type.\n' "$scriptname" "$fs_type" >&2
		exit 0
		;;
esac

printf '\n'
printf '+++++++++++++++++++++++++++++++++++++++++++++++++\n'
printf '++   Are you sure you want to use %s ?   ++\n' "$usb_dev"
printf '++   THIS WILL DELETE ALL DATA ON THE DEVICE   ++\n'
printf '+++++++++++++++++++++++++++++++++++++++++++++++++\n'
printf '\n'
printf 'Are you sure? Type "YeS" to continue: '
read -r yN
printf '\n'

case $yN in
	[Y][e][S])
		true
		;;
	*)
		printf 'Bad answer. Exiting...\n'
		exit 0
		;;
esac

umount -f "$usb_dev"* 2>/dev/null || true

sgdisk --zap-all "$usb_dev"
sgdisk --new 1::+1M --typecode 1:ef02 --change-name 1:"BIOS boot partition" "$usb_dev"
sgdisk --new 2::+50M --typecode 2:ef00 --change-name 2:"EFI System" "$usb_dev"
sgdisk --new 3::"${data_size}": --typecode 3:"$part_code" --change-name 3:"$part_name" "$usb_dev"
sgdisk --attributes 3:set:2 "$usb_dev"

wipefs -af "${usb_dev}1"
wipefs -af "${usb_dev}2"
wipefs -af "${usb_dev}3"

mkfs.fat -F 32 "${usb_dev}2"

case "$fs_type" in
	ext2|ext3|ext4)
		mkfs -t "$fs_type" -L "$data_label" "${usb_dev}3"
		;;
	fat32)
		mkfs.fat -F 32 -n "$data_label" "${usb_dev}3"
		;;
	exFAT)
		mkfs.exfat -n "$data_label" "${usb_dev}3"
		;;
	ntfs)
		mkfs -t "$fs_type" --fast -L "$data_label" "${usb_dev}3"
		;;
	*)
		printf '%s: %s is an invalid filesystem type.\n' "$scriptname" "$fs_type" >&2
		exit 0
		;;
esac

mkdir part_efi part_data
mount ${usb_dev}2 part_efi
mount ${usb_dev}3 part_data

# install grub (BIOS)
${grub}-install --target=i386-pc --boot-directory=part_efi --recheck --force $usb_dev

mkdir -p "part_data/ISOs" "part_data/os_files" "part_data/${MultiOS_dir}/tools" "part_efi/EFI/BOOT/cert"
echo "set MultiOS_dir="${MultiOS_dir}"" > part_efi/${grub}/grub.cfg
echo "export MultiOS_dir" >> part_efi/${grub}/grub.cfg
echo "search -f /\${MultiOS_dir}/config/grub.config --no-floppy --set=root" >> part_efi/${grub}/grub.cfg
echo "configfile /\${MultiOS_dir}/config/grub.config" >> part_efi/${grub}/grub.cfg
echo Copying files...
cp part_efi/${grub}/grub.cfg binaries/grubx64.efi part_efi/EFI/BOOT
cp -r config config_priv LICENSE README.md MultiOS-USB.version part_data/${MultiOS_dir}
cp -r themes part_efi/${grub}
cp -r binaries/syslinux-* binaries/MemTest86-* binaries/efitools-* binaries/refind-* part_data/${MultiOS_dir}/tools

# Enable support for Secure Boot
cp -r binaries/SecureBoot/* part_efi/EFI/BOOT
cp cert/* part_efi/EFI/BOOT/cert

umount -f part_efi
umount -f part_data
rmdir part_efi part_data
