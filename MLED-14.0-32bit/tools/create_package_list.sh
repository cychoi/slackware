#!/bin/sh
#

CWD=$(pwd)
SOURCEDIR="$CWD/../../MLED-14.0-source"
TEMPFILE="/tmp/all.txt"

echo "#####################" > $TEMPFILE
echo "# MLED package list #" >> $TEMPFILE
echo "#####################" >> $TEMPFILE

for PKGGROUP in ap d gnome l locale multimedia n profile x xap xfce; do
  echo >> $TEMPFILE
  echo "# $PKGGROUP" >> $TEMPFILE
  ls $SOURCEDIR/$PKGGROUP \
  >> $TEMPFILE
done
cat $TEMPFILE \
  | grep -v openoffice-langpack \
  | grep -v filezilla \
  | grep -v virtualbox \
  > $CWD/pkglists/packages-desktop-base

