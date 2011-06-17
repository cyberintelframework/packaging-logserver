#!/usr/bin/perl

$buildroot = "/root/rpmbuild";
$svnurl = "http://svn.ids.surfnet.nl/surfids";
$pack = "logserver";
$package = "surfids-logserver";
$version = "3.10";
$subtree = "tags";
$release = "stable-3.10";

print "\n##### SVN EXPORT\n";
chdir("$buildroot/SPECS/");
#$out = `svn export $svnurl/packaging/$pack/trunk/buildrpm/SPECS/$package.spec`;
#print $out;
chdir("$buildroot/SOURCES/");
$out = `svn export $svnurl/$pack/$subtree/$release/ ./$package-$version/`;
print $out;
$out = `svn export $svnurl/packaging/$pack/trunk/debian/cron.d ./$package-$version/cron.d`;
print $out;
print "\n##### CREATING TAR\n";
$out = `tar -cvzf $package-$version.tar.gz $package-$version/`;
print $out;
chdir($buildroot);
print "\n##### RPMBUILD\n";
$out = `rpmbuild --define '_topdir $buildroot' -ba SPECS/$package.spec 2>&1`;
print $out;
print "\n##### CLEANING UP\n";
`rm -rf $buildroot/SOURCES/$package-$version/`;
`rm -rf $buildroot/TMP/$package-$version/`;
`rm -rf $buildroot/BUILD/$package-$version/`;
