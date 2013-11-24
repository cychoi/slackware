======================================
Microlinux Enterprise Desktop 14.0 KDE (c) Niki Kovacs, <info@microlinux.fr>
======================================


  * Introduction
  * Installation
  * Download the Microlinux scripts
  * Configure 'slackpkg'
  * Trim and upgrade
  * Install the MLWS package collection
  * Set locales
  * Multilib stuff 
  * Clean up the applications menu
  * Finishing up
  * Using the NetworkManager


Introduction
------------

The Microlinux Enterprise Desktop 14.0 KDE is a full-blown production
desktop/workstation based on Slackware Linux 14.0 and a trimmed-down KDE 4.10.5
desktop with many enhancements.  

Check out http://www.microlinux.fr/mled_kde.php for more details.


Installation
------------

The following step-by-step instructions assume you already know how to install
a vanilla Slackware desktop. You will need a working internet connection.

The Microlinux Enterprise Desktop installs on top of a carefully selected
Slackware base. In order to avoid painstakingly picking each package, the
recommended method is to use the provided set of tagfiles. 

Boot the Slackware installation DVD (or the first CD). Select your keyboard
layout, login as root and partition your hard disk, but don't start the
installer yet.

Bring up your network interface, for example:

  root@slackware:/# dhcpcd eth0

The Slackware installation environment already sports an empty '/tag' directory
for a set of tagfiles, so let's use it.

  # cd /tag

Grab the set of tagfiles from the server:

  # wget http://www.microlinux.fr/slackware/desktop-kde-14.0-32bit/tagfiles.tar.gz

  /!\ The sets of tagfiles in the 32-bit and 64-bit subdirectories are
  symlinked and thus identical. 

Unpack the downloaded archive:

  # tar xvzf tagfiles.tar.gz

Your '/tag' directory should now contain a series of directories corresponding
to the Slackware package sets:

  # ls
  a/ ap/ d/ e/ f/ k/ kde/ kdei/ l/ n/ t/ tcl/ x/ xap/ xfce/ y/

Now start the Slackware installer:

  # setup
 
PACKAGE SERIES SELECTION: accept the default package selection, since the
tagfiles will override this and take care of selecting each package anyway.

SELECT PROMPTING MODE: 'tagpath - Use tagfiles in the subdirectories of a
custom path'

Path to tagfiles: '/tag'

USE UTF-8 TEXT CONSOLE: 'Yes'

CONFIRM STARTUP SERVICES TO RUN: accept the default selection

SELECT DEFAULT WINDOW MANAGER FOR X : 'xinitrc.wmaker' 

  /!\ This choice is only temporary, since KDE is not yet installed.

Finish the base Slackware installation. Eventually, chroot into the newly
installed environment and replace the HUGE kernel by the GENERIC kernel (that's
what I usually do). Exit and reboot.


Download the Microlinux scripts
-------------------------------

I'm providing a few helper scripts and ready-to-use configuration files to
speed up the installation process. Grab the whole Microlinux file tree using
the following command:

  # cd
  # git clone https://github.com/kikinovak/slackware


Configure 'slackpkg'
--------------------

Download and install the 'slackpkg+' plugin for 'slackpkg'. It's very
convenient for handling third-party repositories like MLED.

  # links http://slakfinder.org/slackpkg+

Grab the package from the 'pkg/' directory and install it.

Edit '/etc/slackpkg/mirrors' and choose a Slackware mirror according to your
geographical location, for example:

--8<---------- /etc/slackpkg/mirrors -----------------------------------------
...
# FRANCE (FR)
ftp://mirror.ovh.net/mirrors/ftp.slackware.com/slackware64-14.0/
...
--8<--------------------------------------------------------------------------

  /!\ Make sure you choose only one single mirror for Slackware stable.

Configure 'slackpkg+':

  # cd /etc/slackpkg
  # mv slackpkgplus.conf slackpkgplus.conf.orig

On 32-bit Slackware:

--8<---------- /etc/slackpkg/slackpkgplus.conf -------------------------------
# /etc/slackpkg/slackpkgplus.conf
SLACKPKGPLUS=on
VERBOSE=1
USEBL=1
PKGS_PRIORITY=( desktop-base:.* desktop-kde:.* )
REPOPLUS=( desktop-base desktop-kde slackpkgplus )
MIRRORPLUS['desktop-base']=http://www.microlinux.fr/slackware/desktop-base-14.0-32bit
MIRRORPLUS['desktop-kde']=http://www.microlinux.fr/slackware/desktop-kde-14.0-32bit
MIRRORPLUS['slackpkgplus']=http://slakfinder.org/slackpkg+/
--8<--------------------------------------------------------------------------

On Slackware64:

