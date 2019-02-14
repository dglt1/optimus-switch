# optimus-switch
scripts/config's to switch between an nvidia prime setup and an intel only setup and fully disable/power-down the nvidia gpu to extend battery life.

the bash script's and various .conf files can be used to either setup nvidia prime and leave it or be used to easily switch between nvidia/intel (prime) using the proprietary nvidia driver, and intel only using either modesetting or intel driver. 

i made these so that in the unlikely event im ever away from AC power, i can quickly run a script, reboot, and use only the integrated intel gpu and also completely power down the nvidia gpu in a way that does not break sleep/suspend or lock up on shutdown, etc... you get the point.  and when i want my performance back i can run set-nvidia.sh , reboot and be back to using nvidia/intel (prime).

when the set-intel.sh is run, the appropriate config's in /etc/modprobe.d/ , /etc/X11/xorg.conf.d , /usr/local/bin/optimus.sh are replaced with the various .conf files for an intel only session. this will remove/replace the configurations set by set-nvidia.sh

when set-nvidia.sh is run, the various provided configs for an intel/nvidia (prime) setup will remove/replace the intel only configuration that was created by running set-intel.sh

right now the way i have the 2 scripts and the .conf files setup, they are at the moment for use with LightDM using a display setup script that is also removed/replaced each time set-intel.sh or set-nvidia.sh  is run so the script can be used for disabling the nvidia gpu when using intel only, but not disable nvidia when using the nvidia(for obvious reasons).

i will likely write up a systemd service in the next day or two to handle running the correct script instead of using the display setup script in LightDM to handle it, this way it can be used universally and not dependant on any given display manager.

the remove/replace actions could probably be replaced with symlinks instead but i have not tested this method yet.

this combination of scripts/configs were written and intended for my own use on Manjaro xfce/openbox so im not sure if they would require modification for other distro's.

requirements:
 - proprietary nvidia drivers (video-nvidia).
 - intel drivers (xf86-video-intel in manjaro's repo).
 - modesetting could be used as an alternative to intel drivers and requires no additional driver package.
 - acpi_call (either acpi_call-dkms or the acpi_call for your kernel version)
 
 
 setup instructions:
 
 git clone https://github.com/dglt1/optimus-switch/
 
 to be continued......
 
 
