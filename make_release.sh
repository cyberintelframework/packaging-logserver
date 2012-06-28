#!/bin/bash

KEYID=91987C36
MAKEROOT=/home/build/logserver
DIST=lenny
REPOSITORY=/opt/surfnetids/repositories/surfids
CHROOTBUILD=/home/build/chrootimg/$DIST.tgz
CHROOTTEST=/home/build/chrootimg/$DIST_test.tgz
MIRROR=http://ftp.nl.debian.org/debian
PACKAGE=surfids-logserver

cd $MAKEROOT
rm ${PACKAGE}_*

# Update or create the chroot environment
if [ -e $CHROOTBUILD ]
then
    sudo pbuilder --update --basetgz $CHROOTBUILD --distribution $DIST --mirror $MIRROR
else
    sudo pbuilder --create --basetgz $CHROOTBUILD --distribution $DIST --mirror $MIRROR
fi

svn export http://svn.ids.surfnet.nl/surfids/logserver/trunk $MAKEROOT/trunk/
cd $MAKEROOT/trunk

# OPT
rm -rf $MAKEROOT/$PACKAGE/opt/surfnetids/
mkdir -p $MAKEROOT/$PACKAGE/opt/surfnetids/

cp -R $MAKEROOT/trunk/* $MAKEROOT/$PACKAGE/opt/surfnetids/
chmod +x $MAKEROOT/$PACKAGE/opt/surfnetids/webinterface/include/flexi/
chmod +x $MAKEROOT/$PACKAGE/opt/surfnetids/webinterface/include/overlib/

# ETC
rm -rf $MAKEROOT/$PACKAGE/etc/surfnetids/
mkdir -p $MAKEROOT/$PACKAGE/etc/surfnetids/

mv $MAKEROOT/$PACKAGE/opt/surfnetids/surfnetids-log.conf $MAKEROOT/$PACKAGE/etc/surfnetids/
mv $MAKEROOT/$PACKAGE/opt/surfnetids/surfnetids-log-apache.conf $MAKEROOT/$PACKAGE/etc/surfnetids/

# DEBIAN
rm -rf $MAKEROOT/$PACKAGE/debian/
cd $MAKEROOT/$PACKAGE/
svn export http://svn.ids.surfnet.nl/surfids/packaging/logserver/trunk/debian/ debian/

# CLEANUP
rm -rf $MAKEROOT/trunk/
cd $MAKEROOT/$PACKAGE

# CHANGELOG
dch -i -m
sudo cp debian/changelog /opt/surfnetids/packaging/logserver/trunk/debian/

# BUILDING
pdebuild -- --basetgz $CHROOTBUILD

cd $MAKEROOT
sudo mv /var/cache/pbuilder/result/${PACKAGE}_* .
debsign -k$KEYID ${PACKAGE}_*_i386.changes

# ADDING TO REPO
#cd $REPOSITORY
#sudo reprepro --keepunreferencedfiles include $DIST $MAKEROOT/$PACKAGE_*_i386.changes
