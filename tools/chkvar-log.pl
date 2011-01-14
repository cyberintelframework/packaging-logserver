#!/usr/bin/perl

# Checks the variables include and each variable for usage
# Variables with 0 usage should be checked and/or deleted

$config = "/opt/surfnetids/logserver/trunk/include/variables.inc.php";
$dst = "/opt/surfnetids/logserver/trunk/";

@confitems = `cat $config | grep v_ | grep -v \\\# | awk -F\\\$ '{print \$2}' | awk '{print \$1}'`;

foreach $item (@confitems) {
    chomp($item);
    $chk = `grep -R $item $dst | grep -v \\.svn | grep -v variables.inc.php | wc -l`;
    chomp($chk);
    print "$item - $chk\n";
}
