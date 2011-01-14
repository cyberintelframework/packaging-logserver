#!/usr/bin/perl

# Checks the config and each config item for usage
# Config items with 0 usage should be checked and/or deleted

$config = "/opt/surfnetids/logserver/trunk/surfnetids-log.conf";
$dst = "/opt/surfnetids/logserver/trunk/";

@confitems = `cat $config | grep c_ | grep -v \\\# | awk -F\\\$ '{print \$2}' | awk '{print \$1}'`;

foreach $item (@confitems) {
    chomp($item);
    $chk = `grep -R $item $dst | grep -v \\.svn | grep -v surfnetids-log.conf | grep -v serverconfig.php | wc -l`;
    chomp($chk);
    print "$item - $chk\n";
}
