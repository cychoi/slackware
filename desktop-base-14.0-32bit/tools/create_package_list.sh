#!/bin/sh
#
CWD=$(pwd)
ls $CWD/../../desktop-base-14.0-source \
  > /tmp/all.txt
cat /tmp/all.txt \
  | grep -v all.SlackBuild \
  | grep -v build_order \
  | grep -v openoffice-langpack \
  > $CWD/pkglists/packages-desktop-base
