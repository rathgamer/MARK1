#!/bin/sh

# This script assembles the MikeOS bootloader, kernel and programs
# with NASM, and then creates floppy and CD images (on Linux)

# Only the root user can mount the floppy disk image as a virtual
# drive (loopback mounting), in order to copy across the files

# (If you need to blank the floppy image: 'mkdosfs disk_images/mark.flp')


if test "`whoami`" != "root" ; then
	echo "You must be logged in as root to build (for loopback mounting)"
	echo "Enter 'su' or 'sudo bash' to switch to root"
	exit
fi


if [ ! -e disk_images/mark1.flp ]
then
	echo ">>> Creating new Mark1"
	mkdosfs -C disk_images/mark1.flp 1440 || exit
fi


echo "Building bootloader..."

nasm -O0 -w+orphan-labels -f bin -o source/bootload/bootload.bin source/bootload/bootload.asm || exit


echo "Building Mark1 kernel..."

cd source
nasm -O0 -w+orphan-labels -f bin -o kernel.bin kernel.asm || exit
cd ..


echo "Building programs"

cd programs

for i in *.asm
do
	nasm -O0 -w+orphan-labels -f bin $i -o `basename $i .asm`.bin || exit
done

cd ..


echo "Adding bootloader to iso file"

dd status=noxfer conv=notrunc if=source/bootload/bootload.bin of=disk_images/mark1.flp || exit


echo "Copying Mark 1 kernel and programs"

rm -rf tmp-loop

mkdir tmp-loop && mount -o loop -t vfat disk_images/mark1.flp tmp-loop && cp source/kernel.bin tmp-loop/

cp programs/*.bin programs/*.bas programs/sample.pcx tmp-loop

sleep 0.2

echo "Unmounting temp files"

umount tmp-loop || exit

rm -rf tmp-loop


echo "Creating ISO image"

rm -f disk_images/mark1.iso
mkisofs -quiet -V 'MARK1' -input-charset iso8859-1 -o disk_images/mark1.iso -b mark1.flp disk_images/ || exit

echo 'Exit!'

