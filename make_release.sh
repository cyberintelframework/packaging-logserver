#!/bin/sh

KEYID=000000
MAKEROOT=/home/build/logserver
DIST=lenny
REPOSITORY=/opt/surfnetids/repositories/surfids
CHROOTBUILD=$MAKEROOT/chrootimg/$DIST.tgz
CHROOTTEST=$MAKEROOT/chrootimg/$DIST_test.tgz
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
svn export http://svn.ids.surfnet.nl/surfids/logserver/trunk $MAKEROOT/trunk/
cd $MAKEROOT/trunk
cp -R ./* $MAKEROOT/$PACKAGE/opt/surfnetids/
mv $MAKEROOT/$PACKAGE/opt/surfnetids/surfnetids-log.conf $MAKEROOT/$PACKAGE/etc/surfnetids/
mv $MAKEROOT/$PACKAGE/opt/surfnetids/surfnetids-log-apache.conf $MAKEROOT/$PACKAGE/etc/surfnetids/
cd $MAKEROOT
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
sudo reprepro include $DIST $MAKEROOT/$PACKAGE_*_i386.changes
