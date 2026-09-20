#!/usr/bin/env bash
#
#  MultiOS-USB © 2020-2026 MexIT
#  https://gitlab.com/MultiOS-USB
#  https://github.com/Mexit/MultiOS-USB
#  Read LICENSE file for details
#

set -eo pipefail

cd "$(dirname "$(readlink -f "$0")")" || exit 1
source common.sh

# Defaults
scriptname=$(basename "$0")
fs_type="exfat"
data_size=""
efi_size="25M"
data_label="MultiOS-USB"
updateOnly="no"
uefiOnly="no"
log_file=$(mktemp)

# shellcheck disable=SC2154
trap '{
	status=$?
	if [ $status -ne 0 ]; then
		print_banner "$C_ERROR" "" \
			"==================================================================" \
			"Installation error!" \
			"Below are the details that may be helpful when reporting the issue" \
			"=================================================================="
		echo "Exit code: $status"
		cat $log_file
		rm -f $log_file
		print_banner "$C_ERROR" "=================================================================="
	fi
}' EXIT

echo "Arguments: $*" > "${log_file}"

showUsage() {
	cat <<- EOF

	MultiOS-USB installer

	Usage: sudo $scriptname [options] device [data_size]

	    -f, --fs_type       Filesystem type for the data partition [ext2|ext3|ext4|fat32|exfat|ntfs] (default: "$fs_type")
	    -l, --devices       List available USB devices
	    -h, --help          Display this message
	    -u, --update        Update an existing installation
	    --uefi-only         Skip installing the legacy BIOS boot code (boot.img, core.img, *.mod); UEFI-only drive
	    --allrwdevices      List all writable devices (For advanced users only!!!)
	    device              Device to install (e.g. /dev/sdb)
	    data_size           Data partition size (e.g. 5G, 2048M)

	EOF
}

listDevices() {
	echo "Detected USB devices:"
	echo -------------------------------------------------------------
	lsblk -p -d -o NAME,MODEL,SIZE,TRAN | grep 'usb' | sed 's/usb$//' || true
	echo -------------------------------------------------------------
}

