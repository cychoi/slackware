#!/bin/sh
#
# trim_server_base.sh
#
# This script prepares the system before building or installing the Microlinux
# Enterprise Server. It removes unneeded packages and installs needed ones. You
# should run 'slackpkg update' before calling it.
#

CWD=$(pwd)
TMP=/tmp/pkg_database
CRUFT=$(egrep -v '(^\#)|(^\s+$)' $CWD/pkglists/server-base-remove)
INSTALL=$(egrep -v '(^\#)|(^\s+$)' $CWD/pkglists/server-base-add)

rm -rf $TMP
mkdir $TMP

echo
echo ":: Checking installed packages."
echo
sleep 3
for PACKAGE in $(find /var/log/packages); do
  PACKAGENAME=$(echo $PACKAGE |cut -f5 -d'/' |rev |cut -f4- -d'-' |rev)
  echo ":: Package $PACKAGENAME is installed on your system."
  touch $TMP/$PACKAGENAME
done

for PACKAGE in $CRUFT; do
  if [ -r $TMP/$PACKAGE ] ; then
    echo
    echo ":: Removing unneeded packages."
    echo
    sleep 3
    /sbin/removepkg ${PACKAGE} 
  fi
done

unset PACKAGES

for PACKAGE in $INSTALL; do
  if [ ! -r $TMP/$PACKAGE ] ; then
    PACKAGES="$PACKAGES $PACKAGE"
  fi
done

if [ -z "$PACKAGES" ]; then
  continue
else
  echo 
  echo ":: Installing necessary packages."
  echo 
  sleep 3
  /usr/sbin/slackpkg install $PACKAGES
fi

rm -rf $TMP

echo
echo ":: System is ready for building/installing MLES 14.0."
echo
