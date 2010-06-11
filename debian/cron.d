#
# Regular cron jobs for the surfids-logserver package
#
25 6 * * * root /opt/surfnetids/scripts/getsandbox.pl >/dev/null
*/15 * * * * root /opt/surfnetids/scripts/mailreporter.pl >/dev/null

