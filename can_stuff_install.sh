#! /bin/bash

#=================================================================================
# A script to install ICSim by Craig Smith, can-utils, and dependancies.
# Author: David Lambert MCSE, BSCS  DavidLambertCyber@gmail.com
#
# run as root
# tested on ubuntu 14.04 LTS amd64
# the sleep commands are overkill as a simple wait command
#================================================================================


# The directory you want to install can-utils and ICSim
# use full path with training slash
# a change here will require a change in icsim_start.sh
INSTALLDIR='/usr/share/'

#===== functions =================================================================

install_icsim()
{
  # get icsim
  cd $INSTALLDIR
  git clone https://github.com/zombieCraig/ICSim.git

  cd "$INSTALLDIR"'ICSim/'
  make
  sleep 1
  make install 
}

install_can_utils()
{
  # clone can-utils
  cd $INSTALLDIR
  git clone https://git.gitorious.org/linux-can/can-utils.git
  sleep 1

  # make can-utils
  cd "$INSTALLDIR"'can-utils/'
  sleep 1
  make
  sleep 1
  make install
  sleep 1

}

update_can_utils()
{
  cd "$INSTALLDIR"'can-utils/'
  git pull
  sleep 1
  make clean
  sleep 1
  make
  sleep 1
  make install
}

update_icsim()
{
  cd "$INSTALLDIR"'ICSim/'
  git pull
  sleep 1
  make clean
  sleep 1
  make
}

first_install()
{
  # dependancies
  apt-get install -y libsdl2-2.0-0 libsdl2-dev libsdl2-image-2.0-0 libsdl2-image-dev git make gcc unzip
  sleep 1

  install_icsim

  install_can_utils
}

complete()
{
  # done
  echo "  $0 is complete"
  echo '  You should now reboot'
  exit 0
}

usage()
{
  echo ''
  echo "  Usage: $0 [-ChI] "
  echo ''
  echo '    -C  pull can-utils from gitorious and compile'
  echo '    -h  this help'
  echo '    -I  pull ICSim from github and compile'
  echo ''
  echo '  No arguments does a first install'
  echo ''
  echo '  This script must be run as root (sudo su)'
  echo ''
  exit 1
}

#==== run =============================================================================

# check if root
if [[ $EUID -ne 0 ]]; then
   usage
   exit 1
fi

if [[ -z $1 ]]; then
  first_install
  complete
  exit 0
fi

while getopts “hIC” OPTION
do
  case $OPTION in
    h)
      usage
      ;;
    I)
      update_icsim
      ;;
    C)
      update_can_utils
      ;;
    ?)
      usage
      exit 0
      ;;
  esac
done

exit 0
