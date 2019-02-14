# optimus-switch
scripts/config's to switch between an nvidia prime setup and an intel only setup and fully disable/power-down the nvidia gpu to extend battery life.

the bash script's and various .conf files can be used to either setup nvidia prime and leave it or be used to easily switch between nvidia/intel (prime) using the proprietary nvidia driver, and intel only using either modesetting or intel driver. 

i made these so that in the unlikely event im ever away from AC power, i can quickly run a script, reboot, and use only the integrated intel gpu and also completely power down the nvidia gpu in a way that does not break sleep/suspend or lock up on shutdown, etc... you get the point.  and when i want my performance back i can run set-nvidia.sh , reboot and be back to using nvidia/intel (prime).
there are other options for optimus, bumblebee certainly does its job and allows for on-the-fly gpu enable/disable but also has its limitations, no vulkan support, and performance is not the best. optimus-manager is another, and more similar to this setup where a session can be run in intel only or intel/nvidia(prime) and it works for some but i was unable to get it working properly. this one just fits me best, it's simple, it works. you can decide for yourself if it's a good fit for you.

when the set-intel.sh is run, the appropriate config's in /etc/modprobe.d/ , /etc/X11/xorg.conf.d , /usr/local/bin/optimus.sh are replaced with the various .conf files for an intel only session. this will remove/replace the configurations set by set-nvidia.sh

when set-nvidia.sh is run, the various provided configs for an intel/nvidia (prime) setup will remove/replace the intel only configuration that was created by running set-intel.sh

right now the way i have the 2 scripts and the .conf files setup, they are at the moment for use with LightDM using a display setup script that is also removed/replaced each time set-intel.sh or set-nvidia.sh  is run so the script can be used for disabling the nvidia gpu when using intel only, but not disable nvidia when using the nvidia(for obvious reasons).

i will likely write up a systemd service in the next day or two to handle running the correct script instead of using the display setup script in LightDM to handle it, this way it can be used universally and not dependant on any given display manager.

the remove/replace actions could probably be replaced with symlinks instead but i have not tested this method yet.

this combination of scripts/configs were written and intended for my own use on Manjaro linux xfce/openbox so im not sure if they would require modification for other distro's.

requirements:
 - proprietary nvidia drivers (video-nvidia).
 - intel drivers (xf86-video-intel in manjaro's repo).
 - modesetting could be used as an alternative to intel drivers and requires no additional driver package.
 - acpi_call (either acpi_call-dkms or the acpi_call for your kernel version)
 - display setup script name/directory defined in the [seats:] section of lightdm.conf needs to match 
 
 setup instructions:
 - from terminal
 `git clone https://github.com/dglt1/optimus-switch/`
 
 

 - from terminal:
    `lspci | grep -E "VGA|3D"`
 - make note of the BusID's for both intel and nvidia gpu's , you may need them if they do not match the BusID's specified by default.
 - defaults are set as BusID "PCI:2:0:0" for nvidia gpu and   BusID "PCI:0:2:0" for intel gpu. 
 - if yours are different you will need to edit /switch/nvidia/nvidia-xorg.conf and /switch/intel/intel-xorg.conf and edit the "BusID" line to match the output of the lscpi command. if your output reads like this:
   -  `00:02.0 VGA compatible controller: Intel Corporation HD Graphics 530 (rev 06)`
   - then the BusID you would use for intel is "PCI:0:2:0". this is important so make sure its formatted properly.
    do the same for nvidia-xorg.conf  .


  - backup and remove any video related .conf files/blacklists in:
    - /etc/modprobe.d/
    - /etc/modules-load.d/
    - /etc/X11/mhwd.d/
    - /etc/X11/xorg.conf.d/
 
  - be sure that the display setup script defined in /etc/lightdm/lightdm.conf is uncommented and looks like this:
    - `display-setup-script=/usr/local/bin/optimus.sh `
  
  - now move the /switch directory and its subdirectories and files to /etc/ 
    - you should now have /etc/switch/intel  and /etc/switch/nvidia  . 
    - directory is important, these scripts depend on it. (or edit scripts to your liking)
    
  - from terminal:
     - `sudo cp /etc/switch/set-intel.sh /usr/local/bin/set-intel.sh`
     - `sudo cp /etc/switch/set-nvidia.sh /usr/local/bin/set-nvidia.sh`
 
 - **Done! now give it a try.
  
  - *Usage:*
   - `sudo set-intel.sh`
   - reboot and check it out, nvidia should be powered down and not visible on lspci or inxi -G .
   - OR
   - `sudo set-nvidia.sh`
   - reboot and your back on your intel/nvidia (prime) setup.
   - (right now reboot is required, may not be necessary soon)
  
  - few additional notes:
   - if your already setup for prime you could always copy/paste the contents of your currently working 
   -/etc/X11/xorg.conf.d/optimus.conf into /etc/switch/nvidia/nvidia-xorg.conf  
   - and replace whats in there now if you feel your current nvidia configuration works better for you.
   - if you want to use the modesetting driver for the intel only setup, just edit:
    - /usr/local/bin/set-instel.sh  
    - and change this line:
    - `cp /etc/switch/intel/intel-xorg.conf /etc/X11/xorg.conf.d/99-intel.conf`
    - with this line:
    - `cp /etc/switch/intel/modeset-xorg.conf /etc/X11/xorg.conf.d/99-intel.conf`

***********************************************************************************0
***********************************************************************************0
- this can also be used to setup prime first the first time.
  
  - remove all other video drivers listed from  command ` mhwd -li `
   - `sudo mhwd -r pci name-of-video-driver`
  - install video-nvidia 
   - `sudo mhwd -i pci video-nvidia`
  - follow previous install instructions for finding your nvidia gpu's BusID and edit 
   - /switch/nvidia/nvidia-xorg.conf  to correct nvidia BusID if necessary.
  - copy /switch directory, subdirectories/files to /etc/
  - backup/remove all existing video related configs from the directories listed above.
  - edit /etc/lightdm/lightdm.conf as mentioned above.
  - then:
   - `sudo chmod +x /etc/switch/set-nvidia.sh`
   - `sudo ./etc/switch/set-nvidia.sh`
   - `sudo chmod a+rx /usr/local/bin/optimus.sh`
   - `reboot`
  
  - you should now be using nvidia to do all the rendering and the intel gpu's only job is to
  display whats rendered. enjoy.
 
  - im planning on also making an install script so all the manual copying and other actions can be avoided
 
 - to be continued......  
 
 
