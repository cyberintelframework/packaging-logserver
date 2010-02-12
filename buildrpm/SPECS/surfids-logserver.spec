Summary: The logging server for the SURFids framework.
Name: surfids-logserver
Version: 3.02
Release: 1%{?dist}
License: GPL
Group: Applications/Internet
Source: surfids-logserver-3.02.tar.gz
URL: http://ids.surfnet.nl/
BuildRoot: /home/build/rpmbuild/surfids-logserver/BUILDROOT/
Requires: postgresql >= 8.3, httpd >= 2, mod_auth_pgsql, sendmail, xalan-j2, perl, php, php-pgsql, perl-DBI, perl-DBD-Pg, php-gd, gnupg, perl-IO-Socket-SSL

%define surfinstall /opt/surfnetids
%define surfconfig /etc/surfnetids

%description
The logserver component of the SURFids framework.

%prep
%setup -q
%install
rm -rf %{_buildroot}
# Create surfnetids directories
install -m 755 -d %{_buildroot}%{surfinstall}
install -m 755 -d %{_buildroot}%{surfconfig}
install	-m 755 -d %{_buildroot}/etc/cron.d/
install	-m 755 -d %{_buildroot}/var/log/
install	-m 755 -d %{_buildroot}/etc/httpd/conf.d/
mv -f * %{_buildroot}%{surfinstall}/
mv -f %{_buildroot}%{surfinstall}/surfnetids-log.conf %{_buildroot}%{surfconfig}/
mv -f %{_buildroot}%{surfinstall}/surfnetids-log-apache.conf %{_buildroot}%{surfconfig}/

# install important files
install -m 644 %{_buildroot}%{surfinstall}/cron.d %{_buildroot}/etc/cron.d/surfids-logserver
install -m 644 %{_buildroot}%{surfinstall}/htaccess.dist %{_buildroot}%{surfinstall}/webinterface/.htaccess
touch %{_buildroot}/var/log/surfids.log
chmod 640 %{_buildroot}/var/log/surfids.log

%clean

%post
ln -s %{surfconfig}/surfnetids-log-apache.conf /etc/httpd/conf.d/surfids-logserver.conf

%files
%defattr(-,root,root,-)
# Directory
%dir %{surfinstall}
%dir %{surfconfig}
# All it's subcontents
%{surfinstall}/*
%config %{surfconfig}/surfnetids-log.conf
%config %{surfconfig}/surfnetids-log-apache.conf
# Misc config files
/etc/cron.d/surfids-logserver
# surfids logfile
/var/log/surfids.log

%changelog
* Wed Aug 26 2009 SURFids Development Team <ids at, surfnet.nl> 3.02-1
- Fixed bug #176.
* Fri Aug 21 2009 SURFids Development Team <ids at, surfnet.nl> 3.01-1
- Fixed RSS bug. (#168)
* Wed Aug 19 2009 SURFids Development Team <ids at, surfnet.nl> 3.0-1
- Flash graphs.
- Centralized logging of all scripts via the webinterface (admin only).
- Sensor grouping.
- Mail reports with UTC time format.
- The ability to always let a mail report even if there's nothing to report. Useful for automated systems receiving the emails.
- Home page now configurable.
- Sensor status page now configurable.
