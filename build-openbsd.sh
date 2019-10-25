#!/bin/sh

# This script assembles the mark1 bootloader, kernel and programs
# with NASM, and then creates floppy and CD images (on OpenBSD)

# Only the root user can mount the floppy disk image as a virtual
# drive (loopback mounting), in order to copy across the files

if test "`whoami`" != "root" ; then
	echo "You must be logged in as root to build (for loopback mounting)"
	echo "Enter 'su' to switch to root"
	exit
fi


if [ ! -e disk_images/mark1.flp ]
then
	echo ">>> Creating new mark1 iso..."
	dd if=/dev/zero of=disk_images/mark1.flp bs=512 count=2880 || exit
	vnconfig vnd3 disk_images/mark1.flp && newfs_msdos -f 1440 vnd3c && vnconfig -u vnd3 || exit
fi


echo "Assembling bootloader"

nasm -O0 -w+orphan-labels -f bin -o source/bootload/bootload.bin source/bootload/bootload.asm || exit


echo "Assembling kernel"

cd source
nasm -O0 -w+orphan-labels -f bin -o kernel.bin kernel.asm || exit
cd ..


echo "Assembling programs"

cd programs

for i in *.asm
do
	nasm -O0 -w+orphan-labels -f bin $i -o `basename $i .asm`.bin || exit
done

cd ..


echo "Adding bootloader to iso"

dd conv=notrunc if=source/bootload/bootload.bin of=disk_images/mark1.flp || exit


echo "Copying kernel and programs..."

rm -rf tmp-loop
vnconfig vnd3 disk_images/mark1.flp || exit

mkdir tmp-loop && mount -t msdos /dev/vnd3c tmp-loop && cp source/kernel.bin tmp-loop/

cp programs/*.bin programs/*.bas programs/sample.pcx tmp-loop

echo "Unmounting temp"

umount tmp-loop || exit

vnconfig -u vnd3 || exit
rm -rf tmp-loop


echo "Creating iso image"

rm -f disk_images/mark1.iso
mkisofs -quiet -V 'MARK1' -r -J -o disk_images/mark1.iso -b mark1.flp disk_images/ || exit

echo 'Exit!'

