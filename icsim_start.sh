#! /bin/bash

#==============================================================================
# A script to start up controls and icsim (ICSim by Craig Smith
# https://github.com/zombieCraig/ICSim)
# along with cansniffer (can-utils project at
# https://gitorious.org/linux-can/can-utils/commits/18f8416a40cf76e86afded174a52e99e854b7f2d)
#
# Author: David Lambert MCSE, BSCS  DavidLambertCyber@gmail.com
#
# If you used my can_stuff_install.sh script then there is nothing to do.
#
# If you installed them on your own and changed the git repository,
# set the ICSIMDIR to the directory installed ICSim,
# with trailing slash (see config section).
#
# tested on Ubuntu 14.04 LTS amd64
#==============================================================================

#==== config ==================================================================

# change if you changed the git repository for ICSim or changed icsim_install.sh
ICSIMDIR='/usr/share/ICSim/'

# turn on off seed logging
LOGSEEDS=true

# the full path file you wish to log the seeds
SEEDSLOGFILE='/var/log/icsim_seeds.log'

#===== end config =============================================================



#==== globals =================================================================

CHECKVCAN=$(ifconfig)
RANSEED=$(date +"%s")
LEVEL=
RAN=0
ASEED=

#==== define functions ================================================

start_vcan0_iface()
{
  echo 'Initializing vcan0 interface'
  sudo modprobe can
  sudo modprobe vcan
  sudo ip link add dev vcan0 type vcan
  sudo ip link set up vcan0
  sleep 1
}

start_normal()
{
  (cd $ICSIMDIR && sudo cansniffer -c vcan0 &)
  sleep 2
  (cd $ICSIMDIR && sudo ./controls vcan0 &)
  sleep 2
  (cd $ICSIMDIR && sudo ./icsim vcan0 &)
  sleep 2
}

start_seed()
{

  (cd $ICSIMDIR && sudo cansniffer -c vcan0 &)
  sleep 2
  (cd $ICSIMDIR && sudo ./controls -s $RANSEED vcan0 &)
  sleep 2
  (cd $ICSIMDIR && sudo ./icsim -s $RANSEED vcan0 &)
  sleep 2
}

start_seed_level()
{
  (cd $ICSIMDIR && sudo cansniffer -c vcan0 &)
  sleep 2
  (cd $ICSIMDIR && sudo ./controls -s $RANSEED -l $LEVEL vcan0 &)
  sleep 2
  (cd $ICSIMDIR && sudo ./icsim -s $RANSEED vcan0 &)
  sleep 2
}

log_seeds()
{
if [[ $LOGSEEDS == 'true' ]]; then
  echo "$(date) -- seed -- $RANSEED" >> $SEEDSLOGFILE
fi
}

usage()
{
  echo '  A script to simply start icsim, controls, and cansniffer.'
  echo '  More options avalible when using them manually' 
  echo ''
  echo "  Usage: $0 [-hr] [-s <seed>] [-l <level>] "
  echo ''
  echo '  Cannot use -s and -r at same time.'
  echo ''
  echo '    -r  random'
  echo '    -h  this help'
  echo '    -l  controls difficulty level. 0-2 (default: 1)'
  echo '    -s  seed value used in controls and icsim'
  echo ''
  echo "  A $SEEDSLOGFILE file"
  echo '    will log all seeds used, you can turn this off.'
  echo '    by editing this script (LOGSEEDS=false).'
  echo ''
  echo '  This script must be run as root (sudo su).'
  echo ''
  exit 1
}


#==== run =============================================================

if [[ $EUID -ne 0 ]]; then
  usage
fi

if [[ $CHECKVCAN != *vcan0* ]]; then
  start_vcan0_iface
fi


if [[ -z $1 ]]; then
  start_normal
  sleep 1
  exit 0
fi


while getopts “hrl:s:” OPTION
do
  case $OPTION in
    h)
      usage
      ;;
    l)
      LEVEL=$OPTARG
      ;;
    r)
      RAN=1
      ;;
    s)
      ASEED=$OPTARG
      ;;
    ?)
      usage
      exit 0
      ;;
  esac
done

if [[ (-z $ASEED) && (-z $LEVEL) && ($RAN -eq 0) ]]; then
  start_normal
  sleep 1
  log_seeds
  exit 0
elif [[ (-z $ASEED) && (-z $LEVEL) && ($RAN -eq 1) ]]; then
  start_seed
  sleep 1
  log_seeds
  exit 0
elif [[ (-z $ASEED) && (! -z $LEVEL) ]]; then
  start_seed_level
  sleep 1
  log_seeds
  exit 0
elif [[ (! -z $ASEED) && (-z $LEVEL) && ($RAN -eq 0) ]]; then
  RANSEED="$ASEED"
  start_seed
  sleep 1
  log_seeds
  exit 0
elif [[ (! -z $ASEED) && ($RAN -eq 1) ]]; then
  usage
  exit 1
elif [[ (! -z $ASEED) && (! -z $LEVEL) && ($RAN -eq 0) ]]; then
  RANSEED="$ASEED"
  start_seed_level
  sleep 1
  log_seeds
  exit 0
else
  usage
  exit 1
fi
