#!/usr/bin/env bash
#
#  MultiOS-USB - functions
#

readonly C_ERROR='\e[1;31m'		# bold red text
readonly C_WARN='\e[1;33m'		# bold yellow text
readonly C_DANGER='\e[1;41m'	# bold white-on-red
readonly C_HILITE='\e[0;41m'	# red background
readonly C_SUCCESS='\e[0;42m'	# green background
readonly C_RESET='\e[0m'		# reset

print_error() {
	echo -e "${C_ERROR}$*${C_RESET}"
}

print_warning() {
	echo -e "${C_WARN}Warning: $*${C_RESET}"
}

print_success() {
	echo -e "\n${C_SUCCESS}$*${C_RESET}\n"
}

print_banner() {
	local color="$1"
	shift
	local line
	for line in "$@"; do
		echo -e "${color}${line}${C_RESET}"
	done
}

print_danger() {
	print_banner "$C_DANGER" "$@"
}

hilite() {
	echo -en "${C_HILITE}$*${C_RESET}"
}

# Returns the starting LBA (in 512-byte units)
get_partition_start_sector() {
	local partition_device="$1"
	local sysfs_name
	sysfs_name=$(basename "$partition_device")
	local start_file="/sys/class/block/${sysfs_name}/start"

	if [ -r "$start_file" ]; then
		cat "$start_file"
	fi
}

# Writes the hybrid boot sector code, but only after verifying that the GRUB embedding area
# (sectors 34 up to, but not including, 2048) doesn't overlap the start of the first partition
write_boot_sectors_safe() {
	local device="$1"
	local grub_img_dir="$2"
	local first_partition_device="$3"

	# The embedding offsets below (34, 2014, 446, 2048) are all fixed constants that
	# only hold true on disks with 512-byte logical sectors
	local logical_sector_size
	logical_sector_size=$(blockdev --getss "$device" 2>/dev/null)

	if [ -z "$logical_sector_size" ]; then
		print_warning "could not determine the logical sector size of $device - skipping boot sector update for safety."
		return 1
	fi

	if [ "$logical_sector_size" -ne 512 ]; then
		print_danger "" \
			"++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" \
			"++   WARNING: $device reports a $logical_sector_size-byte logical sector." \
			"++   The legacy BIOS boot embedding only supports 512-byte sectors." \
			"++   Skipping boot sector update - UEFI boot is unaffected." \
			"++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" \
			""
		return 1
	fi

	local embed_start=34
	local embed_sectors=2014
	local embed_end=$((embed_start + embed_sectors))

	local part_start
	part_start=$(get_partition_start_sector "$first_partition_device")

	if [ -z "$part_start" ]; then
		print_warning "Could not determine the start sector of $first_partition_device - skipping boot sector update for safety"
		return 1
	fi

	if [ "$part_start" -lt "$embed_end" ]; then
		print_danger "" \
			"++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" \
			"++   WARNING: $first_partition_device starts at sector $part_start," \
			"++   which overlaps the GRUB embedding area (sectors $embed_start-$((embed_end - 1)))." \
			"++   Skipping boot sector update to avoid corrupting the partition." \
			"++   Reinstall from scratch to fix this drive's layout." \
			"++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" \
			""
		return 1
	fi

	write_boot_sectors "$device" "$grub_img_dir"
}

# Builds the EFI/boot partition content (GRUB, shim, certs, grub.cfg) into $target.
# Set $include_bios=yes to also extract the i386-pc GRUB modules. Pass "no" for a UEFI-only
build_efi_stage() {
	local target="$1"
	local include_bios="$2"

	mkdir -p "$target"/{EFI/BOOT,grub/fonts}

	if [[ "$include_bios" == "yes" ]]; then
		tar -xf binaries/grub-*/i386-pc.tar.xz -C "$target/grub"
	fi

	cat > "$target/grub/grub.cfg" <<- 'GRUBCFG_EOF'
	search -f /MultiOS-USB/config/grub.config --no-floppy --set=root
	source /MultiOS-USB/config/grub.config
	GRUBCFG_EOF

	cp --preserve=mode,timestamps binaries/grub-*/grubenv			"$target/grub"
	cp --preserve=mode,timestamps binaries/grub-*/grubx64.efi		"$target/EFI/BOOT"
	cp -r --preserve=mode,timestamps binaries/grub-*/unicode.pf2	"$target/grub/fonts"
	cp -r --preserve=mode,timestamps binaries/shim-signed_*/*.efi	"$target/EFI/BOOT"
	cp -r --preserve=mode,timestamps cert/ 							"$target/EFI/"

	# grub.cfg is generated in-place above (not copied from a source file), so it has no
	# "real" source timestamp of its own - it would otherwise always look "changed" to
	# rsync. Pin it to grubenv's (preserved, stable) timestamp instead
	touch -r "$target/grub/grubenv" "$target/grub/grub.cfg"
}

# Writes the boot sector code onto device
write_boot_sectors() {
	local device="$1"
	local grub_img_dir="$2"

	dd conv=fsync status=none if="$grub_img_dir/grub/i386-pc/boot.img" of="$device" bs=1 count=446
	dd conv=fsync status=none if="$grub_img_dir/grub/i386-pc/core.img" of="$device" bs=512 count=2014 seek=34
}

# Builds the MultiOS-USB data-partition content
build_data_stage() {
	local target="$1"
	local include_priv="$2"

	mkdir -p "$target/ISOs" "$target/MultiOS-USB/"{tools,tools_priv}
	cp -r --preserve=mode,timestamps config themes LICENSE README.md MultiOS-USB.version "$target/MultiOS-USB"
	cp -r --preserve=mode,timestamps binaries/{syslinux-*,mt86plus_*,efitools-*,wimboot-*,mountiso} "$target/MultiOS-USB/tools"

	if [[ "$include_priv" == "yes" && -d "config_priv" ]]; then
		cp -r --preserve=mode,timestamps config_priv "$target/MultiOS-USB"
	fi
}
