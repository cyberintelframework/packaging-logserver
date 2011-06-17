#!/usr/bin/perl

$svnurl = "http://svn.ids.surfnet.nl/surfids";
$package = "logserver";
$version = "3.10";
$subtree = "tags";
$release = "stable-3.10";

##### DO NOT EDIT
$sourcedir = "./SOURCES/surfids-$package-$version";

# Downloading sources
`svn export $svnurl/$package/$subtree/$release/ $sourcedir/`;

# Deleting obsolete stuff
`rm -f $sourcedir/install_log.pl`;
`rm -f $sourcedir/functions_log.pl`;
`rm -f $sourcedir/logserver_remove.txt`;

# Creating .tar.gz
`tar -cvzf ./SOURCES/surfids-$package-$version.tar.gz $sourcedir/`;

# Building RPM
`rpmbuild -ba ./SPECS/surfids-$package.spec`;

