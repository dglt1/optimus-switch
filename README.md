# optimus-switch for LightDM

## Introduction

If you're looking for the SDDM or GDM versions, you can get to those repo's here https://github.com/dglt1 this is the completed version of my previous optimus-switch scripts for LightDM. 

Includes an install script to remove conflicting configurations, blacklists, loading of drivers/modules. Made by a manjaro user for use with manjaro linux. (other distros would require modification)


This install script and accompanying scripts/.conf files will setup an intel/nvidia PRIME setup that will provide the best possible performance for your intel/nvidia optimus laptop. This will also allow for easy switching between intel/nvidia (prime) mode and an intel only mode that also completely powers down and removes the nvidia gpu from sight allowing for improved battery life, and not negatively effect sleep/suspend cycles (hangs/lockups).

This script by default is for an intel gpu with a `~~BusID 0:2:0~~` EDIT: intel BusID is only needed if intel drivers require it to work (i have not found this to be the case). And an nvidia gpu with `BusID 01:00:0` you can verify this in terminal with this command `lspci | grep -E 'VGA|3D'` if yours does not match, edit `/optimus-switch/switch/intel/intel-xorg.conf` to match your BusID and `/optimus-switch/switch/nvidia/nvidia-xorg.conf`  to match your nvidia BusID.

DO THIS BEFORE RUNNING INSTALL SCRIPT, that is, if you want it to work anyway.

Note: output like this `00:02.0 VGA` has to be formatted like this `0:2:0` in nvidia-xorg.conf for it to work properly.

## How to use

### Requirements

Check `mhwd -li` to see what video drivers are installed, for this to work, you need only video-nvidia installed, if you have others, start by removing them like this : 

```bash
sudo mhwd -r pci name-of-video-driver
``` 

Remove any/all mhwd installed gpu drivers besides video-nvidia.

If you dont already have video-nvidia installed, do that now:

```bash
sudo mhwd -i pci video-nvidia
```
Note: there has been a recent change to how nvidia drivers are handled and are now split into these options for better selection. so choose one that works with your hardware.
```
video-nvidia-340xx
video-nvidia-390xx
video-nvidia-418xx
video-nvidia-430xx
video-nvidia-435xx
```

Replace linuxXXX-headers with the kernel version/s your using, for example linux419-headers is for the 4.19 kernel, so edit to match)

 ```bash
 sudo pacman -S linuxXXX-headers acpi_call-dkms xorg-xrandr xf86-video-intel git
 sudo modprobe acpi_call
 ```

### Cleaning

If you have any custom video/gpu .conf files in the following directories, backup/delete them. (they can not remain there), the install script removes the most common ones, but custom file names wont be noticed. only you know if they exist. And clearing the entire directory would likely break other things, this install will not do that. 

So clean up those folders if necessary :

```
/etc/X11/
/etc/X11/mhwd.d/
/etc/X11/xorg.conf.d/
/etc/modprobe.d/
/etc/modules-load.d/
```

### Installation

In terminal, from your home directory ~/  (this is important for the install script to work properly) :

```bash
git clone https://github.com/dglt1/optimus-switch.git
sudo chmod +x ~/optimus-switch/install.sh
cd ~/optimus-switch
sudo ./install.sh
```

~~Make sure to edit /etc/lightdm/lightdm.conf and scroll down to the [Seat:*] section, find/edit this line like this: `display-setup-script=/usr/local/bin/optimus.sh` remove the # at beginning of line. Save and exit.~~ 
#### Updated install script no longer requires you to manually edit lightdm.conf .

Done! after reboot you will be using intel/nvidia prime.  

To change the default mode to intel only, run:

```bash
sudo set-intel.sh
```

To switch the default mode to intel/nvidia prime, run: 

```bash
sudo set-nvidia.sh
```

Done!

### Usage

Switch as often as you like. both intel mode and prime mode work without any issues that i know of, please make me aware - of any issues so i may fix them, or make note of how you have already fixed it for yourself.

You may notice that after you boot into the intel only mode that the nvidia gpu is not yet disabled and its because you - cant run a proper test to see which acpi_call to use while using the nvidia gpu (it hard locks up the system).

So once your booted into an intel only session run this in terminal: 

```bash
sudo /etc/switch/gpu_switch_check.sh
```

You should see a list of various acpi calls, find the one that says “works!” , copy it. and then: 

```bash
sudo nano /etc/switch/intel/no-optimus.sh
```
At the bottom you will see 2 lines #commented out, uncomment them (remove #) and if the acpi call is different from the one you just copied, edit/replace with the good one. if your nvidia BusID is not `1:00:0` edit BusID's on both lines that specify BusID's, save and exit. 

Then:

```bash
sudo set-intel.sh
reboot
```

The nvidia gpu should be disabled and no longer visible (inxi, mhwd, lspci wont see it). Let me know how it goes, or if you notice anything that could be improved upon. 

Note: if you see errors about “file does not exist” when you run install.sh its because it’s trying to remove the usual mhwd-gpu/nvidia files that you may/may not have removed.

Only errors after "copying" starts should be of any concern. If you could save the output of the install script if you are having issues. this makes it much easier to troubleshoot.

### Usage after running install script:  

- `sudo set-intel.sh` will set intel only mode, reboot and nvidia powered off and removed from view.
- `sudo set-nvidia.sh`  sets intel/nvidia (prime) mode.

This should be pretty straight forward, if however, you cant figure it out, i am @dglt on the manjaro forum. i hope this is as useful for you as it is for me.

Added side-note, for persistent changes to configurations, modify the configurations used for switching located in `/etc/switch/nvidia/`  and  `/etc/switch/intel/`.

### There is now a DE/WM agnostic indicator made by linesma

This tool runs at startup and shows a tray icon showing which mode your using and allows you to switch modes easily without using CLI. 
https://github.com/linesma/manjaroptimus-appindicator
