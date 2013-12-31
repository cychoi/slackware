#!/bin/sh
#
# Copyright (c) 2013 Niki Kovacs <info@microlinux.fr>
# -----------------------------------------------------------------------------
#
# This script parses the packages-MLED file in the pkglists directory and
# installs all listed packages using slackpkg. 
#
# The slackpkg+ plugin has to be installed and the MLED repository configured.
#

CWD=$(pwd)
PKGINFO=/tmp/pkg_database
INSTALL=$(egrep -v '(^\#)|(^\s+$)' $CWD/pkglists/packages-MLED)

rm -rf $PKGINFO
mkdir $PKGINFO

echo
echo "+=============================================================================="
echo "| Checking installed packages on your system..."
echo "+=============================================================================="
echo
sleep 3
for PACKAGE in $(find /var/log/packages); do
  printf "."
  PACKAGENAME=$(echo $PACKAGE |cut -f5 -d'/' |rev |cut -f4- -d'-' |rev)
  touch $PKGINFO/$PACKAGENAME
done

echo 
echo 
echo "+=============================================================================="
echo "| Checking for packages to be installed on your system..."
echo "+=============================================================================="
echo 
sleep 3
for PACKAGE in $INSTALL; do
  if [ ! -r $PKGINFO/$PACKAGE ] ; then
    PACKAGES="$PACKAGES $PACKAGE"
  fi
done

if [ -z "$PACKAGES" ]; then
  continue
else
  /usr/sbin/slackpkg install $PACKAGES
fi

rm -rf $PKGINFO

echo 
echo "+=============================================================================="
echo "| Microlinux Enterprise Desktop 14.1 installed!"
echo "+=============================================================================="
echo 
