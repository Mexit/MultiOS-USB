Directory contains known public keys that sign UEFI boot loaders and kernels, these should be verifiable by shim.
MokManager utility require *.cer files.


- altlinux-ca.cer: ALT Linux public key
  http://ftp.altlinux.org/pub/distributions/ALTLinux/p9/branch/files/SRPMS/shim-15-alt2.src.rpm

- canonical-uefi-ca.cer: Ubuntu & Ubuntu-based distros public key
  https://git.launchpad.net/~ubuntu-core-dev/shim/+git/shim/plain/debian/canonical-uefi-ca.der

- centossecurebootca2.cer: CentOS public key
  http://vault.centos.org/8.3.2011/BaseOS/Source/SPackages/shim-15-15.el8_2.src.rpm

- debian-uefi-ca.cer: Debian & Debian-based distros public key
  https://dsa.debian.org/secure-boot-ca

- fedora-uefi-ca-*.cer: Fedora Secure Boot CA

- MicCorKEKCA2011_2011-06-24.cer: Microsoft Corporation KEK CA 2011

- MicCorUEFCA2011_2011-06-27.cer: Microsoft Corporation UEFI CA 2011

- MicWinProPCA2011_2011-10-19.cer: Microsoft Windows Production PCA 2011

- MultiOS-USB.cer: MultiOS-USB public key

- openSUSE-UEFI-CA-Certificate.cer: openSUSE Leap 15.2 & Tumbleweed public key
  https://build.opensuse.org/package/view_file/openSUSE:Factory/shim/openSUSE-UEFI-CA-Certificate.crt

- refind.cer: rEFInd - An EFI boot manager utility
  https://sourceforge.net/p/refind/code/ci/master/tree/keys/refind.cer?format=raw

- SLES-UEFI-CA-Certificate.cer: openSUSE Leap 15.3 & SLES public key
  https://build.opensuse.org/package/view_file/openSUSE:Factory/shim/SLES-UEFI-CA-Certificate.crt


*.crt files are similar to *.cer files but in a different form.
sbverify can be used to verify the authenticity of a *.efi signed file.

	$ sbverify --cert MultiOS-USB.crt grubx64.efi
