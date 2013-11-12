#!/bin/bash
RSYNC=$(which rsync)
CWD=$(pwd)
LOCALSTUFF="$CWD/../../server-14.0-32bit $CWD/../../server-14.0-source"
RSYNCUSER=kikinovak
SERVER=nestor
SERVERDIR=/srv/httpd/vhosts/mirror/htdocs/microlinux
$RSYNC -av $LOCALSTUFF $RSYNCUSER@$SERVER:$SERVERDIR 

