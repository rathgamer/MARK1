#!/bin/sh

# This script starts the QEMU PC emulator, booting from the
# Mark 1 floppy disk image

qemu-system-i386 -soundhw pcspk -drive format=raw,file=disk_images/mark1.flp,index=0,if=floppy
