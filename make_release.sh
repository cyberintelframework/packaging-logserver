#!/bin/sh

KEYID=91987C36
MAKEROOT=/home/build/logserver
DIST=lenny
REPOSITORY=/opt/surfnetids/repositories/surfids

# Static location of the chroot images
CHROOTBUILD=/home/build/chrootimg/$DIST.tgz
CHROOTTEST=/home/build/chrootimg/$DIST_test.tgz
MIRROR=http://ftp.nl.debian.org/debian
PACKAGE=surfids-logserver

# Clean up previous build
cd $MAKEROOT
rm ${PACKAGE}_*

# Update or create the chroot environment
if [ -e $CHROOTBUILD ]
then
    sudo pbuilder --update --basetgz $CHROOTBUILD --distribution $DIST --mirror $MIRROR
else
    sudo pbuilder --create --basetgz $CHROOTBUILD --distribution $DIST --mirror $MIRROR
fi


## Update to latest version
# If this fails, please checkout the sensor trunk:
# cd $MAKEROOT
#  svn co http://svn.ids.surfnet.nl/surfids/logserver/trunk

# download temporary trunk
svn export http://svn.ids.surfnet.nl/surfids/logserver/trunk $MAKEROOT/trunk/
cd $MAKEROOT/trunk

# cleanup build trunk
rm -rf $MAKEROOT/$PACKAGE/opt/surfnetids/
mkdir $MAKEROOT/$PACKAGE/opt/surfnetids/

# copy temporary trunk to build trunk dir
cp -R ./* $MAKEROOT/$PACKAGE/opt/surfnetids/

# setup /etc directory
mv $MAKEROOT/$PACKAGE/opt/surfnetids/surfnetids-log.conf $MAKEROOT/$PACKAGE/etc/surfnetids/
mv $MAKEROOT/$PACKAGE/opt/surfnetids/surfnetids-log-apache.conf $MAKEROOT/$PACKAGE/etc/surfnetids/

# setup permissions
chmod -x $MAKEROOT/$PACKAGE/opt/surfnetids/webinterface/images/worldflags/*.gif
chmod -R -x $MAKEROOT/$PACKAGE/opt/surfnetids/webinterface/include/*
chmod -x $MAKEROOT/$PACKAGE/etc/surfnetids/surfnetids-log-apache.conf
cd $MAKEROOT

# delete temporary trunk download
rm -rf $MAKEROOT/trunk/
cd $MAKEROOT/$PACKAGE

# Increment changelog entry
dch -i -m
#svn commit

## create the package
pdebuild -- --basetgz $CHROOTBUILD
#dpkg-deb --build $PACKAGE

### Test the package
#if [ -s $CHROOTTEST ]
#then
#    sudo piuparts -b  $CHROOTTEST -d $DIST *.deb -m $MIRROR
#else
#    sudo piuparts -s  $CHROOTTEST -d $DIST *.deb -m $MIRROR
#   # check exit code
#fi


# Collect results and sign
cd $MAKEROOT
sudo mv /var/cache/pbuilder/result/${PACKAGE}_* .
debsign -k$KEYID ${PACKAGE}_*_i386.changes

# add package to repository
cd $REPOSITORY
sudo reprepro --keepunreferencedfiles include $DIST $MAKEROOT/$PACKAGE_*_i386.changes