--8<---------- /etc/slackpkg/slackpkgplus.conf -------------------------------
# /etc/slackpkg/slackpkgplus.conf
SLACKPKGPLUS=on
VERBOSE=1
USEBL=1
PKGS_PRIORITY=( multilib:.* desktop-base:.* desktop-kde:.* )
REPOPLUS=( multilib desktop-base desktop-kde slackpkgplus )
MIRRORPLUS['multilib']=http://taper.alienbase.nl/mirrors/people/alien/multilib/14.0/
MIRRORPLUS['desktop-base']=http://www.microlinux.fr/slackware/desktop-base-14.0-64bit/
MIRRORPLUS['desktop-kde']=http://www.microlinux.fr/slackware/desktop-kde-14.0-64bit/
MIRRORPLUS['slackpkgplus']=http://slakfinder.org/slackpkg+/
--8<--------------------------------------------------------------------------

  /!\ There are ready-to-use configuration files in the GIT file tree you
  downloaded. Just copy 'desktop-kde-14.0-{32,64}bit/config/slackpkgplus.conf'
  to '/etc/slackpkg'. Chooses the right file depending on your processor
  architecture.

Update GPG keys :

  # slackpkg update gpg

Update information about available packages:

  # slackpkg update


Trim and upgrade
----------------

In case you didn't use the set of tagfiles during the initial installation,
now's the time to eventually catch up on it. The 'tools' directory provides a
basic 'trim-desktop-kde.sh' script that takes care of two things:

  1. install needed packages
  2. get rid of unneeded packages

The script makes use of 'slackpkg', so make sure it's configured correctly.

  # cd slackware/desktop-kde-14.0-32bit/tools/
  # ./trim-desktop-kde.sh

  /!\ You may use this script in Slackware64. The script in the 64-bit file
  tree is only a symlink to the script above.

If you don't use the 'trim-desktop-kde.sh' script, then you still have to
install the MPlayer plugin from 'extra/' manually:

  # slackpkg install mplayerplug-in

Now upgrade the base Slackware packages:

  # slackpkg upgrade-all

Three important remarks on this initial upgrade:

  1. Don't shoot yourself in the foot when upgrading the kernel.

  2. The odd existing package will be upgraded and replaced by an MLED package.
  Don't worry, this is normal.

  3. On Slackware64, you'll notice your gcc-* and glibc-* packages will be
  replaced by Multilib versions. Again, don't worry, this is also meant to be.


Multilib stuff
--------------

On Slackware64, you may want to add applications like VirtualBox, Wine, Skype,
etc. This is why 'slackpkg+' has been preconfigured to make use of Eric
Hameleers' Multilib packages. 

The initial system upgrade we've just performed has already replaced your base
gcc-* and glibc-* packages by the respective Multilib versions. The only thing
that's left to do now is to install the complete set of additional 32-bit
support libraries. This can be done in one simple step using the following
command:

  # slackpkg install compat32


Install the MLED package collection
-----------------------------------

MLED 14.0 packages come in two big sets of packages :

  * MLED 14.0 Base: the base set of desktop-agnostic packages
  * MLED 14.0 KDE : packages specific to the KDE desktop

The easiest way to install both package sets is to use the included install
scripts in the respective 'tools/' directories.

First, install the set of Base packages:

  # cd desktop-base-14.0-32bit/tools
  # ./install-desktop-base.sh
  # cd ../..

Then, install KDE-specific packages

  # cd desktop-kde-14.0-32bit/tools
  # ./install-desktop-kde.sh

  /!\ Scripts in the 64-bit subdirectories are really just symlinks to those in
  the 32-bit directories, so you can use either on a 32-bit and a 64-bit
  system.


Set locales
-----------

Now you'll probably have to adjust your environment variables in
'/etc/profile.d/lang.sh'. Default variables are set to fr_FR.UTF8, since MLED's
main use is in France:

--8<---------- /etc/profile.d/lang.sh ----------------------------------------
export LANG=fr_FR.utf8
export LC_COLLATE=fr_FR.utf8
--8<--------------------------------------------------------------------------

English-speaking Slackware users will use something like this:

--8<---------- /etc/profile.d/lang.sh ----------------------------------------
export LANG=en_US.utf8
export LC_COLLATE=en_US.utf8
--8<--------------------------------------------------------------------------


Clean up the applications menu
------------------------------

The 'tools/' directory features the 'cleanmenu' utility, a small Bash script to
clean up various desktop menu entries and make them Joe-Sixpack-friendly. Run
this utility:

  # cd tools/
  # ./cleanmenu

  /!\ The script replaces many '*.desktop' files in '/usr/share/applications'
  and similar locations by some custom-made menu entry files. For now, they're
  only localized in english, french and german, so you may not want to run the
  script if you use another language.


Finishing up
------------

We're almost there. Here's what's left to be done.

  1. Configure the X.org server. 

  2. Define one or more normal users for the system.

  3. Switch to default runlevel 4.

Reboot and enjoy your shiny new Microlinux Enterprise Workstation.


                                    Niki Kovacs, Fri Aug 23 06:26:42 CEST 2013

------------------------------------------------------------------------------
# vim: syntax=txt

