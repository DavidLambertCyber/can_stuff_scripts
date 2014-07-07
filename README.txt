==============================================================================

A few scripts to start using: 
- ICSim by Craig Smith https://github.com/zombieCraig/ICSim

- can-utils project at
https://gitorious.org/linux-can/can-utils/commits/18f8416a40cf76e86afded174a52e99e854b7f2d)


You will need to give the scripts execute permissions
$ sudo chmod a+x can_stuff_install.sh icsim_start.sh

Testing done on Ubuntu 14.04 LTS amd64

Author: David Lambert MCSE, BSCS  DavidLambertCyber@gmail.com

==============================================================================
can_stuff_install.sh

Install all the dependencies for ICSim and can-utils.

You can adjust the default install directory (/usr/share/) but will require you 
to adjust icsim_start.sh accordingly.

Run as root
Requires reboot

===============================================================================
icsim_start.sh

Will start up icsim, controls, and cansniffer for you. There are a few configurations
in the config section but no changes required if you left the can_stuff_intstall.sh
as default. This is intended as a beginners script, you will get more functionality
by running things manually.

If you are new to CAN bus hacking then run
$ sudo icsim_start.sh -r 

Usage: icsim_start.sh [-hr] [-s <seed>] [-l <level>] 
  Cannot use -s and -r at same time.

    -r  icsim random seed
    -h  this help
    -l  controls difficulty level. 0-2 (default: 1)
    -s  seed value used in controls and icsim

  A /var/log/icsim_seeds.log file
    will log all seeds used, you can turn this off.
    by editing this script (LOGSEEDS=false).

  The controls window must be front/selected for hotkeys to work.

  This script must be run as root (sudo su).

=======================================================================================