listAllRwDevices() {
	echo "Detected writable devices:"
	echo -------------------------------------------------------------
	lsblk -p -d -o NAME,MODEL,SIZE,TRAN,RO | grep '0$' | sed 's/0$//' || true
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
		--uefi-only)
			uefiOnly=yes
			;;
		/dev/*)
			if [[ -b "$1" ]]; then
				dev="$1"
			else
				print_error "Error! $1 is not a valid device."
				exit 1
			fi
			;;
		-f|--fs_type)
			shift && fs_type="$1"
			[[ -n $fs_type ]] || { print_error "Error! Please specify file system"; exit 1; }
			;;
		[0-9]*)
			if [[ $1 =~ ^[0-9]+[MG]$ ]]; then
				data_size="+$1"
			else
				print_error "Error! Incorrect partition size. Example: 500M, 5G"
				exit 1
			fi
			;;
		*)
			print_error "Error! $1 is not a valid argument."
			exit 1
			;;
	esac
	shift
done

# Check for required argument
if [[ ! -b "$dev" ]]; then
	print_error "Error! No device was provided."
	exit 1
fi

if [[ $dev == /dev/loop* || $dev == /dev/nbd* || $dev == /dev/mmcblk* || $dev == /dev/nvme* ]]; then
	devp="${dev}p"
elif [[ $dev == /dev/sd* || $dev == /dev/vd* ]]; then
	devp="${dev}"
else
	print_error "Unsupported device!"
	exit 1
fi

if [[ "$uefiOnly" == yes ]]; then
	includeBios=no
else
	includeBios=yes
fi

# Auto-detect existing installation, offer update/reinstall menu
if [[ "$updateOnly" == "no" ]]; then
	efi_label=$(blkid -s LABEL -o value "${devp}1" 2>/dev/null || true)
	data_label_found=$(blkid -s LABEL -o value "${devp}2" 2>/dev/null || true)

	if [[ "$efi_label" == "MultiOS-EFI" && "$data_label_found" == "MultiOS-USB" ]]; then
		echo -e "\nMultiOS-USB is already installed on $(hilite "$dev")."
		echo "-------------------------------------------------------------"
		echo " [1] Update (syncs changed files only; config_priv/tools_priv/ISOs are never touched)"
		echo " [2] Reinstall from scratch (formats the entire disk, deletes everything)"
		echo " [Q] Quit"
		echo "-------------------------------------------------------------"
		read -r -p "Choose an option: " modeChoice

		case "$modeChoice" in
			1)
				updateOnly=yes
				;;
			2)
				updateOnly=no
				;;
			""|[Qq])
				echo "Operation cancelled. Exiting..."
				exit 0
				;;
			*)
				print_error "Error: Invalid option."
				exit 1
				;;
		esac
	fi
fi

if [[ $updateOnly == yes ]]; then
	# Check for required software
	for cmd in dd tar xz rsync blockdev; do
		# shellcheck disable=SC2086
		if [ ! -x "$(command -v ${cmd} 2>/dev/null)" ]; then
			print_error "${cmd} is required but not installed. Exiting"
			exit 1
		fi
	done

	# Check for root
	if [ "$(id -u)" -ne 0 ]; then
		print_error "Please run the script with administrator privileges."
		exit 1
	fi

	manMountedEfi=false
	manMountedData=false
	tmpdir=""

	cleanup_update () {
		if [ "$manMountedEfi" = true ]; then
			umount "$part_efi" &> /dev/null || true
		fi
		if [ "$manMountedData" = true ]; then
			umount "$part_data" &> /dev/null || true
		fi
		[ -n "$tmpdir" ] && rm -rf "$tmpdir"
	}
	trap cleanup_update EXIT

	echo -e "\nMultiOS-USB updater"

	tmpdir=$(mktemp -d)

	# Mount EFI partition
	part_efi=$(findmnt -no TARGET "${devp}1") || true
	if [ -z "$part_efi" ]; then
		manMountedEfi=true
		part_efi="${tmpdir}/part_efi"
		mkdir -p "$part_efi"
		echo "Mounting partition ${devp}1..."
		mount -o umask=0000 "${devp}1" "$part_efi"
	fi

	# Detect whether BIOS boot support is currently installed
	if [ -d "$part_efi/grub/i386-pc" ]; then
		installedHasBios=yes
	else
		installedHasBios=no
	fi

	if [[ "$includeBios" != "$installedHasBios" ]]; then
		if [[ "$installedHasBios" == "yes" ]]; then
			print_warning "this drive has legacy BIOS boot support installed - keeping it (--uefi-only is ignored during updates; reinstall from scratch to remove it)."
		else
			print_warning "this drive is UEFI-only - not adding legacy BIOS boot support during update (reinstall from scratch to add it)."
		fi
		includeBios="$installedHasBios"
	fi

	# Mount Data partition
	part_data=$(findmnt -no TARGET "${devp}2") || true
	if [ -z "$part_data" ]; then
		manMountedData=true
		part_data="${tmpdir}/part_data"
		mkdir -p "$part_data"
		echo "Mounting partition ${devp}2..."
		devp2_fs=$(lsblk -no FSTYPE "${devp}2")
		case "$devp2_fs" in
			fat32|exfat|ntfs)
				mount -o umask=0000 "${devp}2" "$part_data"
				;;
			*)
				mount "${devp}2" "$part_data"
				;;
		esac
	fi

	# Verify MultiOS-USB drive
	if [ ! -f "${part_data}/MultiOS-USB/MultiOS-USB.version" ]; then
		print_error "Error: MultiOS-USB is not installed on this device!"
		exit 1
	fi
	currVer=$(cat "${part_data}/MultiOS-USB/MultiOS-USB.version")

	if [ -f "MultiOS-USB.version" ]; then
		newVer=$(cat "MultiOS-USB.version")
	else
		print_warning "Could not determine the source version (MultiOS-USB.version missing) - proceeding without a version check."
	fi

	requiredWord="YeS"

	if [ -n "$newVer" ]; then
		echo -e "\nInstalled version: $currVer \nSource (update) version: $newVer"

		if [[ "$newVer" == "$currVer" ]]; then
			print_success "The installed version is already up to date."
		else
			OLDIFS=$IFS
			IFS=. read -ra v1 <<< "$newVer"
			IFS=. read -ra v2 <<< "$currVer"
			IFS=$OLDIFS

			for pos in 0 1 2; do
				if [[ ${v1[pos]} -gt ${v2[pos]} ]]; then
					break
				elif [[ ${v1[pos]} -lt ${v2[pos]} ]]; then
					print_danger "" \
						"++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" \
						"++   WARNING: This source is OLDER than the installed version!      ++" \
						"++   Installed: $currVer   ->   Source: $newVer" \
						"++   This would DOWNGRADE the drive. Files added by the newer       ++" \
						"++   version (outside config_priv/tools_priv/ISOs) may be DELETED.  ++" \
						"++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
					requiredWord="DOWNGRADE"
					break
				fi
			done
		fi
	fi

	echo -en "Update this drive with the current source files? Type '${requiredWord}' to continue: "
	read -r yN

	if [[ "$yN" != "$requiredWord" ]]; then
		echo -e "\nAnswer was not '${requiredWord}'. Exiting..."
		exit 0
	fi

	echo "Updating EFI/boot files..."
	efi_stage="${tmpdir}/efi_stage"
	build_efi_stage "$efi_stage" "$includeBios"

	# Fully mirror the EFI partition contents
	rsync -rlptD --no-owner --no-group --checksum --delete "$efi_stage"/ "$part_efi"/

	if [[ "$includeBios" == "no" ]]; then
		echo "Skipping legacy BIOS boot sector code (UEFI-only)."
	else
		echo "Updating boot sector code (hybrid BIOS/UEFI boot)..."
		write_boot_sectors_safe "$dev" "$part_efi" "${devp}1" || true
	fi

	echo "Updating MultiOS-USB core files (config, themes, docs, tools)..."
	data_stage="${tmpdir}/data_stage"
	mkdir -p "$data_stage"
	build_data_stage "$data_stage" "no"

	# Fully mirror everything EXCEPT config_priv and tools_priv
	rsync -rlptD --no-owner --no-group --checksum --delete --exclude='config_priv' --exclude='tools_priv' "$data_stage"/ "${part_data}"/

	echo "Updating config_priv (existing user files are preserved, never deleted)..."
	if [ -d "config_priv" ]; then
		mkdir -p "${part_data}/MultiOS-USB/config_priv"
		rsync -rlptD --no-owner --no-group --checksum config_priv/ "${part_data}/MultiOS-USB/config_priv/"
	fi

	sync
	print_success "MultiOS-USB has been successfully updated."
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
		print_error "$scriptname: $fs_type is an invalid filesystem type."
		exit 1
		;;
esac

# Check for required software
[ "$fs_type" = "fat32" ] && fs_prog="mkfs.fat" || fs_prog="mkfs.$fs_type"
for cmd in dd tar xz sgdisk wipefs blockdev mkfs.fat "$fs_prog"; do
  # shellcheck disable=SC2086
  if [ ! -x "$(command -v ${cmd} 2>/dev/null)" ]; then
	  print_error "${cmd} is required but not installed. Exiting"
	  exit 1
  fi
done

# Check for root
if [ "$(id -u)" -ne 0 ]; then
	print_error "Please run the script with administrator privileges."
	exit 1
fi

print_danger \
	"++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" \
	"++   Are you absolutely sure you want to use the selected device?   ++" \
	"++             THIS WILL DELETE ALL DATA ON THE DEVICE              ++" \
	"++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo -en "\nAre you sure? Type 'YeS' to install MultiOS-USB on $(hilite "$dev"): "
read -r yN

case $yN in
	[Y][e][S])
		true
		;;
	*)
		echo 'Answer not "YeS". Exiting...'
		exit 0
		;;
esac

umount -f "${devp}"* &> /dev/null || true

echo "Creating partitions..."
sgdisk -Z "$dev" &>> "$log_file"
sgdisk -n 1:2048:"+${efi_size}" -t 1:0700 -c 1:"EFI System" -A 1:set:0 -A 1:set:63 "$dev" &>> "$log_file"
sgdisk -n 2::"${data_size}" -t 2:"$part_code" -c 2:"$part_name" "$dev" &>> "$log_file"

wipefs -af "${devp}1" &>> "$log_file"
wipefs -af "${devp}2" &>> "$log_file"

echo "Formating partitions..."
mkfs.fat -F 16 -n "MultiOS-EFI" "${devp}1" &>> "$log_file"

case "$fs_type" in
	ext2|ext3|ext4)
		mkfs."${fs_type}" -L "$data_label" "${devp}2" &>> "$log_file"
		;;
	fat32)
		mkfs.fat -F 32 -n "$data_label" "${devp}2" &>> "$log_file"
		;;
	exfat)
		mkfs.exfat -n "$data_label" "${devp}2" &>> "$log_file"
		;;
	ntfs)
		mkfs.ntfs --fast -L "$data_label" "${devp}2" &>> "$log_file"
		;;
	*)
		print_error "Error! $fs_type is an invalid filesystem type."
		exit 1
		;;
esac

tmpdir=$(mktemp -d)
part_data="${tmpdir}/part_data"
part_efi="${tmpdir}/part_efi"
mkdir "$part_data" "$part_efi"

mount "${devp}1" "$part_efi"
mount "${devp}2" "$part_data"

echo "Copying files..."
build_data_stage "$part_data" "yes"

echo "Installing bootloader..."
build_efi_stage "$part_efi" "$includeBios"

if [[ "$includeBios" == "no" ]]; then
	echo "Skipping legacy BIOS boot sector code (--uefi-only)."
else
	write_boot_sectors_safe "$dev" "$part_efi" "${devp}1"
fi

mv "$log_file" "$part_data/MultiOS-USB/install.log"
chmod -R o+rw "$part_data"

sync
umount "$part_efi"
umount "$part_data"
rm -rf "${tmpdir}"
print_success "MultiOS-USB has been successfully installed."
