#!/bin/bash
#
#  MultiOS-USB © 2020-2024 MexIT
#  https://gitlab.com/MultiOS-USB
#  https://github.com/Mexit/MultiOS-USB
#  Read LICENSE file for details
#

set -eo pipefail

# Defaults
scriptname=$(basename "$0")
fs_type="fat32"
data_size=""
efi_size="25M"
data_label="MultiOS-USB"
updateOnly="no"
log_file="install.log"

cd "$(dirname "$(readlink -f "$0")")"
echo -e "Arguments: $@\n" > $log_file

showUsage() {
	cat <<- EOF

	MultiOS-USB installer

	Usage: sudo $scriptname [options] device [data_size]

	    -f, --fs_type       Filesystem type for the data partition [ext2|ext3|ext4|fat32|exfat|ntfs] (default: "$fs_type")
	    -l, --devices       List available USB devices
	    -h, --help          Display this message
	    -u, --update        Update existing installation
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
		-u|--update)
			updateOnly=yes
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

if [[ $updateOnly == yes ]]; then
	manMounted=false

	umount_partitions () {
		if [ "$manMounted" = true ]; then
			sudo umount "$part_data"
			rm -rf ${tmpdir}
		fi
	}

	update_config () {
		echo -e "\n\e[1;41m++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\e[0m"
		echo -e "\e[1;41m++                  Are you sure you want to update config files?                         ++\e[0m"
		echo -e "\e[1;41m++             All modified files in "config" directory will be removed!                    ++\e[0m"
		echo -e "\e[1;41m++   If you have modified any files, please copy them NOW to the "config_priv" directory.   ++\e[0m"
		echo -e "\e[1;41m++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\e[0m"
		echo -e "\nYour config files version: $currVer"
		echo -e "New config files version: $newVer"
		echo -en "\nType 'YeS' to continue: "
		read -r yN

		case $yN in
			[Y][e][S])
				true
				;;
			*)
				echo -e '\nBad answer. Exiting...'
				exit 1
				;;
		esac

		echo "Updating..."
		rm -rf ${part_data}/MultiOS-USB/config
		cp -r config ${part_data}/MultiOS-USB
	}

	echo -e "\nMultiOS-USB updater"
	part_data=$(findmnt -no TARGET ${devp}2) || true
	if [ -z "$part_data" ]; then
		manMounted=true
		tmpdir=$(mktemp -d)
		part_data="${tmpdir}/part_data"
		mkdir -p "$part_data"
		echo -e "\nMounting partition ${devp}2..."
		sudo mount -o umask=0000 "${devp}2" "$part_data"
	fi

	if [ -f "${part_data}/MultiOS-USB/config/config.version" ]; then
		currVer=$(cat "${part_data}/MultiOS-USB/config/config.version")
	else
		echo -e "\n\e[1;41mError: MultiOS-USB is not installed on this device!\e[0m\n"
		umount_partitions
		exit 1
	fi

	if [ -f "config/config.version" ]; then
		newVer=$(cat "config/config.version")
	else
		echo -e "\nError: Unable to detect new version, file does not exist!"
		umount_partitions
		exit 1
	fi

	if [[ "${currVer}" == "${newVer}" ]]; then
		echo -e "\nConfig files version: $newVer"
	else
		OLDIFS=$IFS
		IFS=. v1=($newVer) v2=($currVer)
		IFS=$OLDIFS

		for pos in 0 1 2; do
			if [[ ${v1[pos]} -gt ${v2[pos]} ]]; then
				update_config
				break
			elif [[ ${v1[pos]} -lt ${v2[pos]} ]]; then
				echo -e "\nError: installed version ($currVer) is newer than downloaded ($newVer)"
				echo "Please download fresh version: https://github.com/Mexit/MultiOS-USB/archive/master.zip"
				umount_partitions
				exit 1
			fi
		done
	fi

	umount_partitions
	echo -e "\n\e[0;42mConfiguration is up to date\e[0m\n"
	exit 0
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
sgdisk -Z "$dev" >> $log_file
sgdisk -n 1::"+${efi_size}" -t 1:0700 -c 1:"EFI System" -A 1:set:0 -A 1:set:62 -A 1:set:63 "$dev" >> $log_file
sgdisk -n 2::"${data_size}" -t 2:"$part_code" -c 2:"$part_name" "$dev" >> $log_file

wipefs -afq "${devp}1"
wipefs -afq "${devp}2"

echo "Formating partitions..."
mkfs.fat -F 16 -n "MultiOS-EFI" "${devp}1" &>> $log_file

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

tmpdir=$(mktemp -d)
part_data="${tmpdir}/part_data"
part_efi="${tmpdir}/part_efi"
mkdir "$part_data" "$part_efi"

mount ${devp}1 $part_efi
mount ${devp}2 $part_data

echo "Copying files..."
mkdir -p $part_data/{MultiOS-USB/tools,ISOs,os_files} $part_efi/{EFI/BOOT,grub/fonts}
cp -r config config_priv themes LICENSE README.md MultiOS-USB.version $part_data/MultiOS-USB
cp -r binaries/{syslinux-*,mt86plus_*,efitools-*,wimboot-*,mountiso} $part_data/MultiOS-USB/tools

echo "Installing bootloader..."
tar -xf binaries/grub-*/i386-pc.tar.xz -C $part_efi/grub

cat > $part_efi/grub/grub.cfg << EOF
search -f /MultiOS-USB/config/grub.config --no-floppy --set=root
source /MultiOS-USB/config/grub.config
EOF

cp binaries/grub-*/grubenv $part_efi/grub
cp -r binaries/grub-*/unicode.pf2 $part_efi/grub/fonts
cp -r binaries/shim-signed_*/*.efi $part_efi/EFI/BOOT
cp binaries/grub-*/grubx64.efi $part_efi/EFI/BOOT
cp -r cert/ $part_efi/EFI/

dd conv=fsync status=none if="$part_efi/grub/i386-pc/boot.img" of="${dev}" bs=1 count=446
dd conv=fsync status=none if="$part_efi/grub/i386-pc/core.img" of="${dev}" bs=512 count=2014 seek=34

sync
umount $part_efi
umount $part_data
rm -rf ${tmpdir}
echo -e "\n\e[0;42mMultiOS-USB has been successfully installed.\e[0m\n"
