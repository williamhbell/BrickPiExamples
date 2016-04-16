# BrickPi example programs

By W. H. Bell [ http://www.whbell.net/ ]

## Software installation and configuration

### BrickPi software

From Raspbian Jessie, all of the packages needed to use the BrickPi with 
Scratch or Python can be installed by typing:
```
sudo ./bin/setup-brickpi.sh
```
This command also configures the Raspberry Pi, enabling the serial port 
and setting the rate for the serial port.  Once this script has been run,
the Raspberry Pi needs to be rebooted to use the updated serial port
configuration.

### TightVNC server

A VNC server allows the desktop of a robot to be accessed remotely.  Having
used raspi-config to set the Raspberry Pi to boot to the console, type:
```
sudo ./bin/setup-vncserver.sh
```
This will install the TightVNC server, together with a init.d script that
will start the VNC server when the Raspberry Pi is booted.  When the script
runs, it will prompt for a new password.  This is the password that should
be used to access the TightVNC server from a vncviewer.  To use the vnc server,
type
```
sudo /etc/init.d/tightvncserver start 
```
or reboot the Raspberry Pi

## Example programs

The Scratch example programs are given in the scratch/ directory.
Documentation is given in the scratch/doc/ directory.  Each example
can be run as described in the documentation or using the launch 
script.  For example, 

./bin/launchRpiScratchIO.sh scratch/src/simple.sb

will open the simple.sb Scratch program and start the Python code
that connects to the BrickPi.
