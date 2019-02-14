#!/bin/sh

#this script is run as a display setup script
#that replaces the one used by nvidia/prime.
##
#this disables the nvidia dGPU and
#removes it from /sys/bus/pce/devices
#for the current boot. this is reset after reboot.
# 

xrandr --auto
echo 'auto' > '/sys/bus/pci/devices/0000:02:00.0/power/control'
echo '\_SB.PCI0.PEG0.PEGP._OFF' > /proc/acpi/call
echo -n 1 > '/sys/bus/pci/devices/0000:02:00.0/remove'
